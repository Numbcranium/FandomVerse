import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../trivia_leaderboard_screen.dart';

class TriviaResultCard extends StatelessWidget {
  final int score;
  final int total;
  final String timeTaken;
  final VoidCallback? onDone;

  const TriviaResultCard({
    super.key,
    required this.score,
    required this.total,
    required this.timeTaken,

    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate percentage
    final double percentage =
    total == 0 ? 0 : score / total;

    final int percentageValue =
    (percentage * 100).round();

    final int incorrect =
        total - score;

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,

      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).cardColor,
                Theme.of(context).cardColor,
                Theme.of(context).cardColor,
              ],
            ),
          ),

          child: Column(
            children: [
              // TOP BAR

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),

                child: Row(
                  children: [
                    // BACK BUTTON
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        size: 23,
                      ),
                    ),

                    const Spacer(),

                    // LEADERBOARD BUTTON
                    Container(
                      width: 45,
                      height: 45,

                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: const Color(
                            0xFF263D75,
                          ),
                        ),
                      ),

                      child: IconButton(
                        onPressed: () {
                          context.push(RouteNames.triviaLeaderboard);
                        },
                        icon: Icon(
                          Icons.leaderboard_outlined,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          size: 23,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // =====================================================
              // SCROLLABLE CONTENT
              // =====================================================

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  child: Column(
                    children: [
                      SizedBox(height: 5),

                      // =================================================
                      // TROPHY
                      // =================================================

                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Purple glow
                          Container(
                            width: 75,
                            height: 75,

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,

                              color: const Color(
                                0xFF7027FF,
                              ).withOpacity(0.25),
                            ),
                          ),

                          Container(
                            width: 58,
                            height: 58,

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor,
                            ),

                            child: Icon(
                              Icons.emoji_events,
                              color: Color(0xFFFFB72B),
                              size: 39,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12),

                      // =================================================
                      // TITLE
                      // =================================================

                      Text(
                        'Quiz Completed!',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 20),

                      // =================================================
                      // SCORE CARD
                      // =================================================

                      Container(
                        width: double.infinity,

                        padding: const EdgeInsets.all(18),

                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,

                          borderRadius:
                          BorderRadius.circular(20),

                          border: Border.all(
                            color: const Color(
                              0xFF263D75,
                            ),
                          ),
                        ),

                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [
                            // -------------------------------------------
                            // SCORE + PERCENTAGE
                            // -------------------------------------------

                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      'Your Score',
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyMedium?.color,
                                        fontSize: 16,
                                      ),
                                    ),

                                    SizedBox(height: 4),

                                    Text(
                                      '$score / $total',
                                      style:
                                      TextStyle(
                                        color: Theme.of(context).textTheme.bodyLarge?.color,
                                        fontSize: 35,
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const Spacer(),

                                // PERCENTAGE CIRCLE
                                Container(
                                  width: 68,
                                  height: 68,

                                  decoration:
                                  BoxDecoration(
                                    shape:
                                    BoxShape.circle,

                                    color: const Color(
                                      0xFF00A86B,
                                    ).withOpacity(0.9),

                                    border: Border.all(
                                      color:
                                      const Color(
                                        0xFF00D084,
                                      ),
                                      width: 2,
                                    ),
                                  ),

                                  alignment:
                                  Alignment.center,

                                  child: Text(
                                    '$percentageValue%',
                                    style:
                                    TextStyle(
                                      color: Theme.of(context).textTheme.bodyLarge?.color,
                                      fontSize: 19,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 18),

                            // -------------------------------------------
                            // STATISTICS
                            // -------------------------------------------

                            Row(
                              children: [
                                // CORRECT
                                Expanded(
                                  child: _StatBox(
                                    icon:
                                    Icons.check_circle_outline,
                                    title: 'Correct',
                                    value:
                                    '$score',
                                    iconColor:
                                    const Color(
                                      0xFF00D084,
                                    ),
                                    valueColor:
                                    const Color(
                                      0xFF00D084,
                                    ),
                                  ),
                                ),

                                SizedBox(width: 10),

                                // INCORRECT
                                Expanded(
                                  child: _StatBox(
                                    icon:
                                    Icons.close,
                                    title: 'Incorrect',
                                    value:
                                    '$incorrect',
                                    iconColor:
                                    const Color(
                                      0xFFFF3D71,
                                    ),
                                    valueColor:
                                    const Color(
                                      0xFFFF3D71,
                                    ),
                                  ),
                                ),

                                SizedBox(width: 10),

                                // TIME
                                Expanded(
                                  child: _StatBox(
                                    icon:
                                    Icons.timer_outlined,
                                    title: 'Time Taken',
                                    value: timeTaken,
                                    iconColor:
                                    const Color(
                                      0xFFBD62FF,
                                    ),
                                    valueColor:
                                    Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),

                      // =================================================
                      // PERFORMANCE
                      // =================================================

                      Container(
                        width: double.infinity,

                        padding: const EdgeInsets.all(18),

                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,

                          borderRadius:
                          BorderRadius.circular(20),

                          border: Border.all(
                            color: const Color(
                              0xFF263D75,
                            ),
                          ),
                        ),

                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [
                            Text(
                              'Performance',
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                                fontSize: 15,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),

                            SizedBox(height: 14),

                            // PERFORMANCE BAR
                            ClipRRect(
                              borderRadius:
                              BorderRadius.circular(20),

                              child:
                              LinearProgressIndicator(
                                value: percentage,

                                minHeight: 15,

                                backgroundColor:
                                const Color(
                                  0xFF24376E,
                                ),

                                valueColor:
                                const AlwaysStoppedAnimation<
                                    Color>(
                                  Color(0xFF21D4D9),
                                ),
                              ),
                            ),

                            SizedBox(height: 18),

                            Center(
                              child: Text(
                                _getPerformanceMessage(
                                  percentage,
                                ),

                                textAlign:
                                TextAlign.center,

                                style:
                                TextStyle(
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 25),

                      // =================================================
                      // PLAY AGAIN
                      // =================================================

                      SizedBox(
                        width: double.infinity,
                        height: 52,

                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },

                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(
                              0xFF7027FF,
                            ),

                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                28,
                              ),
                            ),
                          ),

                          child: Text(
                            'Play Again',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: 16,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 12),

                      // =================================================
                      // BACK TO HOME
                      // =================================================

                      SizedBox(
                        width: double.infinity,
                        height: 52,

                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                            );
                            context.go(RouteNames.home);
                          },

                          style:
                          OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(
                                0xFF31509A,
                              ),
                            ),

                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                28,
                              ),
                            ),
                          ),

                          child: Text(
                            'Back to Home',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: 16,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // PERFORMANCE MESSAGE
  // ===============================================================

  String _getPerformanceMessage(
      double percentage,
      ) {
    if (percentage >= 0.8) {
      return "Great job! You're a true fan!";
    }

    if (percentage >= 0.6) {
      return 'Nice work! Keep going!';
    }

    if (percentage >= 0.4) {
      return 'Good try! You can do even better!';
    }

    return 'Keep practicing and try again!';
  }
}

// =================================================================
// STAT BOX
// =================================================================

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;
  final Color valueColor;

  const _StatBox({
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,

      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,

        borderRadius:
        BorderRadius.circular(12),

        border: Border.all(
          color: Theme.of(context).cardColor,
        ),
      ),

      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),

          SizedBox(height: 7),

          Text(
            title,
            textAlign: TextAlign.center,

            style: TextStyle(
              color: iconColor,
              fontSize: 11,
              fontWeight:
              FontWeight.w500,
            ),
          ),

          SizedBox(height: 4),

          Text(
            value,
            textAlign: TextAlign.center,

            style: TextStyle(
              color: valueColor,
              fontSize: 16,
              fontWeight:
              FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}