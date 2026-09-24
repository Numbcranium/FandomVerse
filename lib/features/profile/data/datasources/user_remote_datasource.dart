import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firebase_constants.dart';
import '../../../../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel?> fetchUser(String uid);
  Stream<UserModel?> watchUser(String uid);
  Future<void> updateUser(UserModel user);
}

class FirestoreUserRemoteDataSource implements UserRemoteDataSource {
  FirestoreUserRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection(FirebaseConstants.usersCollection);

  @override
  Future<UserModel?> fetchUser(String uid) async {
    final snapshot = await _usersRef.doc(uid).get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    return UserModel.fromMap(snapshot.data()!, snapshot.id);
  }

  @override
  Stream<UserModel?> watchUser(String uid) {
    return _usersRef.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;
      return UserModel.fromMap(snapshot.data()!, snapshot.id);
    });
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final map = user.toMap()
      ..[FirebaseConstants.fieldUpdatedAt] = FieldValue.serverTimestamp();
    await _usersRef.doc(user.id).set(map, SetOptions(merge: true));
  }
}
