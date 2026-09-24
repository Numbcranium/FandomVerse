/// App-wide constants that aren't secrets and aren't Firebase-specific.
///
/// Keep this file flat and dependency-free so it can be imported from
/// anywhere (theme, widgets, validators) without creating import cycles.
class AppConstants {
  const AppConstants._();

  // --- App info ---
  static const String appName = 'TechWiz 7 App';

  // --- Spacing scale (use these instead of magic numbers) ---
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;
  static const double spaceXxl = 48;

  // --- Border radius scale ---
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusPill = 999;

  // --- Elevation ---
  static const double elevationNone = 0;
  static const double elevationLow = 1;
  static const double elevationMedium = 3;

  // --- Animation durations ---
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 400);

  // --- Debounce / throttle ---
  static const Duration searchDebounce = Duration(milliseconds: 400);

  // --- Pagination ---
  static const int defaultPageSize = 20;

  // --- Local storage keys (shared_preferences / secure storage) ---
  static const String prefsFirstLaunchKey = 'has_launched_before';
  static const String prefsThemeModeKey = 'theme_mode';
  static const String secureAuthTokenKey = 'auth_token';

  // --- Validation limits ---
  static const int minPasswordLength = 8;
  static const int maxFullNameLength = 80;
}
