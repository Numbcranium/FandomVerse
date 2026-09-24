import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Thin wrapper around Firebase Cloud Messaging.
///
/// Deliberately minimal per the starter's scope (section 15/25 of the
/// brief): request permission, expose the device token, and expose the
/// foreground-message stream. Wiring this token to a user's Firestore
/// document, handling notification taps, and configuring platform
/// notification channels are left for once the SRS defines what
/// notifications the app actually needs to send.
class NotificationService {
  NotificationService({FirebaseMessaging? messaging})
      : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  Future<void> requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// The device's current FCM token, or `null` if unavailable (e.g.
  /// permission denied, or running somewhere push isn't supported).
  Future<String?> getToken() {
    try {
      return _messaging.getToken();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('NotificationService.getToken failed: $e');
      }
      return Future.value(null);
    }
  }

  /// Messages received while the app is in the foreground. Pair this with
  /// a local-notifications package later if in-app banners are needed —
  /// not added here to avoid an unused dependency until the SRS confirms
  /// it's needed.
  Stream<RemoteMessage> get onForegroundMessage => FirebaseMessaging.onMessage;

  /// Fired when the user taps a notification that opened/resumed the app.
  Stream<RemoteMessage> get onMessageOpenedApp => FirebaseMessaging.onMessageOpenedApp;
}
