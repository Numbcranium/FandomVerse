/// Centralized route paths and names.
///
/// Use [RouteNames] constants everywhere (router setup, `context.go(...)`,
/// `context.goNamed(...)`) instead of hard-coding path strings — keeps
/// route changes to a single file.
class RouteNames {
  const RouteNames._();

  // --- Paths (used by GoRoute.path and context.go) ---
  static const String intro = '/intro';
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String interests = '/interests';
  static const String home = '/home';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String bookmarks = '/bookmarks';
  static const String purchaseHistory = '/purchase-history';
  static const String community = '/community';

  // --- Names (used by GoRoute.name and context.goNamed) ---
  static const String introName = 'intro';
  static const String splashName = 'splash';
  static const String onboardingName = 'onboarding';
  static const String loginName = 'login';
  static const String registerName = 'register';
  static const String forgotPasswordName = 'forgotPassword';
  static const String interestsName = 'interests';
  static const String homeName = 'home';
  static const String notificationsName = 'notifications';
  static const String profileName = 'profile';
  static const String editProfileName = 'editProfile';
  static const String settingsName = 'settings';
  static const String bookmarksName = 'bookmarks';
  static const String purchaseHistoryName = 'purchaseHistory';
  static const String communityName = 'community';

  /// Routes reachable without being logged in.
  static const List<String> publicPaths = [
    splash,
    onboarding,
    login,
    register,
    forgotPassword,
  ];

}