import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/coming_soon.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Generic, domain-agnostic home/dashboard screen (brief section 12).
///
/// Quick actions, stat cards, and recent activity below use local
/// placeholder data — TODO(Phase 7): replace with the mock data layer
/// (`mock/mock_*.dart`) once it exists, then swap for real repository
/// data once the SRS defines what this dashboard actually tracks.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _quickActions = [
    (icon: Icons.add_circle_outline, label: 'New'),
    (icon: Icons.search, label: 'Browse'),
    (icon: Icons.favorite_border, label: 'Saved'),
    (icon: Icons.help_outline, label: 'Help'),
  ];

  static const _stats = [
    (label: 'Active', value: '—'),
    (label: 'Pending', value: '—'),
    (label: 'Completed', value: '—'),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;
    final nameParts = user?.fullName.trim().split(' ') ?? const <String>[];
    final firstName = (nameParts.isNotEmpty && nameParts.first.isNotEmpty)
        ? nameParts.first
        : 'there';

    return Scaffold(
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (index) => _onTabTapped(context, index),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spaceMd),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $firstName 👋',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Here's what's happening today.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => context.go(RouteNames.profile),
                  child: AppNetworkImage.avatar(
                    imageUrl: user?.photoUrl,
                    radius: 24,
                    fallbackText: user?.fullName,
                  ),
                ),
                const SizedBox(width: AppConstants.spaceSm),
                IconButton(
                  onPressed: () => context.push(RouteNames.notifications),
                  icon: const Icon(Icons.notifications_outlined),
                  tooltip: 'Notifications',
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spaceLg),
            const AppTextField.search(hint: 'Search'),
            const SizedBox(height: AppConstants.spaceLg),
            Text('Quick actions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppConstants.spaceSm),
            SizedBox(
              height: 88,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _quickActions.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppConstants.spaceSm),
                itemBuilder: (context, index) {
                  final action = _quickActions[index];
                  return SizedBox(
                    width: 84,
                    child: AppCard(
                      padding: const EdgeInsets.all(AppConstants.spaceSm),
                      onTap: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(action.icon, color: AppColors.primary),
                          const SizedBox(height: 6),
                          Text(
                            action.label,
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppConstants.spaceLg),
            Text('Overview', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppConstants.spaceSm),
            Row(
              children: [
                for (final stat in _stats) ...[
                  Expanded(
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stat.value,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(stat.label, style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ),
                  if (stat != _stats.last) const SizedBox(width: AppConstants.spaceSm),
                ],
              ],
            ),
            const SizedBox(height: AppConstants.spaceLg),
            Text('Recent activity', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppConstants.spaceSm),
            const AppEmptyState(
              icon: Icons.history,
              title: 'Nothing yet',
              message: 'Recent activity will show up here once there is some.',
            ),
          ],
        ),
      ),
    );
  }

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        return;
      case 1:
        showComingSoon(context, 'Explore');
        return;
      case 2:
        context.go(RouteNames.events);
        return;
      case 3:
        showComingSoon(context, 'Shop');
        return;
      case 4:
        context.go(RouteNames.profile);
        return;
    }
  }
}
