import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
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

  void _startQuizStopwatch() {
    if (!_quizStopwatch.isRunning && !_quizFinished) {
      _quizStopwatch.start();
    }
  }

  void _stopQuizStopwatch() {
    if (_quizStopwatch.isRunning) {
      _quizStopwatch.stop();
    }
  }

  // ============================================================
  // GET TOTAL QUIZ TIME
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
    if (selectedAnswer != null) {
      return;
    }

    if (_quizFinished) {
      return;
    }

    if (_isMovingNext) {
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
    // ----------------------------------------------------------
    // PREVENT DOUBLE EXECUTION
    // ----------------------------------------------------------

    if (_isMovingNext || _quizFinished) {
      return;
    }

    _isMovingNext = true;

    // ----------------------------------------------------------
    // CHECK ANSWER
    // ----------------------------------------------------------

    if (selectedAnswer ==
        questions[currentQuestion].correctAnswer) {
      score++;
    }

    // ----------------------------------------------------------
    // LAST QUESTION
    // ----------------------------------------------------------

    if (currentQuestion == questions.length - 1) {
      _quizFinished = true;

      // Stop total quiz timer.
      _stopQuizStopwatch();

      // Get actual quiz time.
      final String timeTaken = _getTimeTaken();

      // --------------------------------------------------------
      // SAVE QUIZ ATTEMPT
      // --------------------------------------------------------

      final firebaseUser = FirebaseAuth.instance.currentUser;
      final appUser = context.read<AuthBloc>().state.user;

      if (firebaseUser != null) {
        final int points = score * 10;

        // Use appUser.fullName if available, otherwise fallback to displayName or placeholder
        final String displayName = appUser?.fullName ?? firebaseUser.displayName ?? 'Fandom Fan';

        final QuizAttempt attempt = QuizAttempt(
          id: '',
          userId: firebaseUser.uid,
          username: displayName,
          avatar: appUser?.photoUrl ?? firebaseUser.photoURL ?? '',
          fandomId: widget.fandomId,
          score: score,
          totalQuestions: questions.length,
          points: points,
          playedAt: DateTime.now(),
        );

        try {
          await _attemptService.saveAttempt(attempt);

          debugPrint(
            'Quiz attempt saved successfully.',
          );
        } catch (e) {
          debugPrint(
            'Failed to save quiz attempt: $e',
          );
        }
      } else {
        debugPrint(
          'No logged-in user. Quiz attempt was not saved.',
        );
      }

      // --------------------------------------------------------
      // CHECK SCREEN
      // --------------------------------------------------------

      if (!mounted) {
        return;
      }

      // --------------------------------------------------------
      // GO TO RESULTS
      // --------------------------------------------------------

      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return AResultsScreen(
              score: score,
              total: questions.length,
              timeTaken: timeTaken,
            );
          },
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // MOVE TO NEXT QUESTION
    // ----------------------------------------------------------

    if (!mounted) {
      return;
    }

    setState(() {
      currentQuestion++;
      selectedAnswer = null;
    });

    // Allow the next action.
    _isMovingNext = false;
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _stopQuizStopwatch();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

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
              return Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF7027FF),
                ),
              );
            }

            // ==================================================
            // ERROR
            // ==================================================

            if (snapshot.hasError) {
              debugPrint(
                'Quiz error: ${snapshot.error}',
              );

              return Center(
                child: Text(
                  'Unable to load quiz questions',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              );
            }

            // ==================================================
            // QUESTIONS
            // ==================================================

            final List<FandomQuizQuestion> questions =
                snapshot.data ?? [];

            // ==================================================
            // NOT ENOUGH QUESTIONS
            // ==================================================

            if (questions.length < 5) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    'This fandom does not have enough questions yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              );
            }

            // ==================================================
            // SAFETY CHECK
            // ==================================================

            if (currentQuestion >= questions.length) {
              return Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF7027FF),
                ),
              );
            }

            // ==================================================
            // START TOTAL QUIZ STOPWATCH
            // ==================================================

            if (currentQuestion == 0 &&
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
                  SizedBox(height: 15),

                  // =================================================
                  // TOP BAR
                  // =================================================

                  Row(
                    children: [
                      IconButton(
                        onPressed: _isMovingNext
                            ? null
                            : () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        '${currentQuestion + 1}/${questions.length}',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

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
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 18),

                  // =================================================
                  // QUESTION
                  // =================================================

                  Align(
                    alignment: Alignment.centerLeft,

                    child: Text(
                      question.question,

                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),

                  SizedBox(height: 18),

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
                              Theme.of(context).cardColor,

                              child: Icon(
                                Icons.image_outlined,
                                color: Theme.of(context).disabledColor,
                                size: 45,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  SizedBox(height: 18),

                  // =================================================
                  // ANSWERS
                  // =================================================

                  Expanded(
                    child: ListView.separated(
                      itemCount:
                      question.options.length,

                      separatorBuilder:
                          (context, index) {
                        return SizedBox(
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
                        Theme.of(context).dialogBackgroundColor;

                        if (selectedAnswer != null &&
                            isSelected) {
                          background = isCorrect
                              ? const Color(0xFF16A085)
                              : const Color(0xFFE74C3C);
                        }

                        return GestureDetector(
                          onTap: _isMovingNext
                              ? null
                              : () {
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
                                  BoxDecoration(
                                    color:
                                    Color(0xFF7027FF),
                                    shape:
                                    BoxShape.circle,
                                  ),

                                  child: Text(
                                    letter,

                                    style:
                                    TextStyle(
                                      color: Theme.of(context).textTheme.bodyLarge?.color,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),

                                SizedBox(width: 14),

                                // ANSWER TEXT

                                Expanded(
                                  child: Text(
                                    answer,

                                    style:
                                    TextStyle(
                                      color: Theme.of(context).textTheme.bodyLarge?.color,
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
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
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
                      Icon(
                        Icons.timer_outlined,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),

                      SizedBox(width: 5),

                      // 15 SECOND QUESTION TIMER

                      QuizTimer(
                        key: ValueKey(currentQuestion),

                        onTimeUp: () {
                          if (!mounted ||
                              _quizFinished ||
                              _isMovingNext) {
                            return;
                          }

                          _nextQuestion(questions);
                        },
                      ),

                      const Spacer(),

                      // NEXT BUTTON

                      SizedBox(
                        width: 125,
                        height: 50,

                        child: ElevatedButton(
                          onPressed:
                          selectedAnswer == null ||
                              _isMovingNext
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

                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,

                            children: [
                              Text(
                                'Next',

                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              SizedBox(width: 7),

                              Icon(
                                Icons.arrow_forward,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),
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

          if (mounted) {
            setState(() {
              secondsLeft = 0;
            });
          }

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

      style: TextStyle(
        color: Theme.of(context).textTheme.bodyLarge?.color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
