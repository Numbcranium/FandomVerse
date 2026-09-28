import 'package:flutter/material.dart';

import '../../../../models/fandom_video.dart';
import '../../../../models/fandom_video_service.dart';
import 'VideoCard.dart';

class FandomVideoScreen extends StatelessWidget {
  final String fandomId;

  const FandomVideoScreen({
    super.key,
    required this.fandomId,
  });

  @override
  Widget build(BuildContext context) {
    final videoService = FandomVideoService();

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
          'Videos',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<FandomVideo>>(
        stream: videoService.getVideos(fandomId),
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
                'Unable to load video',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            );
          }

          final videos = snapshot.data ?? [];

          if (videos.isEmpty) {
            return Center(
              child: Text(
                'No video available',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            );
          }

          // Only one video
          final video = videos.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Videocard(
              video: video,
            ),
          );
        },
      ),
    );
  }
}