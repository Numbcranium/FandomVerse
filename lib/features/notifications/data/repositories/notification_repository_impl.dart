import '../../../../core/errors/app_exception.dart';
import '../../../../models/notification_model.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._remoteDataSource);

  final NotificationRemoteDataSource _remoteDataSource;

  @override
  Stream<List<NotificationModel>> watchNotifications(String userId) {
    return _remoteDataSource.watchNotifications(userId).handleError((Object error) {
      throw AppException.from(error);
    });
  }

  @override
  Future<void> markAsRead(String userId, String notificationId) async {
    try {
      await _remoteDataSource.markAsRead(userId, notificationId);
    } catch (e) {
      throw AppException.from(e);
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    try {
      await _remoteDataSource.markAllAsRead(userId);
    } catch (e) {
      throw AppException.from(e);
    }
  }
}
