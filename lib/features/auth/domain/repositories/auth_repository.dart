import '../../../../models/user_model.dart';

/// Contract for authentication, independent of Firebase.
///
/// `AuthBloc` depends on this interface, not on `AuthRepositoryImpl`
/// directly — keeps the UI/state-management layer free of any Firebase
/// import and makes it possible to swap in a mock implementation for
/// tests or early frontend work (see `mock/mock_users.dart`, Phase 7).
///
/// Every method throws a [Failure] (never a raw platform exception) — see
/// `AppException.from`.
abstract class AuthRepository {
  /// Emits the current user's profile whenever auth state changes, and
  /// `null` when signed out. The first event may take a moment while the
  /// SDK restores a persisted session — the router treats that gap as
  /// `AuthStatus.unknown`.
  Stream<UserModel?> get authStateChanges;

  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  });

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> updatePassword(String newPassword);

  Future<void> deleteAccount();
}
