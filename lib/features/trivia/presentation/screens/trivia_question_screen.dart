import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'a_results_screen.dart';
import 'models/fandom_quiz_question.dart';
import 'models/fandom_quiz_question_service.dart';
import 'models/quiz_attempt.dart';
import 'models/quiz_attempt_service.dart';

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
  // ============================================================
  // SERVICES
  // ============================================================

  final FandomQuizQuestionService _service =
  FandomQuizQuestionService();

  final QuizAttemptService _attemptService =
  QuizAttemptService();

  // ============================================================
  // QUIZ VARIABLES
  // ============================================================

  int currentQuestion = 0;

  int score = 0;

  String? selectedAnswer;

  bool _isMovingNext = false;

  bool _quizFinished = false;

  // ============================================================
  // TOTAL QUIZ STOPWATCH
  // ============================================================

  final Stopwatch _quizStopwatch = Stopwatch();

  // Start the TOTAL quiz timer.
  // This timer is different from the 15-second question timer.
  void _startQuizStopwatch() {
    if (!_quizStopwatch.isRunning && !_quizFinished) {
      _quizStopwatch.start();
    }
  }

  // Stop the TOTAL quiz timer.
  void _stopQuizStopwatch() {
    if (_quizStopwatch.isRunning) {
      _quizStopwatch.stop();
    }
  }

  // ============================================================
  // GET TOTAL TIME
  // ============================================================

  String _getTimeTaken() {
    final Duration duration = _quizStopwatch.elapsed;

    final int minutes = duration.inMinutes;

    final int seconds = duration.inSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // SELECT ANSWER
  // ============================================================

  void _selectAnswer(String answer) {
    // Only one answer can be selected.
    if (selectedAnswer != null) {
      return;
    }

    if (_quizFinished) {
      return;
    }

    setState(() {
      selectedAnswer = answer;
    });
  }

  // ============================================================
  // NEXT QUESTION
  // ============================================================

  Future<void> _nextQuestion(
      List<FandomQuizQuestion> questions,
      ) async {
    // ------------------------------------------------------------
    // PREVENT DOUBLE NAVIGATION
    // ------------------------------------------------------------

    if (_isMovingNext || _quizFinished) {
      return;
    }

    _isMovingNext = true;

    // ------------------------------------------------------------
    // CHECK ANSWER
    // ------------------------------------------------------------

    if (selectedAnswer ==
        questions[currentQuestion].correctAnswer) {
      score++;
    }

    // ------------------------------------------------------------
    // LAST QUESTION
    // ------------------------------------------------------------

    if (currentQuestion == questions.length - 1) {
      _quizFinished = true;

      // Stop total quiz timer.
      _stopQuizStopwatch();

      // Get actual quiz duration.
      final String timeTaken = _getTimeTaken();

      // ----------------------------------------------------------
      // SAVE ATTEMPT
      // ----------------------------------------------------------

      final User? user =
          FirebaseAuth.instance.currentUser;

      if (user != null) {
        final int points = score * 10;

        final QuizAttempt attempt = QuizAttempt(
          id: '',
          userId: user.uid,
          username: user.displayName ?? 'Fandom Fan',
          avatar: user.photoURL ?? '',
          fandomId: widget.fandomId,
          score: score,
          totalQuestions: questions.length,
          points: points,
          playedAt: DateTime.now(),
        );

        try {
          await _attemptService.saveAttempt(attempt);
        } catch (e) {
          debugPrint(
            'Failed to save quiz attempt: $e',
          );
        }
      }

      // ----------------------------------------------------------
      // MAKE SURE SCREEN STILL EXISTS
      // ----------------------------------------------------------

      if (!mounted) {
        return;
      }

      // ----------------------------------------------------------
      // GO TO RESULTS
      // ----------------------------------------------------------

      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => AResultsScreen(
            score: score,
            total: questions.length,
            timeTaken: timeTaken,
          ),
        ),
      );

      return;
    }

    // ------------------------------------------------------------
    // NEXT QUESTION
    // ------------------------------------------------------------

    if (!mounted) {
      return;
    }

    setState(() {
      currentQuestion++;
      selectedAnswer = null;
    });

    // Allow another Next/Timer event.
    _isMovingNext = false;
  }
  // ============================================================
  // BUILD
  // ============================================================

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
            // ==================================================
            // LOADING
            // ==================================================

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF7027FF),
                ),
              );
            }

            // ==================================================
            // ERROR
            // ==================================================

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

            final List<FandomQuizQuestion> questions =
                snapshot.data ?? [];

            // ==================================================
            // NOT ENOUGH QUESTIONS
            // ==================================================

            if (questions.length < 5) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    'This fandom does not have enough questions yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
              );
            }

            // ==================================================
            // SAFETY CHECK
            // ==================================================

            if (currentQuestion >= questions.length) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF7027FF),
                ),
              );
            }

            // ==================================================
            // START TOTAL QUIZ STOPWATCH
            // ==================================================

            if (questions.isNotEmpty &&
                currentQuestion == 0 &&
                !_quizStopwatch.isRunning &&
                !_quizFinished) {
              WidgetsBinding.instance.addPostFrameCallback(
                    (_) {
                  if (mounted &&
                      !_quizStopwatch.isRunning &&
                      !_quizFinished) {
                    _startQuizStopwatch();
                  }
                },
              );
            }

            final FandomQuizQuestion question =
            questions[currentQuestion];

            // ==================================================
            // MAIN UI
            // ==================================================

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
                      padding: const EdgeInsets.symmetric(
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
                          (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },

                      itemBuilder:
                          (context, index) {
                        final String answer =
                        question.options[index];

                        // A, B, C, D, E...
                        final String letter =
                        String.fromCharCode(
                          'A'.codeUnitAt(0) + index,
                        );

                        final bool isSelected =
                            selectedAnswer == answer;

                        final bool isCorrect =
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

                            decoration: BoxDecoration(
                              color: background,

                              borderRadius:
                              BorderRadius.circular(16),

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
                                // ANSWER LETTER

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

                                const SizedBox(width: 14),

                                // ANSWER TEXT

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

                                // CHECK / CLOSE

                                if (selectedAnswer != null &&
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
                  // QUESTION TIMER + NEXT
                  // =================================================

                  Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        color: Colors.white,
                      ),

                      const SizedBox(width: 5),

                      // 15 SECOND QUESTION TIMER
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

                      // NEXT BUTTON

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
// 15 SECOND QUESTION TIMER
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