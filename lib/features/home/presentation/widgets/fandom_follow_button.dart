import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../models/fandom_follow_service.dart';


class FandomFollowButton extends StatelessWidget {
  final String fandomId;

  const FandomFollowButton({
    super.key,
    required this.fandomId,
  });

  @override
  Widget build(BuildContext context) {
    // for real users that logins in to the app
    final user = FirebaseAuth.instance.currentUser;

    // User is not logged in
    if (user == null) {
      return SizedBox();
    }

    final userId = user.uid;

    final followService = FandomFollowService();

    return StreamBuilder<bool>(
      stream: followService.isFollowing(
        fandomId: fandomId,
        userId: userId,
      ),
      builder: (context, snapshot) {
        final isFollowing = snapshot.data ?? false;

        return SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            onPressed: () async {
              if (isFollowing) {
                await followService.unfollowFandom(
                  fandomId: fandomId,
                  userId: userId,
                );
              } else {
                await followService.followFandom(
                  fandomId: fandomId,
                  userId: userId,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isFollowing
                  ? Colors.grey
                  : const Color(0xFF8FA8F5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              isFollowing ? 'Following' : 'Follow',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}