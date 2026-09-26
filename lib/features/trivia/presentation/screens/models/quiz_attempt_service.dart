import 'package:cloud_firestore/cloud_firestore.dart';

import 'quiz_attempt.dart';

class QuizAttemptService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
  get _attempts =>
      _firestore.collection('quizAttempts');

  // ----------------------------------------------------------
  // SAVE ONE QUIZ PLAY
  // ----------------------------------------------------------

  Future<void> saveAttempt(
      QuizAttempt attempt,
      ) async {
    await _attempts.add(
      attempt.toFirestore(),
    );
  }

  // ----------------------------------------------------------
  // GET ALL ATTEMPTS
  // ----------------------------------------------------------

  Stream<List<QuizAttempt>> getAttempts() {
    return _attempts
        .orderBy('playedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return QuizAttempt.fromFirestore(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }
}