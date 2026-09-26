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
  static const String fandoms = '/fandoms';
  static const String fandomDetails = '/fandom/:fandomId';
  static const String homeSearch = '/homeSearch';
  static const String fandomNews = '/fandom/:fandomId/news';
  static const String fandomGallery = '/fandom/:fandomId/gallery';
  static const String fandomVideo =  '/fandom/:fandomId/video';
  static const String fandomTrivia = '/fandom/:fandomId/trivia';
  static const String trivia = '/trivia';
  static const String chooseFandom = '/trivia/choose-fandom';
  static const String triviaQuestions = '/trivia/questions/:fandomId';
  static const String aiHelper = '/ai-helper';
  static const String adminDashboard = '/admin';

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
  static const String  fandomsName = 'fandoms';
  static const String fandomDetailsName = 'fandomDetails';
  static const String  searchHomeName  = 'homeSearch';
  static const String fandomNewsName = 'fandomNews';
  static const String fandomGalleryName = 'fandomGallery';
  static const String fandomVideoName = 'fandomVideo';
  static const String fandomTriviaName = 'fandomTrivia';
  static const String triviaName = 'trivia';
  static const String chooseFandomName = 'chooseFandom';
  static const String triviaQuestionsName = 'triviaQuestions';




  static const String aiHelperName = 'aiHelper';
  static const String adminDashboardName = 'adminDashboard';

  /// Routes reachable without being logged in.
  static const List<String> publicPaths = [
    splash,
    onboarding,
    login,
    register,
    forgotPassword,
  ];

}