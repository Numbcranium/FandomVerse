import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Standard loading indicator for the "loading" branch of a screen's
/// state (see the Loading/Success/Empty/Error convention used across
/// data-driven screens).
class AppLoading extends StatelessWidget {
  const AppLoading({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(strokeWidth: 2.5),
          if (message != null) ...[
            const SizedBox(height: AppConstants.spaceMd),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

/// Full-screen semi-transparent overlay spinner — use for a blocking
/// action on top of an already-rendered screen (e.g. submitting a form)
/// rather than replacing the whole body with [AppLoading].
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.35),
      child: AppLoading(message: message),
    );
  }
}
