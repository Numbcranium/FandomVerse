import 'dart:async';

import 'package:flutter/material.dart';

import '../../../home/presentation/widgets/trivia_result_card.dart';
import 'models/fandom_quiz_question.dart';
import 'models/fandom_quiz_question_service.dart';

class TriviaQuestionsScreen extends StatefulWidget {
  final String fandomId;

  const TriviaQuestionsScreen({
    super.key,
    required this.fandomId,
  });

  @override
  State<TriviaQuestionsScreen> createState() =>
      _TriviaQuestionsScreenState();
}

class _TriviaQuestionsScreenState
    extends State<TriviaQuestionsScreen> {
  // Firebase service
  final FandomQuizQuestionService _service =
  FandomQuizQuestionService();

  // Current question
  int currentQuestion = 0;

  // User score
  int score = 0;

  // Selected answer
  String? selectedAnswer;

  // Prevents _nextQuestion from being called twice
  bool _isMovingNext = false;

  // Prevents the result screen from opening twice
  bool _quizFinished = false;

  // ----------------------------------------------------------
  // SELECT ANSWER
  // ----------------------------------------------------------

  void _selectAnswer(String answer) {
    // User can only select one answer
    if (selectedAnswer != null) return;

    setState(() {
      selectedAnswer = answer;
    });
  }

  // ----------------------------------------------------------
  // NEXT QUESTION
  // ----------------------------------------------------------

  void _nextQuestion(
      List<FandomQuizQuestion> questions,
      ) {
    // Prevent double calls
    if (_isMovingNext || _quizFinished) {
      return;
    }

    _isMovingNext = true;

    // Check answer
    if (selectedAnswer ==
        questions[currentQuestion].correctAnswer) {
      score++;
    }

    // --------------------------------------------------------
    // LAST QUESTION
    // --------------------------------------------------------

    if (currentQuestion == questions.length - 1) {
      _quizFinished = true;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return TriviaResultCard(
            score: score,
            total: questions.length,
            onDone: () {},
          );
        },
      );

      return;
    }

    // --------------------------------------------------------
    // NEXT QUESTION
    // --------------------------------------------------------

    setState(() {
      currentQuestion++;
      selectedAnswer = null;
    });

    _isMovingNext = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05052B),

      body: SafeArea(
        child: StreamBuilder<List<FandomQuizQuestion>>(
          stream: _service.getQuestions(
            widget.fandomId,
          ),

          builder: (context, snapshot) {
            // ------------------------------------------------
            // LOADING
            // ------------------------------------------------

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF7027FF),
                ),
              );
            }

            // ------------------------------------------------
            // ERROR
            // ------------------------------------------------

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Unable to load quiz questions',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              );
            }

            final questions = snapshot.data ?? [];

            // ------------------------------------------------
            // NOT ENOUGH QUESTIONS
            // ------------------------------------------------

            if (questions.length < 5) {
              return const Center(
                child: Text(
                  'This fandom does not have enough questions yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              );
            }

            // ------------------------------------------------
            // SAFETY CHECK
            // ------------------------------------------------

            if (currentQuestion >= questions.length) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF7027FF),
                ),
              );
            }

            final question =
            questions[currentQuestion];

            // ------------------------------------------------
            // MAIN QUIZ UI
            // ------------------------------------------------

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15),

                  // =================================================
                  // TOP BAR
                  // =================================================

                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        '${currentQuestion + 1}/${questions.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // =================================================
                  // CATEGORY
                  // =================================================

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7027FF),
                        borderRadius:
                        BorderRadius.circular(25),
                      ),
                      child: Text(
                        question.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // =================================================
                  // QUESTION
                  // =================================================

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      question.question,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // =================================================
                  // QUESTION IMAGE
                  // =================================================

                  if (question.image.isNotEmpty)
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(14),
                      child: SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: Image.asset(
                          question.image,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) {
                            return Container(
                              color:
                              const Color(0xFF17163D),
                              child: const Icon(
                                Icons.image_outlined,
                                color: Colors.white38,
                                size: 45,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  const SizedBox(height: 18),

                  // =================================================
                  // ANSWERS
                  // =================================================

                  Expanded(
                    child: ListView.separated(
                      itemCount:
                      question.options.length,

                      separatorBuilder:
                          (context, index) =>
                      const SizedBox(height: 10),

                      itemBuilder:
                          (context, index) {
                        final answer =
                        question.options[index];


                        final String letter =
                        String.fromCharCode(
                          'A'.codeUnitAt(0) + index,
                        );

                        final isSelected =
                            selectedAnswer == answer;

                        final isCorrect =
                            answer ==
                                question.correctAnswer;

                        Color background =
                        const Color(0xFF111F55);

                        if (selectedAnswer != null &&
                            isSelected) {
                          background = isCorrect
                              ? const Color(0xFF16A085)
                              : const Color(0xFFE74C3C);
                        }

                        return GestureDetector(
                          onTap: () {
                            _selectAnswer(answer);
                          },

                          child: Container(
                            height: 55,
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),

                            decoration:
                            BoxDecoration(
                              color: background,
                              borderRadius:
                              BorderRadius.circular(
                                16,
                              ),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(
                                  0xFF7027FF,
                                )
                                    : const Color(
                                  0xFF263D75,
                                ),
                              ),
                            ),

                            child: Row(
                              children: [
                                // ------------------------------------------
                                // ANSWER LETTER
                                // ------------------------------------------

                                Container(
                                  width: 36,
                                  height: 36,
                                  alignment:
                                  Alignment.center,

                                  decoration:
                                  const BoxDecoration(
                                    color:
                                    Color(0xFF7027FF),
                                    shape:
                                    BoxShape.circle,
                                  ),

                                  child: Text(
                                    letter,
                                    style:
                                    const TextStyle(
                                      color: Colors.white,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  width: 14,
                                ),

                                // ------------------------------------------
                                // ANSWER TEXT
                                // ------------------------------------------

                                Expanded(
                                  child: Text(
                                    answer,
                                    style:
                                    const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),

                                // ------------------------------------------
                                // CHECK / CLOSE ICON
                                // ------------------------------------------

                                if (selectedAnswer !=
                                    null &&
                                    isSelected)
                                  Icon(
                                    isCorrect
                                        ? Icons.check
                                        : Icons.close,
                                    color: Colors.white,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // =================================================
                  // TIMER + NEXT
                  // =================================================

                  Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        color: Colors.white,
                      ),

                      const SizedBox(width: 5),

                      // ------------------------------------------------

                      // Only this widget rebuilds every second.
                      // The entire quiz screen does NOT rebuild.
                      // ------------------------------------------------

                      QuizTimer(
                        key: ValueKey(currentQuestion),
                        onTimeUp: () {
                          if (!mounted ||
                              _quizFinished) {
                            return;
                          }

                          _nextQuestion(
                            questions,
                          );
                        },
                      ),

                      const Spacer(),

                      // ------------------------------------------------
                      // NEXT BUTTON
                      // ------------------------------------------------

                      SizedBox(
                        width: 125,
                        height: 50,

                        child: ElevatedButton(
                          onPressed:
                          selectedAnswer == null
                              ? null
                              : () {
                            _nextQuestion(
                              questions,
                            );
                          },

                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(
                              0xFF7027FF,
                            ),

                            disabledBackgroundColor:
                            const Color(
                              0xFF302050,
                            ),

                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                25,
                              ),
                            ),
                          ),

                          child: const Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,

                            children: [
                              Text(
                                'Next',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              SizedBox(width: 7),

                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ================================================================
// QUIZ TIMER
// ================================================================
//
// This is a separate StatefulWidget.
//
// Only this widget rebuilds every second.
// Your question, image, answers and entire screen will NOT blink.
// ================================================================

class QuizTimer extends StatefulWidget {
  final VoidCallback onTimeUp;

  const QuizTimer({
    super.key,
    required this.onTimeUp,
  });

  @override
  State<QuizTimer> createState() =>
      _QuizTimerState();
}

class _QuizTimerState extends State<QuizTimer> {
  Timer? _timer;

  int secondsLeft = 15;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (secondsLeft > 1) {
          setState(() {
            secondsLeft--;
          });
        } else {
          timer.cancel();

          setState(() {
            secondsLeft = 0;
          });

          widget.onTimeUp();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '00:${secondsLeft.toString().padLeft(2, '0')}',
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}