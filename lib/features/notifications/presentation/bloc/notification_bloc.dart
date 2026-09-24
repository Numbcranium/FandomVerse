import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/repositories/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc(this._repository) : super(const NotificationState()) {
    on<NotificationsSubscriptionRequested>(_onSubscriptionRequested);
    on<NotificationMarkAsReadRequested>(_onMarkAsReadRequested);
    on<NotificationMarkAllAsReadRequested>(_onMarkAllAsReadRequested);
  }

  final NotificationRepository _repository;
  String? _userId;

  Future<void> _onSubscriptionRequested(
    NotificationsSubscriptionRequested event,
    Emitter<NotificationState> emit,
  ) async {
    _userId = event.userId;
    await emit.forEach(
      _repository.watchNotifications(event.userId),
      onData: (notifications) => state.copyWith(
        status: NotificationStatus.loaded,
        notifications: notifications,
      ),
      onError: (error, _) => state.copyWith(
        status: NotificationStatus.error,
        errorMessage: AppException.from(error).message,
      ),
    );
  }

  Future<void> _onMarkAsReadRequested(
    NotificationMarkAsReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final userId = _userId;
    if (userId == null) return;
    try {
      await _repository.markAsRead(userId, event.notificationId);
      // No manual emit needed — the Firestore listener above will push
      // the updated list automatically.
    } catch (e) {
      emit(state.copyWith(errorMessage: AppException.from(e).message));
    }
  }

  Future<void> _onMarkAllAsReadRequested(
    NotificationMarkAllAsReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final userId = _userId;
    if (userId == null) return;
    try {
      await _repository.markAllAsRead(userId);
    } catch (e) {
      emit(state.copyWith(errorMessage: AppException.from(e).message));
    }
  }
}
