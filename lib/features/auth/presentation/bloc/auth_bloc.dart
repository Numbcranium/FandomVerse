import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authRepository) : super(const AuthState.unknown()) {
    on<AuthSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthUserChanged>(_onUserChanged);
    on<AuthLoginSubmitted>(_onLoginSubmitted);
    on<AuthRegisterSubmitted>(_onRegisterSubmitted);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthPasswordResetSubmitted>(_onPasswordResetSubmitted);
    on<AuthErrorCleared>(_onErrorCleared);
  }

  final AuthRepository _authRepository;

  Future<void> _onSubscriptionRequested(
    AuthSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) async {
    await emit.forEach(
      _authRepository.authStateChanges,
      onData: (user) => state.copyWith(
        status: user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
        user: user,
        clearUser: user == null,
      ),
      onError: (_, __) => state.copyWith(status: AuthStatus.unauthenticated),
    );
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    // Reserved for manually pushing a user update (e.g. after editing a
    // profile in Phase 6) without waiting for Firestore's own listener.
    emit(
      state.copyWith(
        status: event.user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
        user: event.user,
        clearUser: event.user == null,
      ),
    );
  }

  Future<void> _onLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.authenticating, clearError: true));
    try {
      await _authRepository.signIn(email: event.email, password: event.password);
      // Success: the authStateChanges subscription above will emit
      // AuthStatus.authenticated once Firebase confirms the session.
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: AppException.from(e).message,
        ),
      );
    }
  }

  Future<void> _onRegisterSubmitted(
    AuthRegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.authenticating, clearError: true));
    try {
      await _authRepository.register(
        fullName: event.fullName,
        email: event.email,
        phone: event.phone,
        password: event.password,
      );
      // Success: handled by the authStateChanges subscription, as above.
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: AppException.from(e).message,
        ),
      );
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.signOut();
      // The authStateChanges subscription will emit unauthenticated.
    } catch (e) {
      emit(state.copyWith(errorMessage: AppException.from(e).message));
    }
  }

  Future<void> _onPasswordResetSubmitted(
    AuthPasswordResetSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.authenticating, clearError: true));
    try {
      await _authRepository.sendPasswordResetEmail(event.email);
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: AppException.from(e).message,
        ),
      );
    }
  }

  void _onErrorCleared(AuthErrorCleared event, Emitter<AuthState> emit) {
    emit(state.copyWith(clearError: true));
  }
}
