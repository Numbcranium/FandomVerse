/// Firestore collection / storage path names, centralized so a typo can't
/// silently create a duplicate collection.
///
/// Only collections that exist today are listed. New ones (bookings,
/// products, orders, etc.) should be added here once the SRS requires them
/// — do not create ad-hoc collection strings inside repositories.
class FirebaseConstants {
  const FirebaseConstants._();

  // --- Firestore collections ---
  static const String usersCollection = 'users';
  static const String notificationsCollection = 'notifications';

  // --- Firestore field names shared across models ---
  static const String fieldCreatedAt = 'createdAt';
  static const String fieldUpdatedAt = 'updatedAt';

  // --- Firebase Storage paths ---
  static const String storageProfileImages = 'profile_images';

  // --- Firebase Cloud Messaging ---
  static const String fcmTokenField = 'fcmToken';
  static const String defaultNotificationChannelId = 'default_channel';
  static const String defaultNotificationChannelName = 'General';
}
