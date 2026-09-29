import 'package:firebase_auth/firebase_auth.dart';

import 'failure.dart';

/// Translates raw platform/SDK exceptions into clean [Failure]s.
///
/// This is the one place that should ever know about
/// [FirebaseAuthException] error codes or [FirebaseException] plugin
/// details — repositories call [AppException.from] and hand the resulting
/// [Failure] up to the bloc layer. UI code should never see a raw
/// exception or a Firebase error code.
class AppException {
  const AppException._();

  static Failure from(Object error) {
    if (error is FirebaseAuthException) {
      return _fromFirebaseAuth(error);
    }
    if (error is FirebaseException) {
      return _fromFirebase(error);
    }
    if (error is Failure) {
      return error;
    }
    return const UnknownFailure();
  }

  static Failure _fromFirebaseAuth(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return const AuthenticationFailure('That email address looks invalid.');
      case 'user-disabled':
        return const AuthenticationFailure('This account has been disabled.');
      case 'user-not-found':
        return const AuthenticationFailure('No account found with that email.');
      case 'wrong-password':
      case 'invalid-credential':
        return const AuthenticationFailure('Incorrect email or password.');
      case 'email-already-in-use':
        return const AuthenticationFailure('An account already exists with that email.');
      case 'weak-password':
        return const AuthenticationFailure('That password is too weak. Try a stronger one.');
      case 'too-many-requests':
        return const AuthenticationFailure('Too many attempts. Please wait and try again.');
      case 'network-request-failed':
        return const NetworkFailure();
      case 'requires-recent-login':
        return const AuthenticationFailure('Please log in again to continue.');
      default:
        return const AuthenticationFailure();
    }
  }

  static Failure _fromFirebase(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return const PermissionFailure();
      case 'unavailable':
      case 'deadline-exceeded':
        return const NetworkFailure();
      default:
        return const ServerFailure();
    }
  }
}
