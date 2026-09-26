import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:techwiz7_starter/models/trending_fandom_trivia.dart';


class FandomTriviaService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> addTrivia(FandomTrivia trivia) async {
    await _firestore
        .collection('fandoms')
        .doc(trivia.fandomId)
        .collection('trivia')
        .doc(trivia.id)
        .set(trivia.toFirestore());
  }

  Stream<List<FandomTrivia>> getTrivia(
      String fandomId,
      ) {
    return _firestore
        .collection('fandoms')
        .doc(fandomId)
        .collection('trivia')
        .orderBy('questionNumber')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FandomTrivia.fromFirestore(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }

  Future<void> deleteTrivia(
      String fandomId,
      String triviaId,
      ) async {
    await _firestore
        .collection('fandoms')
        .doc(fandomId)
        .collection('trivia')
        .doc(triviaId)
        .delete();
  }
}