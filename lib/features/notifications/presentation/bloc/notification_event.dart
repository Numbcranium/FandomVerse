import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationsSubscriptionRequested extends NotificationEvent {
  const NotificationsSubscriptionRequested(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class NotificationMarkAsReadRequested extends NotificationEvent {
  const NotificationMarkAsReadRequested(this.notificationId);

  final String notificationId;

  @override
  List<Object?> get props => [notificationId];
}

class NotificationMarkAllAsReadRequested extends NotificationEvent {
  const NotificationMarkAllAsReadRequested();
}
