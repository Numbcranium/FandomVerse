import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<UserModel?> get authStateChanges {
    return _remoteDataSource.firebaseUserChanges.asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      try {
        return await _remoteDataSource.fetchUserDocument(firebaseUser.uid);
      } catch (_) {
        // A transient Firestore read failure shouldn't sign the user out
        // of the app's *concept* of auth — treat as "profile not loaded
        // yet" rather than "unauthenticated" would be ideal, but keeping
        // the starter simple: surface as signed-out and let the user
        // retry logging in.
        return null;
      }
    });
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );
      final uid = credential.user?.uid;
      if (uid == null) throw const AuthenticationFailure();

      final profile = await _remoteDataSource.fetchUserDocument(uid);
      if (profile == null) {
        throw const ServerFailure('Your profile could not be found.');
      }
      return profile;
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final credential = await _remoteDataSource.register(
        email: email,
        password: password,
      );
      final uid = credential.user?.uid;
      if (uid == null) throw const AuthenticationFailure();

      final now = DateTime.now();
      final newUser = UserModel(
        id: uid,
        fullName: fullName,
        email: email,
        phone: phone,
        role: UserRole.user,
        createdAt: now,
        updatedAt: now,
      );

      await _remoteDataSource.createUserDocument(newUser);
      return newUser;
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _remoteDataSource.sendPasswordResetEmail(email);
    } catch (e) {
      throw AppException.from(e);
    }
  }
}
