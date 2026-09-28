
class FandomTrivia {
  final String id;
  final String fandomId;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String category;
  final int questionNumber;

  const FandomTrivia({
    required this.id,
    required this.fandomId,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.category,
    required this.questionNumber,
  });

  factory FandomTrivia.fromFirestore(
      String documentId,
      Map<String, dynamic> data,
      ) {
    final rawOptions = data['options'];

    return FandomTrivia(
      id: documentId,
      fandomId: data['fandomId']?.toString() ?? '',
      question: data['question']?.toString() ?? '',
      options: rawOptions is List
          ? rawOptions.map((option) => option.toString()).toList()
          : <String>[],
      correctAnswer: data['correctAnswer']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
      questionNumber: data['questionNumber'] is int
          ? data['questionNumber'] as int
          : int.tryParse(
        data['questionNumber']?.toString() ?? '',
      ) ??
          0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fandomId': fandomId,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'category': category,
      'questionNumber': questionNumber,
    };
  }
}