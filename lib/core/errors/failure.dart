import 'package:equatable/equatable.dart';

/// Base class for all application-level failures.
///
/// Repositories and blocs should deal in [Failure]s, never in raw
/// exceptions (Firebase or otherwise) — see [AppException] for how raw
/// exceptions get mapped into these.
abstract class Failure extends Equatable {
  const Failure(this.message);

  /// User-friendly message. Safe to show directly in the UI.
  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

/// No / lost internet connectivity, or a request timed out.
class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No internet connection. Please check your network and try again.',
  ]);
}

/// Login, registration, or session-related failures.
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([
    super.message = 'Authentication failed. Please check your details and try again.',
  ]);
}

/// The user isn't allowed to perform the requested action.
class PermissionFailure extends Failure {
  const PermissionFailure([
    super.message = 'You don\'t have permission to do that.',
  ]);
}

/// Client-side input validation failure (prefer [Validators] to catch this
/// before it ever reaches a repository, but repositories may still surface
/// server-side validation issues through this type).
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// The backend (Firestore, Cloud Functions, etc.) returned an error.
class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Something went wrong on our end. Please try again shortly.',
  ]);
}

/// Anything that doesn't fit the categories above.
class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'An unexpected error occurred. Please try again.',
  ]);
}
