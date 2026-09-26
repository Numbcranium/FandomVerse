import 'package:cloud_firestore/cloud_firestore.dart';

class FollowService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _follows =>
      _firestore.collection('follows');

  // Create a unique follow document
  DocumentReference<Map<String, dynamic>> _followDoc(
      String userId,
      String fandomId,
      ) {
    return _follows.doc('${userId}_$fandomId');
  }

  // Follow a fandom
  Future<void> followFandom(
      String userId,
      String fandomId,
      ) async {
    await _followDoc(userId, fandomId).set({
      'userId': userId,
      'fandomId': fandomId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Unfollow a fandom
  Future<void> unfollowFandom(
      String userId,
      String fandomId,
      ) async {
    await _followDoc(userId, fandomId).delete();
  }

  // Check if user follows fandom
  Stream<bool> isFollowing(
      String userId,
      String fandomId,
      ) {
    return _followDoc(userId, fandomId)
        .snapshots()
        .map((doc) => doc.exists);
  }
}