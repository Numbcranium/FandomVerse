import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/constants/firebase_constants.dart';

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

  final QuizAttemptService _service = QuizAttemptService();

  int selectedTab = 0;

  final List<String> tabs = [
    'Weekly',
    'Monthly',
    'All Time',
  ];

  // ----------------------------------------------------------
  // FILTER ATTEMPTS
  // ----------------------------------------------------------

  List<QuizAttempt> _filterAttempts(List<QuizAttempt> attempts) {
    final now = DateTime.now();

    if (selectedTab == 0) {
      final startDate = now.subtract(const Duration(days: 7));
      return attempts.where((attempt) => attempt.playedAt.isAfter(startDate)).toList();
    }

    if (selectedTab == 1) {
      final startDate = now.subtract(const Duration(days: 30));
      return attempts.where((attempt) => attempt.playedAt.isAfter(startDate)).toList();
    }

    return attempts;
  }

  // ----------------------------------------------------------
  // BUILD LEADERBOARD
  // ----------------------------------------------------------
  List<_LeaderboardUser> _buildLeaderboard(List<QuizAttempt> attempts) {
    final Map<String, _LeaderboardUser> users = {};

    for (final attempt in attempts) {
      final String uid = attempt.userId;
      if (uid.isEmpty) continue;
      
      final String currentUsername = attempt.username.trim();

      if (!users.containsKey(uid)) {
        users[uid] = _LeaderboardUser(
          userId: uid,
          username: currentUsername.isNotEmpty ? currentUsername : 'Fandom Fan',
          avatar: attempt.avatar,
          points: attempt.points,
        );
      } else {
        final existing = users[uid]!;
        existing.points += attempt.points;
        
        // Keep the best name we find in the history of attempts
        if ((existing.username == 'Fandom Fan' || existing.username.isEmpty) && 
             currentUsername != 'Fandom Fan' && currentUsername.isNotEmpty) {
          existing.username = currentUsername;
        }
        if (existing.avatar.isEmpty && attempt.avatar.isNotEmpty) {
          existing.avatar = attempt.avatar;
        }
      }
    }

    final leaderboard = users.values.toList();
    leaderboard.sort((a, b) => b.points.compareTo(a.points));

    for (int i = 0; i < leaderboard.length; i++) {
      leaderboard[i].rank = i + 1;
    }

    return leaderboard;
  }

  // ----------------------------------------------------------
  // FETCH USER NAMES FROM FIRESTORE
  // ----------------------------------------------------------
  Stream<Map<String, String>> _getUserNamesStream(List<String> uids) {
    // Filter out empty IDs and limit to Firestore 'whereIn' capability (up to 30)
    final uniqueUids = uids.where((id) => id.isNotEmpty).toSet().toList();
    if (uniqueUids.isEmpty) return Stream.value({});
    
    // Fetch unique user profiles from the 'users' collection
    return FirebaseFirestore.instance
        .collection(FirebaseConstants.usersCollection)
        .where(FieldPath.documentId, whereIn: uniqueUids.take(30).toList())
        .snapshots()
        .map((snapshot) {
      final Map<String, String> names = {};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        // Try multiple field names just in case there's inconsistency in the database
        final String? name = (data['fullName'] ?? data['displayName'] ?? data['username'] ?? data['name'])?.toString();
        if (name != null && name.trim().isNotEmpty) {
          names[doc.id] = name;
        }
      }
      return names;
    });
  }


  // ----------------------------------------------------------
  // AVATAR WIDGET
  // ----------------------------------------------------------

  Widget _buildAvatar(String avatar) {
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
          errorBuilder: (context, error, stackTrace) => _defaultAvatar(),
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
  // RANK ICON/TEXT
  // ----------------------------------------------------------

  Widget _buildRank(int rank) {
    if (rank == 1) return const Icon(Icons.emoji_events, color: Color(0xFFFFD43B), size: 25);
    if (rank == 2) return const Icon(Icons.emoji_events, color: Color(0xFFC9D0DD), size: 25);
    if (rank == 3) return const Icon(Icons.emoji_events, color: Color(0xFFE99B43), size: 25);

    return SizedBox(
      width: 30,
      child: Text(
        '$rank',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  // ----------------------------------------------------------
  // LEADERBOARD ROW WIDGET
  // ----------------------------------------------------------

  Widget _buildLeaderboardRow(
      _LeaderboardUser user,
      Map<String, String> fetchedNames,
      String? currentUserId,
      String? currentUserFullName,
      String? currentUserPhotoUrl,
      ) {
    final bool isCurrentUser = currentUserId != null && currentUserId == user.userId;
    

    // 1. Check fetchedNames (current name from 'users' collection)
    // 2. Fallback to user.username (name saved in 'quizAttempts' record)
    String nameToDisplay = fetchedNames[user.userId] ?? user.username;
    
    if (isCurrentUser) {
      final name = currentUserFullName ?? nameToDisplay;
      nameToDisplay = (name.isNotEmpty && name != 'Fandom Fan') 
          ? ' $name'
          : '';
    }

    return Container(
      height: 78,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isCurrentUser ? const Color(0xFF17104D) : const Color(0xFF07143D),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: isCurrentUser ? const Color(0xFF8A35FF) : const Color(0xFF142D68),
          width: isCurrentUser ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 35, child: _buildRank(user.rank)),
          const SizedBox(width: 7),
          _buildAvatar(isCurrentUser ? (currentUserPhotoUrl ?? user.avatar) : user.avatar),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              nameToDisplay,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '${user.points} pts',
            style: const TextStyle(color: Color(0xFFFFC83D), fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access current user info from AuthBloc
    final authState = context.watch<AuthBloc>().state;
    final currentUser = authState.user;
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF030927),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF030927), Color(0xFF02061E), Color(0xFF07103A)],
            ),
          ),
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Leaderboard',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              // TABS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Container(
                  height: 47,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06113A),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFF1D4389)),
                  ),
                  child: Row(children: [_buildTab(0), _buildTab(1), _buildTab(2)]),
                ),
              ),
              const SizedBox(height: 22),
              // LIST
              Expanded(
                child: StreamBuilder<List<QuizAttempt>>(
                  stream: _service.getAttempts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFF7027FF)));
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Unable to load leaderboard', style: TextStyle(color: Colors.white70)));
                    }

                    final attempts = snapshot.data ?? [];
                    final filtered = _filterAttempts(attempts);
                    final leaderboard = _buildLeaderboard(filtered);

                    if (leaderboard.isEmpty) {
                      return const Center(child: Text('No quiz plays yet.', style: TextStyle(color: Colors.white70, fontSize: 15)));
                    }

                    // Prepare UIDs for the current view to fetch real names
                    final topUids = leaderboard.take(15).map((u) => u.userId).toList();
                    if (currentUserId != null && !topUids.contains(currentUserId)) {
                      topUids.add(currentUserId);
                    }

                    return StreamBuilder<Map<String, String>>(
                      stream: _getUserNamesStream(topUids),
                      builder: (context, nameSnapshot) {
                        final fetchedNames = nameSnapshot.data ?? {};
                        final topUsers = leaderboard.take(10).toList();
                        
                        _LeaderboardUser? currentUserEntry;
                        for (final user in leaderboard) {
                          if (user.userId == currentUserId) {
                            currentUserEntry = user;
                            break;
                          }
                        }

                        final bool userAlreadyInTopTen = currentUserEntry != null && currentUserEntry.rank <= 10;

                        return ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          children: [
                            ...topUsers.map((user) => _buildLeaderboardRow(
                                  user, 
                                  fetchedNames, 
                                  currentUserId, 
                                  currentUser?.fullName,
                                  currentUser?.photoUrl
                            )),
                            if (currentUserEntry != null && !userAlreadyInTopTen) ...[
                              const SizedBox(height: 20),
                              const Divider(color: Colors.white24),
                              const SizedBox(height: 10),
                              _buildLeaderboardRow(
                                  currentUserEntry, 
                                  fetchedNames, 
                                  currentUserId, 
                                  currentUser?.fullName,
                                  currentUser?.photoUrl
                              ),
                            ],
                            const SizedBox(height: 25),
                          ],
                        );
                      }
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

  Widget _buildTab(int index) {
    final bool isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF7027FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            tabs[index],
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

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
