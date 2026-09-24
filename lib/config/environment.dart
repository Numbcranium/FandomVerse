/// Which backend/config environment the app is running against.
///
/// Kept intentionally minimal — a starter doesn't need multiple Firebase
/// projects wired up yet, but this makes it a one-line change later
/// (e.g. picking a different `firebase_options.dart` per flavor) instead
/// of a restructure.
enum Environment { development, staging, production }

class EnvironmentConfig {
  const EnvironmentConfig._();

  /// Change this (or wire it to `--dart-define=ENV=...` /  build flavors)
  /// once the competition needs more than one environment.
  static const Environment current = Environment.development;

  static bool get isProduction => current == Environment.production;

  static bool get isDevelopment => current == Environment.development;
}
