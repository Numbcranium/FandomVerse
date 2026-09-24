import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_state.dart' show AuthStatus;
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/interests_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/intro/presentation/screens/intro_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/bookmarks_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/purchase_history_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import 'route_names.dart';

/// Builds and owns the app's [GoRouter] instance.
///
/// [AuthStatus] (defined alongside `AuthBloc`'s state) is what drives
/// route protection here:
/// - [RouteNames.intro] is the `initialLocation` and is exempt from all
///   redirect logic, so the intro clip always plays regardless of auth
///   state. It hands off to splash itself when it finishes.
/// - While status is [AuthStatus.unknown], stay on splash.
/// - [AuthStatus.authenticating] is treated the same as unauthenticated —
///   a login/register submission in flight shouldn't unlock protected
///   routes before Firebase confirms the session.
/// - Unauthenticated users may only reach [RouteNames.publicPaths]; any
///   other route redirects to onboarding (first launch) or login.
/// - Authenticated users with no fandoms picked yet
///   ([needsInterestsSelection]) are routed to [RouteNames.interests] —
///   a one-time step, same pattern as first-launch onboarding — before
///   anywhere else.
/// - Otherwise, authenticated users are redirected away from splash/
///   onboarding/login/register/forgot-password/interests straight home.
class AppRouter {
  AppRouter({
    required AuthStatus Function() authStatus,
    required bool Function() isFirstLaunch,
    required bool Function() needsInterestsSelection,
    required Listenable refreshListenable,
  })  : _authStatus = authStatus,
        _isFirstLaunch = isFirstLaunch,
        _needsInterestsSelection = needsInterestsSelection {
    router = GoRouter(
      initialLocation: RouteNames.intro,
      debugLogDiagnostics: false,
      refreshListenable: refreshListenable,
      redirect: _redirect,
      routes: _routes,
    );
  }

  final AuthStatus Function() _authStatus;
  final bool Function() _isFirstLaunch;
  final bool Function() _needsInterestsSelection;

  late final GoRouter router;

  String? _redirect(BuildContext context, GoRouterState state) {
    final currentPath = state.matchedLocation;

    // The intro screen is never redirected, whatever the auth status is.
    if (currentPath == RouteNames.intro) return null;

    final status = _authStatus();

    // Still resolving auth state (e.g. splash checking Firebase Auth) —
    // hold position, don't redirect yet.
    if (status == AuthStatus.unknown) {
      return currentPath == RouteNames.splash ? null : RouteNames.splash;
    }

    final isPublicRoute = RouteNames.publicPaths.contains(currentPath);

    // Treat an in-flight login/register submission the same as signed-out
    // for route protection — don't unlock protected routes early.
    if (status == AuthStatus.unauthenticated || status == AuthStatus.authenticating) {
      if (isPublicRoute && currentPath != RouteNames.splash) {
        return null; // already headed somewhere a logged-out user can be
      }
      return _isFirstLaunch() ? RouteNames.onboarding : RouteNames.login;
    }

    // status == AuthStatus.authenticated
    if (_needsInterestsSelection()) {
      return currentPath == RouteNames.interests ? null : RouteNames.interests;
    }
    if (isPublicRoute || currentPath == RouteNames.interests) {
      return RouteNames.home;
    }
    return null;
  }

  List<RouteBase> get _routes => [
    GoRoute(
      path: RouteNames.intro,
      name: RouteNames.introName,
      builder: (context, state) => const IntroScreen(),
    ),
    GoRoute(
      path: RouteNames.splash,
      name: RouteNames.splashName,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.onboarding,
      name: RouteNames.onboardingName,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RouteNames.login,
      name: RouteNames.loginName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteNames.register,
      name: RouteNames.registerName,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: RouteNames.forgotPassword,
      name: RouteNames.forgotPasswordName,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: RouteNames.interests,
      name: RouteNames.interestsName,
      builder: (context, state) => const InterestsScreen(),
    ),
    GoRoute(
      path: RouteNames.home,
      name: RouteNames.homeName,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RouteNames.notifications,
      name: RouteNames.notificationsName,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: RouteNames.profile,
      name: RouteNames.profileName,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: RouteNames.editProfile,
      name: RouteNames.editProfileName,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: RouteNames.settings,
      name: RouteNames.settingsName,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: RouteNames.bookmarks,
      name: RouteNames.bookmarksName,
      builder: (context, state) => const BookmarksScreen(),
    ),
    GoRoute(
      path: RouteNames.purchaseHistory,
      name: RouteNames.purchaseHistoryName,
      builder: (context, state) => const PurchaseHistoryScreen(),
    ),
  ];
}

/// Adapts any [Stream] (e.g. `FirebaseAuth.instance.authStateChanges()`,
/// or an `AuthBloc`'s `.stream`) into a [Listenable] that [GoRouter] can
/// use as `refreshListenable`, so the router re-evaluates `redirect` every
/// time auth state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (_) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}