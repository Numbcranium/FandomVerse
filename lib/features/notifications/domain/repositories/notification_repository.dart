import '../../../../models/notification_model.dart';

abstract class NotificationRepository {
  /// Live-updating list of [userId]'s notifications, newest first.
  Stream<List<NotificationModel>> watchNotifications(String userId);

  Future<void> markAsRead(String userId, String notificationId);

  /// Marks every unread notification for [userId] as read — used by a
  /// "mark all as read" action.
  Future<void> markAllAsRead(String userId);
}
