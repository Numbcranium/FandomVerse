import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

/// Shown while `AuthBloc` resolves the initial session
/// (`AuthStatus.unknown`). Purely presentational — `AppRouter`'s redirect
/// logic moves the user off this screen automatically once the status
/// resolves to authenticated or unauthenticated, so this screen doesn't
/// need to navigate itself.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.bolt_rounded,
                size: 44,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppConstants.spaceLg),
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
            ),
            SizedBox(height: AppConstants.spaceXl),
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
