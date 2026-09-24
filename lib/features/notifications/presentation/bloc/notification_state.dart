import 'package:equatable/equatable.dart';

import '../../../../models/notification_model.dart';

enum NotificationStatus { loading, loaded, error }

class NotificationState extends Equatable {
  const NotificationState({
    this.status = NotificationStatus.loading,
    this.notifications = const [],
    this.errorMessage,
  });

  final NotificationStatus status;
  final List<NotificationModel> notifications;
  final String? errorMessage;

  bool get hasUnread => notifications.any((n) => !n.isRead);

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationModel>? notifications,
    String? errorMessage,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, notifications, errorMessage];
}
