import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../../app/router/route_names.dart';

/// Plays the team's intro clip once at the very start of every app
/// launch, before splash/auth resolution even begins — this is
/// `initialLocation` in `AppRouter`, and the only route the router's
/// redirect logic exempts entirely, so it always shows regardless of
/// auth state.
///
/// Advances to [RouteNames.splash] automatically when the video finishes,
/// or immediately if the video fails to load or errors during playback — a
/// playback problem should never be able to block someone from opening the
/// app. A tappable "Skip" is also always available.
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late final VideoPlayerController _controller;
  bool _hasAdvanced = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/fandom-verse.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _controller
          ..addListener(_onVideoProgress)
          ..play();
      }).catchError((Object _) => _advance());
  }

  void _onVideoProgress() {
    final value = _controller.value;

    // Playback broke partway through — don't leave the user on a black screen.
    if (value.hasError) {
      _advance();
      return;
    }

    if (value.isInitialized &&
        !value.isPlaying &&
        value.position >= value.duration &&
        value.duration > Duration.zero) {
      _advance();
    }
  }

  void _advance() {
    if (_hasAdvanced) return;
    _hasAdvanced = true;
    if (mounted) context.go(RouteNames.splash);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onVideoProgress)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_controller.value.isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: TextButton(
                onPressed: _advance,
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: const Text('Skip'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}