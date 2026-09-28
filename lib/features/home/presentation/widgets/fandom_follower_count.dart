// for numbers of people following
import 'package:flutter/material.dart';
import '../../../../models/fandom_follow_service.dart';

class FandomFollowerCount extends StatelessWidget {
  final String fandomId;

  const FandomFollowerCount({
    super.key,
    required this.fandomId,
  });

  // it is in the fandom follow service

  @override
  Widget build(BuildContext context) {
    final followService = FandomFollowService();

    return StreamBuilder<int>(stream: followService.getFollowerCount(fandomId,),
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;

        return Text(
          '$count Followers',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontSize: 14,
          ),
        );
      },
    );
  }
}