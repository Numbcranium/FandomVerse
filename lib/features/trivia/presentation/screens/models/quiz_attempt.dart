import 'package:cloud_firestore/cloud_firestore.dart';

class QuizAttempt {
  final String id;
  final String userId;
  final String username;
  final String avatar;
  final String fandomId;
  final int score;
  final int totalQuestions;
  final int points;
  final DateTime playedAt;

  const QuizAttempt({
    required this.id,
    required this.userId,
    required this.username,
    required this.avatar,
    required this.fandomId,
    required this.score,
    required this.totalQuestions,
    required this.points,
    required this.playedAt,
  });

  factory QuizAttempt.fromFirestore(
      String documentId,
      Map<String, dynamic> data,
      ) {
    final timestamp = data['playedAt'];

    return QuizAttempt(
      id: documentId,
      userId: data['userId']?.toString() ?? '',
      username: data['username']?.toString() ?? 'Fandom Fan',
      avatar: data['avatar']?.toString() ?? '',
      fandomId: data['fandomId']?.toString() ?? '',
      score: data['score'] is int
          ? data['score'] as int
          : int.tryParse(data['score']?.toString() ?? '') ?? 0,
      totalQuestions: data['totalQuestions'] is int
          ? data['totalQuestions'] as int
          : int.tryParse(
        data['totalQuestions']?.toString() ?? '',
      ) ??
          0,
      points: data['points'] is int
          ? data['points'] as int
          : int.tryParse(data['points']?.toString() ?? '') ?? 0,
      playedAt: timestamp is Timestamp
          ? timestamp.toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'username': username,
      'avatar': avatar,
      'fandomId': fandomId,
      'score': score,
      'totalQuestions': totalQuestions,
      'points': points,
      'playedAt': Timestamp.fromDate(playedAt),
    };
  }
}