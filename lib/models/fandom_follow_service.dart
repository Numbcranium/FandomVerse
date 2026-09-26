import 'package:cloud_firestore/cloud_firestore.dart';

class FandomFollowService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // FOLLOW A FANDOM

  Future<void> followFandom({
    required String fandomId,
    required String userId,
  }) async {
    await _firestore
        .collection('fandoms') // from the firebase collection
        .doc(fandomId)
        .collection('followers')
        .doc(userId)
        .set({
      'userId': userId,
      'followedAt': FieldValue.serverTimestamp(),
    });
  }

  // UNFOLLOW A FANDOM

  Future<void> unfollowFandom({
    required String fandomId,
    required String userId,
  }) async {
    await _firestore
        .collection('fandoms')
        .doc(fandomId)
        .collection('followers')
        .doc(userId)
        .delete();
  }

  // CHECK IF USER IS FOLLOWING


  Stream<bool> isFollowing({
    required String fandomId,
    required String userId,
  }) {
    return _firestore
        .collection('fandoms')
        .doc(fandomId)
        .collection('followers')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.exists;
    });
  }

  // GET NUMBER OF FOLLOWERS


  Stream<int> getFollowerCount(String fandomId,) {
    return _firestore
        .collection('fandoms')
        .doc(fandomId)
        .collection('followers')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.length;
    });
  }
}