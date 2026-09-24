import 'package:equatable/equatable.dart';

import '../../../../models/user_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched once, near app startup, to start listening to
/// `AuthRepository.authStateChanges`. Everything else the bloc does is
/// driven by that subscription or by the events below.
class AuthSubscriptionRequested extends AuthEvent {
  const AuthSubscriptionRequested();
}

/// Internal — pushed by the bloc's own stream subscription, not by the UI.
class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.user);

  final UserModel? user;

  @override
  List<Object?> get props => [user];
}

class AuthLoginSubmitted extends AuthEvent {
  const AuthLoginSubmitted({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterSubmitted extends AuthEvent {
  const AuthRegisterSubmitted({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
  });

  final String fullName;
  final String email;
  final String phone;
  final String password;

  @override
  List<Object?> get props => [fullName, email, phone, password];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthPasswordResetSubmitted extends AuthEvent {
  const AuthPasswordResetSubmitted(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

/// Clears `AuthState.errorMessage` — dispatch after showing the error
/// (e.g. in a SnackBar's `onVisible`) so it doesn't reappear on rebuild.
class AuthErrorCleared extends AuthEvent {
  const AuthErrorCleared();
}
