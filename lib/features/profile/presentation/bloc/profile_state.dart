import 'package:equatable/equatable.dart';

import '../../../../models/user_model.dart';

enum ProfileStatus { idle, submitting, success, error }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.idle,
    this.user,
    this.errorMessage,
  });

  final ProfileStatus status;
  final UserModel? user;
  final String? errorMessage;

  ProfileState copyWith({
    ProfileStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
