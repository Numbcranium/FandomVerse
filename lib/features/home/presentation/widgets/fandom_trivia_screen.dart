import 'package:flutter/material.dart';
import 'package:techwiz7_starter/features/home/presentation/widgets/trivia_result_card.dart';

import '../../../../models/fandom_trivia_service.dart';
import '../../../../models/trending_fandom_trivia.dart';

class FandomTriviaScreen extends StatefulWidget {
  final String fandomId;

  const FandomTriviaScreen({
    super.key,
    required this.fandomId,
  });

  @override
  State<FandomTriviaScreen> createState() =>
      _FandomTriviaScreenState();
}

class _FandomTriviaScreenState
    extends State<FandomTriviaScreen> {
  final FandomTriviaService _triviaService =
  FandomTriviaService();

  int currentQuestion = 0;
  int score = 0;

  String? selectedAnswer;

  bool get isLastQuestion =>
      currentQuestion == 4;

  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  void nextQuestion(List<FandomTrivia> trivia) {
    if (selectedAnswer == null) return;

    final currentTrivia = trivia[currentQuestion];

    if (selectedAnswer == currentTrivia.correctAnswer) {
      score++;
    }

    if (isLastQuestion) {
      _showResults();
      return;
    }

    setState(() {
      currentQuestion++;
      selectedAnswer = null;
    });
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return TriviaResultCard(
          score: score,
          total: 5,
          onDone: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0A24),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0A24),
        elevation: 0,

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),

        title: const Text(
          'Trivia',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder<List<FandomTrivia>>(
        stream: _triviaService.getTrivia(widget.fandomId),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Unable to load trivia',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            );
          }

          final trivia = snapshot.data ?? [];

          if (trivia.length < 5) {
            return const Center(
              child: Text(
                'Trivia is not available yet.',
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            );
          }

          final question = trivia[currentQuestion];

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${currentQuestion + 1} of 5',
                  style: const TextStyle(
                    color: Color(0xFF8FA8F5),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  question.question,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                ...question.options.map(
                      (option) {
                    final isSelected =
                        selectedAnswer == option;

                    return Padding(
                      padding:
                      const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () {
                          selectAnswer(option);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF5865D8)
                                : const Color(0xFF17163D),
                            borderRadius:
                            BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF8FA8F5)
                                  : Colors.white12,
                            ),
                          ),
                          child: Text(
                            option,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: selectedAnswer == null
                        ? null
                        : () {
                      nextQuestion(trivia);
                    },
                    child: Text(
                      isLastQuestion
                          ? 'Finish Trivia'
                          : 'Next Question',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}