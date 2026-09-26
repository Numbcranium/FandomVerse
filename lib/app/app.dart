import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router/route_names.dart';

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
      builder: (context, child) {
        return _GlobalFabOverlay(
          router: router,
          child: child ?? const SizedBox.shrink(),
        );
      },
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

class _GlobalFabOverlay extends StatefulWidget {
  final GoRouter router;
  final Widget child;

  const _GlobalFabOverlay({required this.router, required this.child});

  @override
  State<_GlobalFabOverlay> createState() => _GlobalFabOverlayState();
}

class _GlobalFabOverlayState extends State<_GlobalFabOverlay> {
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    widget.router.routerDelegate.addListener(_routeListener);
    // Delay the initial check slightly to allow initial route to settle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkRoute();
    });
  }

  @override
  void dispose() {
    widget.router.routerDelegate.removeListener(_routeListener);
    super.dispose();
  }

  void _routeListener() {
    _checkRoute();
  }

  void _checkRoute() {
    final location = widget.router.routerDelegate.currentConfiguration.uri.path;
    final hideRoutes = [
      RouteNames.intro,
      RouteNames.splash,
      RouteNames.onboarding,
      RouteNames.login,
      RouteNames.register,
      RouteNames.forgotPassword,
      RouteNames.aiHelper,
      '/', // Hide on root before redirect
    ];

    final shouldShow = !hideRoutes.contains(location);

    if (_showFab != shouldShow) {
      setState(() {
        _showFab = shouldShow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showFab)
          Positioned(
            right: 16,
            bottom: 96,
            child: SafeArea(
              child: FloatingActionButton(
                heroTag: 'aiHelperFab',
                onPressed: () {
                  widget.router.push(RouteNames.aiHelper);
                },
                child: const Icon(Icons.smart_toy),
              ),
            ),
          ),
      ],
    );
  }
}
