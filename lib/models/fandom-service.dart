import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/fandom_models.dart';

class FandomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _fandoms =>
      _firestore.collection('fandoms');

  // Add a fandom
  Future<void> addFandom(FandomModels fandom) async {
    await _fandoms.doc(fandom.id).set(
      fandom.toFirestore(),
    );
  }

  // Get all fandoms
  Stream<List<FandomModels>> getFandoms() {
    return _fandoms.snapshots().map(
          (snapshot) {
        return snapshot.docs.map(
              (doc) {
            return FandomModels.fromFirestore(
              doc.id,
              doc.data(),
            );
          },
        ).toList();
      },
    );
  }

  // Get one fandom
  Future<FandomModels?> getFandom(String fandomId) async {
    final doc = await _fandoms.doc(fandomId).get();

    if (!doc.exists) {
      return null;
    }

    return FandomModels.fromFirestore(
      doc.id,
      doc.data()!,
    );
  }

  // Get fandoms by category
  Stream<List<FandomModels>> getFandomsByCategory(
      String category,
      ) {
    return _fandoms
        .where('category', isEqualTo: category)
        .snapshots()
        .map(
          (snapshot) {
        return snapshot.docs.map(
              (doc) {
            return FandomModels.fromFirestore(
              doc.id,
              doc.data(),
            );
          },
        ).toList();
      },
    );
  }
}