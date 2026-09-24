import 'package:equatable/equatable.dart';

import '../../../../models/user_model.dart';

/// Where the app currently stands, authentication-wise.
///
/// [AppRouter] (see `app/router/app_router.dart`) reads this directly to
/// decide whether the user may see protected routes — [authenticating] is
/// intentionally treated the same as [unauthenticated] by the router (a
/// login/register submission in flight shouldn't unlock protected routes
/// early), while the login/register screens use it to show a button
/// spinner.
enum AuthStatus { unknown, authenticating, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.errorMessage,
  });

  const AuthState.unknown() : this(status: AuthStatus.unknown);

  final AuthStatus status;
  final UserModel? user;

  /// Set after a failed login/register/password-reset attempt. `null`
  /// otherwise. UI should dispatch `AuthErrorCleared` after showing it.
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
