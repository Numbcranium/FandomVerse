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

  // --- Events ---
  static const String events = '/events';
  static const String eventDetails = '/events/:eventId';
  static const String eventCalendar = '/events/calendar';
  static const String nearbyEvents = '/events/nearby';
  static const String eventMap = '/events/map';
  static const String eventSearch = '/events/search';
  static const String eventFilters = '/events/filters';

  // --- Event route names ---
  static const String eventsName = 'events';
  static const String eventDetailsName = 'eventDetails';
  static const String eventCalendarName = 'eventCalendar';
  static const String nearbyEventsName = 'nearbyEvents';
  static const String eventMapName = 'eventMap';
  static const String eventSearchName = 'eventSearch';
  static const String eventFiltersName = 'eventFilters';

  // event tickets route name

  static const String ticket = '/tickets/:ticketId';
  static const String ticketName = 'ticket';
  static const String myTickets = '/tickets';
  static const String myTicketsName = 'myTickets';

  /// Routes reachable without being logged in.
  static const List<String> publicPaths = [
    splash,
    onboarding,
    login,
    register,
    forgotPassword,
  ];
}