import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../models/user_model.dart';
import '../../domain/repositories/user_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// Handles editing the *currently signed-in* user's own profile.
///
/// Takes the starting [UserModel] from the caller (typically
/// `AuthBloc.state.user`, already loaded) rather than re-fetching it,
/// since the screen that opens the edit form already has it.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required UserRepository userRepository,
    required UserModel initialUser,
  })  : _userRepository = userRepository,
        _currentUser = initialUser,
        super(ProfileState(user: initialUser)) {
    on<ProfileUpdateSubmitted>(_onUpdateSubmitted);
    on<ProfileErrorCleared>(_onErrorCleared);
  }

  final UserRepository _userRepository;
  UserModel _currentUser;

  Future<void> _onUpdateSubmitted(
    ProfileUpdateSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.submitting, errorMessage: null));
    try {
      String? photoUrl = _currentUser.photoUrl;
      if (event.photoFile != null) {
        photoUrl = await _userRepository.uploadProfilePhoto(
          uid: _currentUser.id,
          file: event.photoFile!,
        );
      }

      final updated = _currentUser.copyWith(
        fullName: event.fullName,
        phone: event.phone,
        photoUrl: photoUrl,
        updatedAt: DateTime.now(),
      );

      await _userRepository.updateUser(updated);
      _currentUser = updated;

      emit(state.copyWith(status: ProfileStatus.success, user: updated));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: AppException.from(e).message,
        ),
      );
    }
  }

  void _onErrorCleared(ProfileErrorCleared event, Emitter<ProfileState> emit) {
    emit(state.copyWith(status: ProfileStatus.idle, errorMessage: null));
  }
}
