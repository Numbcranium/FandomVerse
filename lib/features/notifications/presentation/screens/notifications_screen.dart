import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../models/notification_model.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/repositories/notification_repository.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthBloc>().state.user?.id ?? '';

    return BlocProvider<NotificationBloc>(
      create: (context) {
        // TODO(Phase 9 wiring): promote `NotificationRepository` to a
        // RepositoryProvider at app root if another screen ends up
        // needing it too — kept screen-local for now since only this
        // screen currently does.
        final NotificationRepository repository = NotificationRepositoryImpl(
          FirestoreNotificationRemoteDataSource(),
        );
        return NotificationBloc(repository)
          ..add(NotificationsSubscriptionRequested(userId));
      },
      child: const _NotificationsView(),
    );
  }
}

// Reached from the Home app bar's bell icon, not the bottom nav (the
// team's 5-tab nav is Home/Explore/Events/Shop/Profile) — so this is a
// plain pushed sub-page with a back button, not a tab root.
class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () => context
                .read<NotificationBloc>()
                .add(const NotificationMarkAllAsReadRequested()),
            child: Text('Mark all read'),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            switch (state.status) {
              case NotificationStatus.loading:
                return const AppLoading();
              case NotificationStatus.error:
                return AppError(
                  message: state.errorMessage ?? 'Something went wrong.',
                  onRetry: () {
                    final userId = context.read<AuthBloc>().state.user?.id ?? '';
                    context
                        .read<NotificationBloc>()
                        .add(NotificationsSubscriptionRequested(userId));
                  },
                );
              case NotificationStatus.loaded:
                if (state.notifications.isEmpty) {
                  return const AppEmptyState(
                    icon: Icons.notifications_none,
                    title: 'No notifications',
                    message: "You're all caught up.",
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(AppConstants.spaceMd),
                  itemCount: state.notifications.length,
                  separatorBuilder: (_, __) => SizedBox(height: AppConstants.spaceSm),
                  itemBuilder: (context, index) {
                    final notification = state.notifications[index];
                    return _NotificationTile(notification: notification);
                  },
                );
            }
          },
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: notification.isRead
          ? null
          : () => context
              .read<NotificationBloc>()
              .add(NotificationMarkAsReadRequested(notification.id)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!notification.isRead)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6, right: AppConstants.spaceSm),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
                      ),
                ),
                SizedBox(height: 4),
                Text(notification.message, style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(height: 6),
                Text(
                  Formatters.relativeTime(notification.createdAt),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
