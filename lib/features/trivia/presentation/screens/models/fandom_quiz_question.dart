
class FandomQuizQuestion {
  final String id;
  final String fandomId;
  final String question;
  final String image;
  final List<String> options;
  final String correctAnswer;
  final int questionNumber;
  final String category;

  const FandomQuizQuestion({
    required this.id,
    required this.fandomId,
    required this.question,
    required this.image,
    required this.options,
    required this.correctAnswer,
    required this.questionNumber,
    required this.category,
  });

  factory FandomQuizQuestion.fromFirestore(
      String documentId,
      Map<String, dynamic> data,
      ) {
    final rawOptions = data['options'];

    return FandomQuizQuestion(
      id: documentId,
      fandomId: data['fandomId']?.toString() ?? '',
      question: data['question']?.toString() ?? '',
      image: data['image']?.toString() ?? '',
      options: rawOptions is List
          ? rawOptions
          .map((option) => option.toString())
          .toList()
          : <String>[],
      correctAnswer:
      data['correctAnswer']?.toString() ?? '',
      questionNumber: data['questionNumber'] is int
          ? data['questionNumber'] as int
          : int.tryParse(
        data['questionNumber']?.toString() ?? '',
      ) ??
          0,
      category: data['category']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fandomId': fandomId,
      'question': question,
      'image': image,
      'options': options,
      'correctAnswer': correctAnswer,
      'questionNumber': questionNumber,
      'category': category,
    };
  }
}