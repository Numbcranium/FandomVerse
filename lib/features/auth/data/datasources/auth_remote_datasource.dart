import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/firebase_constants.dart';
import '../../../../models/user_model.dart';

/// Raw Firebase Auth + Firestore calls for authentication.
///
/// This is the *only* file in `features/auth` allowed to import
/// `firebase_auth`/`cloud_firestore` directly. `AuthRepositoryImpl` talks
/// to this interface, never to Firebase itself.
abstract class AuthRemoteDataSource {
  /// Raw Firebase user stream (`null` when signed out).
  Stream<User?> get firebaseUserChanges;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  });

  Future<UserCredential> register({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> updatePassword(String newPassword);

  Future<void> deleteAccount();

  /// Writes the initial `users/{uid}` profile document right after
  /// registration.
  Future<void> createUserDocument(UserModel user);

  /// Reads `users/{uid}`. Returns `null` if the document doesn't exist yet
  /// (e.g. a brief gap between Firebase Auth creating the account and the
  /// Firestore write completing).
  Future<UserModel?> fetchUserDocument(String uid);
}

class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  FirebaseAuthRemoteDataSource({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection(FirebaseConstants.usersCollection);

  @override
  Stream<User?> get firebaseUserChanges => _firebaseAuth.authStateChanges();

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> register({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    }
  }

  @override
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final uid = user.uid;
      // Delete user's firestore document
      await _usersRef.doc(uid).delete();
      // Delete auth account
      await user.delete();
    }
  }

  @override
  Future<void> createUserDocument(UserModel user) async {
    final now = FieldValue.serverTimestamp();
    await _usersRef.doc(user.id).set({
      'fullName': user.fullName,
      'email': user.email,
      'phone': user.phone,
      'photoUrl': user.photoUrl,
      'role': user.role.asString,
      'selectedFandoms': user.selectedFandoms,
      FirebaseConstants.fieldCreatedAt: now,
      FirebaseConstants.fieldUpdatedAt: now,
    });
  }

  @override
  Future<UserModel?> fetchUserDocument(String uid) async {
    final snapshot = await _usersRef.doc(uid).get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    return UserModel.fromMap(snapshot.data()!, snapshot.id);
  }
}
