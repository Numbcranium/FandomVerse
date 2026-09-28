import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_button.dart';

/// First-launch welcome screen.
///
/// Marks first launch as complete in [SharedPreferences] before
/// navigating to login, so `AppRouter`'s `isFirstLaunch` check sends
/// returning signed-out users straight to login instead of back here.
///
/// TODO(Phase 5+): move the SharedPreferences read/write here into a
/// dedicated `core/services` wrapper once that layer exists, so screens
/// don't touch `shared_preferences` directly.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _getStarted(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefsFirstLaunchKey, true);
    if (context.mounted) context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                Icons.rocket_launch_outlined,
                size: 96,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: AppConstants.spaceLg),
              Text(
                'Welcome to ${AppConstants.appName}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: AppConstants.spaceSm),
              Text(
                'A fast, reliable starting point — ready to become '
                'whatever this competition needs.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              AppButton(
                text: 'Get Started',
                onPressed: () => _getStarted(context),
              ),
              SizedBox(height: AppConstants.spaceMd),
            ],
          ),
        ),
      ),
    );
  }
}
