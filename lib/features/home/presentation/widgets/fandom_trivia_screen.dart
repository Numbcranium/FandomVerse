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
      backgroundColor: Theme.of(context).cardColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),

        title: Text(
          'Trivia',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder<List<FandomTrivia>>(
        stream: _triviaService.getTrivia(widget.fandomId),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Unable to load trivia',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            );
          }

          final trivia = snapshot.data ?? [];

          if (trivia.length < 5) {
            return Center(
              child: Text(
                'Trivia is not available yet.',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
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
                  style: TextStyle(
                    color: Color(0xFF8FA8F5),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20),

                Text(
                  question.question,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 30),

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
                                : Theme.of(context).cardColor,
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
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge?.color,
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