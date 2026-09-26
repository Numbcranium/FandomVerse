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
      backgroundColor: const Color(0xFF0B0A24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0A24),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Videos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<FandomVideo>>(
        stream: videoService.getVideos(fandomId),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Unable to load video',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            );
          }

          final videos = snapshot.data ?? [];

          if (videos.isEmpty) {
            return const Center(
              child: Text(
                'No video available',
                style: TextStyle(
                  color: Colors.white54,
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