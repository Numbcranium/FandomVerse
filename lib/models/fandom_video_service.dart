import 'package:cloud_firestore/cloud_firestore.dart';
import 'fandom_video.dart';

class FandomVideoService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> addVideo(FandomVideo video) async {
    await _firestore
        .collection('fandoms')
        .doc(video.fandomId)
        .collection('videos')
        .doc(video.id)
        .set(video.toFirestore());
  }

  Stream<List<FandomVideo>> getVideos(String fandomId) {
    return _firestore
        .collection('fandoms')
        .doc(fandomId)
        .collection('videos')
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FandomVideo.fromFirestore(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }
}