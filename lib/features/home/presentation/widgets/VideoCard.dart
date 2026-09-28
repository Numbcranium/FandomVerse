import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../models/fandom_video.dart';

class Videocard extends StatefulWidget {
  final FandomVideo video;

  const Videocard({
    super.key,
    required this.video,
  });

  @override
  State<Videocard> createState() => _VideocardState();
}

class _VideocardState extends State<Videocard> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Video is stored in Flutter assets
    _controller = VideoPlayerController.asset(
      widget.video.video,
    )
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.isInitialized
                ? _controller.value.aspectRatio
                : 16 / 9,
            child: _controller.value.isInitialized
                ? Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_controller),

                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause_circle
                        : Icons.play_circle,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    size: 60,
                  ),
                ),
              ],
            )
                : Center(
              child: CircularProgressIndicator(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              widget.video.title,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}