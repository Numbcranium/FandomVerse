import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'models/quiz_attempt.dart';
import 'models/quiz_attempt_service.dart';

class TriviaLeaderboardScreen extends StatefulWidget {
  const TriviaLeaderboardScreen({
    super.key,
  });

  @override
  State<TriviaLeaderboardScreen> createState() =>
      _TriviaLeaderboardScreenState();
}

class _TriviaLeaderboardScreenState
    extends State<TriviaLeaderboardScreen> {

  final QuizAttemptService _service =
  QuizAttemptService();

  int selectedTab = 0;

  final List<String> tabs = [
    'Weekly',
    'Monthly',
    'All Time',
  ];

  // ----------------------------------------------------------
  // FILTER ATTEMPTS
  // ----------------------------------------------------------

  List<QuizAttempt> _filterAttempts(
      List<QuizAttempt> attempts,
      ) {
    final now = DateTime.now();

    if (selectedTab == 0) {
      // Weekly
      final startDate =
      now.subtract(const Duration(days: 7));

      return attempts.where((attempt) {
        return attempt.playedAt.isAfter(startDate);
      }).toList();
    }

    if (selectedTab == 1) {
      // Monthly
      final startDate =
      now.subtract(const Duration(days: 30));

      return attempts.where((attempt) {
        return attempt.playedAt.isAfter(startDate);
      }).toList();
    }

    // All Time
    return attempts;
  }

  // ----------------------------------------------------------
  // BUILD LEADERBOARD
  // ----------------------------------------------------------
  List<_LeaderboardUser> _buildLeaderboard(
      List<QuizAttempt> attempts,
      ) {
    final Map<String, _LeaderboardUser> users = {};

    for (final attempt in attempts) {
      // ----------------------------------------------------------
      // NEW USER
      // ----------------------------------------------------------

      if (!users.containsKey(attempt.userId)) {
        users[attempt.userId] = _LeaderboardUser(
          userId: attempt.userId,
          username: attempt.username.trim().isNotEmpty
              ? attempt.username
              : 'Fandom Fan',
          avatar: attempt.avatar,
          points: attempt.points,
        );

        continue;
      }

      // ----------------------------------------------------------
      // EXISTING USER
      // ----------------------------------------------------------

      final user = users[attempt.userId]!;

      // Add points from another quiz
      user.points += attempt.points;

      // Update username if we have a real name
      if (attempt.username.trim().isNotEmpty &&
          attempt.username != 'Fandom Fan') {
        user.username = attempt.username;
      }

      // Update avatar if we have one
      if (user.avatar.trim().isEmpty &&
          attempt.avatar.trim().isNotEmpty) {
        user.avatar = attempt.avatar;
      }
    }

    final leaderboard = users.values.toList();

    // Highest points first
    leaderboard.sort(
          (a, b) => b.points.compareTo(a.points),
    );

    // Assign positions
    for (int i = 0; i < leaderboard.length; i++) {
      leaderboard[i].rank = i + 1;
    }

    return leaderboard;
  }


  // ----------------------------------------------------------
  // AVATAR
  // ----------------------------------------------------------

  Widget _buildAvatar(
      String avatar,
      ) {
    ImageProvider? image;

    if (avatar.isNotEmpty) {
      if (avatar.startsWith('http')) {
        image = NetworkImage(avatar);
      } else {
        image = AssetImage(avatar);
      }
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF7027FF),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: image != null
            ? Image(
          image: image,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) {
            return _defaultAvatar();
          },
        )
            : _defaultAvatar(),
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: const Color(0xFF18245C),
      child: const Icon(
        Icons.person,
        color: Colors.white70,
        size: 27,
      ),
    );
  }

  // ----------------------------------------------------------
  // MEDAL
  // ----------------------------------------------------------

  Widget _buildRank(int rank) {
    if (rank == 1) {
      return const Icon(
        Icons.emoji_events,
        color: Color(0xFFFFD43B),
        size: 25,
      );
    }

    if (rank == 2) {
      return const Icon(
        Icons.emoji_events,
        color: Color(0xFFC9D0DD),
        size: 25,
      );
    }

    if (rank == 3) {
      return const Icon(
        Icons.emoji_events,
        color: Color(0xFFE99B43),
        size: 25,
      );
    }

    return SizedBox(
      width: 30,
      child: Text(
        '$rank',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // LEADERBOARD ROW
  // ----------------------------------------------------------

  Widget _buildLeaderboardRow(
      _LeaderboardUser user,
      ) {
    final currentUser =
        FirebaseAuth.instance.currentUser;

    final bool isCurrentUser =
        currentUser?.uid == user.userId;

    return Container(
      height: 78,
      margin: const EdgeInsets.only(
        bottom: 2,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? const Color(0xFF17104D)
            : const Color(0xFF07143D),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: isCurrentUser
              ? const Color(0xFF8A35FF)
              : const Color(0xFF142D68),
          width: isCurrentUser ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // RANK
          SizedBox(
            width: 35,
            child: _buildRank(user.rank),
          ),

          const SizedBox(width: 7),

          // AVATAR
          _buildAvatar(user.avatar),

          const SizedBox(width: 14),

          // USERNAME
          Expanded(
            child: Text(
              isCurrentUser
                  ? 'You'
                  : user.username,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // POINTS
          Text(
            '${user.points} pts',
            style: const TextStyle(
              color: Color(0xFFFFC83D),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 5),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // TAB BUTTON
  // ----------------------------------------------------------

  Widget _buildTab(
      int index,
      ) {
    final bool isSelected =
        selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: AnimatedContainer(
          duration:
          const Duration(milliseconds: 200),
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF7027FF)
                : Colors.transparent,
            borderRadius:
            BorderRadius.circular(20),
          ),
          child: Text(
            tabs[index],
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: isSelected
                  ? FontWeight.bold
                  : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFF030927),

      body: SafeArea(
        child: Container(
          decoration:
          const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF030927),
                Color(0xFF02061E),
                Color(0xFF07103A),
              ],
            ),
          ),

          child: Column(
            children: [

              // ==================================================
              // TOP BAR
              // ==================================================

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),

                child: Row(
                  children: [

                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),

                    const Expanded(
                      child: Center(
                        child: Text(
                          'Leaderboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Keeps title centered
                    const SizedBox(
                      width: 48,
                    ),
                  ],
                ),
              ),

              // ==================================================
              // TABS
              // ==================================================

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 22,
                ),

                child: Container(
                  height: 47,

                  padding:
                  const EdgeInsets.all(2),

                  decoration:
                  BoxDecoration(
                    color:
                    const Color(0xFF06113A),
                    borderRadius:
                    BorderRadius.circular(22),
                    border: Border.all(
                      color:
                      const Color(0xFF1D4389),
                    ),
                  ),

                  child: Row(
                    children: [
                      _buildTab(0),
                      _buildTab(1),
                      _buildTab(2),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // ==================================================
              // FIREBASE LEADERBOARD
              // ==================================================

              Expanded(
                child: StreamBuilder<
                    List<QuizAttempt>>(
                  stream:
                  _service.getAttempts(),

                  builder:
                      (context, snapshot) {

                    if (snapshot
                        .connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child:
                        CircularProgressIndicator(
                          color:
                          Color(0xFF7027FF),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Unable to load leaderboard',
                          style: TextStyle(
                            color:
                            Colors.white70,
                          ),
                        ),
                      );
                    }

                    final attempts =
                        snapshot.data ?? [];

                    final filtered =
                    _filterAttempts(
                      attempts,
                    );

                    final leaderboard =
                    _buildLeaderboard(
                      filtered,
                    );

                    if (leaderboard.isEmpty) {
                      return const Center(
                        child: Text(
                          'No quiz plays yet.',
                          style: TextStyle(
                            color:
                            Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      );
                    }

                    final topUsers =
                    leaderboard
                        .take(5)
                        .toList();

                    final currentUser =
                        FirebaseAuth
                            .instance
                            .currentUser;

                    _LeaderboardUser?
                    currentUserEntry;

                    for (final user
                    in leaderboard) {
                      if (user.userId ==
                          currentUser?.uid) {
                        currentUserEntry =
                            user;
                        break;
                      }
                    }

                    final bool userAlreadyTopFive =
                        currentUserEntry != null &&
                            currentUserEntry!.rank <= 5;

                    return ListView(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 22,
                      ),

                      children: [

                        // =================================================
                        // TOP 5
                        // =================================================

                        ...topUsers.map(
                              (user) =>
                              _buildLeaderboardRow(
                                user,
                              ),
                        ),

                        // =================================================
                        // SPACE BEFORE "YOU"
                        // =================================================

                        if (currentUserEntry !=
                            null &&
                            !userAlreadyTopFive)
                          const SizedBox(
                            height: 72,
                          ),

                        // =================================================
                        // CURRENT USER
                        // =================================================

                        if (currentUserEntry !=
                            null &&
                            !userAlreadyTopFive)
                          _buildLeaderboardRow(
                            currentUserEntry!,
                          ),

                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// LEADERBOARD USER
// ================================================================

class _LeaderboardUser {
  final String userId;
  String username;
  String avatar;

  int points;
  int rank;

  _LeaderboardUser({
    required this.userId,
    required this.username,
    required this.avatar,
    required this.points,
    this.rank = 0,
  });
}