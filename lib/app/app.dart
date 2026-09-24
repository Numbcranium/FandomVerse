import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_constants.dart';
import 'theme/app_theme.dart';

/// Root widget: wires [AppTheme] and a [GoRouter] together.
///
/// Deliberately takes the built `GoRouter` as a constructor parameter
/// rather than constructing `AppRouter` itself — `main.dart` (Phase 5,
/// once Firebase is initialized) is responsible for building `AppRouter`
/// with real auth-state callbacks and passing `router.router` in here.
class App extends StatelessWidget {
  const App({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // The product is designed dark-first (every mockup uses the dark
      // palette) — force dark rather than following system settings so
      // the app always matches the team's design during grading/demo.
      // Flip to ThemeMode.system once/if a light-mode toggle is wanted.
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
