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

// event routes
import '../../features/events/presentation/screens/calender_screen.dart';
import '../../features/events/presentation/screens/events_screen.dart';
import '../../features/events/presentation/screens/events_details_screen.dart';
import '../../features/events/presentation/screens/events_filters_screen.dart';
import '../../features/events/presentation/screens/events_search_screen.dart';
import '../../features/events/presentation/screens/map_screen.dart';
import '../../features/events/presentation/screens/nearby_events_screen.dart';

//ticket routes
import '../../features/tickets/presentation/screens/my_tickets_screen.dart';
import '../../features/tickets/presentation/screens/ticket_screen.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/merchandise/shop_screen.dart';
import '../../features/community/presentation/screens/community_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/widgets/fandom_details_screen.dart';
import '../../features/home/presentation/widgets/fandom_gallery_screen.dart';
import '../../features/home/presentation/widgets/fandom_news_screen.dart';
import '../../features/home/presentation/widgets/fandom_trivia_screen.dart';
import '../../features/home/presentation/widgets/fandom_video_screen.dart';
import '../../features/home/presentation/widgets/search_screen.dart';
import '../../features/home/presentation/widgets/trending_fandoms.dart';
import '../../features/intro/presentation/screens/intro_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/bookmarks_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/purchase_history_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/home/presentation/screens/merchandise/shop_screen.dart';
import '../../features/trivia/presentation/screens/choose_fandom_screen.dart';
import '../../features/trivia/presentation/screens/trivia_leaderboard_screen.dart';
import '../../features/trivia/presentation/screens/trivia_pop_start_screen.dart';
import '../../features/ai_helper/presentation/screens/ai_helper_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/trivia/presentation/screens/trivia_question_screen.dart';
import 'route_names.dart';

/// Builds and owns the app's [GoRouter] instance.
class AppRouter {
  AppRouter({
    required AuthStatus Function() authStatus,
    required bool Function() isFirstLaunch,
    required bool Function() needsInterestsSelection,
    required bool Function() isAdmin,
    required Listenable refreshListenable,
  })  : _authStatus = authStatus,
        _isFirstLaunch = isFirstLaunch,
        _needsInterestsSelection = needsInterestsSelection,
        _isAdmin = isAdmin {
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
  final bool Function() _isAdmin;

  late final GoRouter router;

  String? _redirect(BuildContext context, GoRouterState state) {
    final currentPath = state.matchedLocation;

    // The intro screen is never redirected.
    if (currentPath == RouteNames.intro) return null;

    final status = _authStatus();

    // Still resolving auth state.
    if (status == AuthStatus.unknown) {
      return currentPath == RouteNames.splash
          ? null
          : RouteNames.splash;
    }

    final isPublicRoute = RouteNames.publicPaths.contains(currentPath);

    // User is not authenticated.
    if (status == AuthStatus.unauthenticated ||
        status == AuthStatus.authenticating) {
      if (isPublicRoute && currentPath != RouteNames.splash) {
        return null;
      }

      return _isFirstLaunch()
          ? RouteNames.onboarding
          : RouteNames.login;
    }

    // User is authenticated.
    // status == AuthStatus.authenticated
    // Admins are locked into the admin dashboard only.
    if (_isAdmin()) {
      return currentPath == RouteNames.adminDashboard ? null : RouteNames.adminDashboard;
    }

    if (_needsInterestsSelection()) {
      return currentPath == RouteNames.interests
          ? null
          : RouteNames.interests;
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

    // Merchandise mock
    GoRoute(
      path: '/merchandise',
      name: 'merchandise',
      builder: (context, state) => const ShopScreen(),
    ),

    GoRoute(
      path: RouteNames.trivia,
      name: RouteNames.triviaName,
      builder: (context, state) => const TriviaPopStartScreen(),
    ),
    GoRoute(
      path: RouteNames.triviaLeaderboard,
      name: RouteNames.triviaLeaderboardName,
      builder: (context, state) {
        return const TriviaLeaderboardScreen();
      },
    ),
    GoRoute(
      path: RouteNames.fandoms,
      name: RouteNames.fandomsName,
      builder: (context, state) => const TrendingFandoms(),
    ),
    GoRoute(
      path: RouteNames.fandomNews,
      name: RouteNames.fandomNewsName,
      builder: (context, state) {
        final fandomId =
        state.pathParameters['fandomId']!;

        return FandomNewsScreen(
          fandomId: fandomId,
        );
      },
    ),
    GoRoute(
      path: RouteNames.fandomGallery,
      name: RouteNames.fandomGalleryName,
      builder: (context, state) {
        final fandomId =
        state.pathParameters['fandomId']!;

        return FandomGalleryScreen(
          fandomId: fandomId,
        );
      },
    ),
    GoRoute(
      path: RouteNames.fandomDetails,
      name: RouteNames.fandomDetailsName,
      builder: (context, state) {
        final fandomId =
        state.pathParameters['fandomId']!;

        return FandomDetailsScreen(
          fandomId: fandomId,
        );
      },
    ),
    GoRoute(
      path: RouteNames.fandomVideo,
      name: RouteNames.fandomVideoName,
      builder: (context, state) {
        final fandomId =
        state.pathParameters['fandomId']!;

        return FandomVideoScreen(
          fandomId: fandomId,
        );
      },
    ),
    GoRoute(
      path: RouteNames.fandomTrivia,
      name: RouteNames.fandomTriviaName,
      builder: (context, state) {
        final fandomId =
        state.pathParameters['fandomId']!;

        return FandomTriviaScreen(
          fandomId: fandomId,
        );
      },
    ),
    GoRoute(
      path: RouteNames.chooseFandom,
      name: RouteNames.chooseFandomName,
      builder: (context, state) {
        return const ChooseFandomScreen();
      },
    ),

  GoRoute(
  path: RouteNames.triviaQuestions,
  name: RouteNames.triviaQuestionsName,
  builder: (context, state) {
  final fandomId =
  state.pathParameters['fandomId']!;

  return TriviaQuestionsScreen(
  fandomId: fandomId,
  );
  },
  ),

    GoRoute(
      path: RouteNames.homeSearch,
      name: RouteNames.searchHomeName,
      builder: (context, state) => const SearchScreen(),
    ),

    GoRoute(
      path: RouteNames.community,
      name: RouteNames.communityName,
      builder: (context, state) => const CommunityScreen(),
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
    // events routing
    GoRoute(
      path: RouteNames.events,
      name: RouteNames.eventsName,
      builder: (context, state) => const EventsScreen(),
    ),

    GoRoute(
      path: RouteNames.eventCalendar,
      name: RouteNames.eventCalendarName,
      builder: (context, state) => const CalendarScreen(),
    ),

    GoRoute(
      path: RouteNames.nearbyEvents,
      name: RouteNames.nearbyEventsName,
      builder: (context, state) => const NearbyEventsScreen(),
    ),

    GoRoute(
      path: RouteNames.eventMap,
      name: RouteNames.eventMapName,
      builder: (context, state) {
        final eventId = state.uri.queryParameters['eventId'];

        return MapScreen(
          eventId: eventId,
        );
      },
    ),

    GoRoute(
      path: RouteNames.eventSearch,
      name: RouteNames.eventSearchName,
      builder: (context, state) => const EventSearchScreen(),
    ),

    GoRoute(
      path: RouteNames.eventFilters,
      name: RouteNames.eventFiltersName,
      builder: (context, state) => const EventFiltersScreen(),
    ),

    GoRoute(
      path: RouteNames.eventDetails,
      name: RouteNames.eventDetailsName,
      builder: (context, state) {
        final eventId = state.pathParameters['eventId'];

        return EventDetailsScreen(
          eventId: eventId!,
        );
      },
  ),
    GoRoute(
      path: RouteNames.aiHelper,
      name: RouteNames.aiHelperName,
      builder: (context, state) => const AiHelperScreen(),
    ),
    GoRoute(
      path: RouteNames.adminDashboard,
      name: RouteNames.adminDashboardName,
      builder: (context, state) => const AdminDashboardScreen(),
    ),

    // ticket screens
    GoRoute(
      path: RouteNames.myTickets,
      name: RouteNames.myTicketsName,
      builder: (context, state) {
        return const MyTicketsScreen();
      },
    ),

    GoRoute(
      path: RouteNames.ticket,
      name: RouteNames.ticketName,
      builder: (context, state) {
        final ticketId = state.pathParameters['ticketId'];

        return TicketScreen(
          ticketId: ticketId!,
        );
      },
    ),

  ];
}

/// Adapts a [Stream] into a [Listenable] that [GoRouter] can use
/// to refresh route redirects.
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