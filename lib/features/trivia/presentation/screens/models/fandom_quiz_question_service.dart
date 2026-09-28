import 'package:cloud_firestore/cloud_firestore.dart';

import 'fandom_quiz_question.dart';

class FandomQuizQuestionService {
  // Firebase Firestore instance
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // fandomQuizQuestions collection
  CollectionReference<Map<String, dynamic>> get _questions =>
      _firestore.collection('fandomQuizQuestions');

  // Add a question to Firebase
  Future<void> addQuestion(
      FandomQuizQuestion question,
      ) async {
    await _questions
        .doc(question.id)
        .set(question.toFirestore());
  }

  // Get questions for one fandom
  Stream<List<FandomQuizQuestion>> getQuestions(
      String fandomId,
      ) {
    return _questions
        .where(
      'fandomId',
      isEqualTo: fandomId,
    )
        .snapshots()
        .map((snapshot) {
      final questions = snapshot.docs.map((doc) {
        return FandomQuizQuestion.fromFirestore(
          doc.id,
          doc.data(),
        );
      }).toList();

      // Sort locally instead of using Firestore orderBy.
      questions.sort(
            (a, b) => a.questionNumber.compareTo(b.questionNumber),
      );

      return questions;
    });
  }
}