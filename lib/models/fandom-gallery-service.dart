import 'package:cloud_firestore/cloud_firestore.dart';
import 'fandom_gallery.dart';

class FandomGalleryService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> addGallery(FandomGallery gallery) async {
    await _firestore
        .collection('fandoms')
        .doc(gallery.fandomId)
        .collection('gallery')
        .doc(gallery.id)
        .set(gallery.toFirestore());
  }

  Stream<List<FandomGallery>> getGallery(
      String fandomId,
      ) {
    return _firestore
        .collection('fandoms')
        .doc(fandomId)
        .collection('gallery')
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FandomGallery.fromFirestore(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }
}