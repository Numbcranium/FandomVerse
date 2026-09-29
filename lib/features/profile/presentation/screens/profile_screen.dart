import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/coming_soon.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../models/user_model.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../home/presentation/screens/merchandise/order_history_screen.dart';
import '../../../tickets/presentation/screens/my_tickets_screen.dart';
import 'wallet_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.home);
        return;
      case 1:
        context.go(RouteNames.trivia);
        return;
      case 2:
        context.go(RouteNames.events);
        return;
      case 3:
        context.push('/merchandise');
        return;
      case 4:
        return; // Already on profile
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: 'Log out',
      message: 'Are you sure you want to log out?',
      confirmText: 'Log out',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      context.read<AuthBloc>().add(
        const AuthLogoutRequested(),
      );
    }
  }

  StatusBadgeType _badgeTypeFor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return StatusBadgeType.error;

      case UserRole.provider:
        return StatusBadgeType.info;

      case UserRole.user:
        return StatusBadgeType.neutral;
    }
  }

  void _openOrderHistory(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const OrderHistoryScreen(),
      ),
    );
  }

  void _openWallet(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const WalletScreen(),
      ),
    );
  }

  void _openTickets(BuildContext context){
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
          builder: (_) => const MyTicketsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      // for the notificatiom button
        actions: [
          IconButton(
            onPressed: () => context.push(RouteNames.notifications),
            icon: Icon(Icons.notifications_outlined),
            tooltip: 'Notifications',
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 4,
        onTap: (index) => _onTabTapped(
          context,
          index,
        ),
      ),
      body: user == null
          ? const SizedBox.shrink()
          : SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(
            AppConstants.spaceMd,
          ),
          children: [
            // =========================================================
            // PROFILE PHOTO
            // =========================================================

            Center(
              child: AppNetworkImage.avatar(
                imageUrl: user.photoUrl,
                radius: 44,
                fallbackText: user.fullName,
              ),
            ),

            SizedBox(
              height: AppConstants.spaceMd,
            ),

            // =========================================================
            // NAME
            // =========================================================

            Center(
              child: Text(
                user.fullName,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge,
              ),
            ),

            SizedBox(height: 4),

            // =========================================================
            // ROLE
            // =========================================================

            Center(
              child: StatusBadge(
                label: user.role.asString,
                type: _badgeTypeFor(
                  user.role,
                ),
              ),
            ),

            SizedBox(
              height: AppConstants.spaceLg,
            ),

            // =========================================================
            // USER INFORMATION
            // =========================================================

            AppCard(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: user.email,
                  ),
                  const Divider(
                    height: AppConstants.spaceLg,
                  ),
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: user.phone,
                  ),
                ],
              ),
            ),

            SizedBox(
              height: AppConstants.spaceLg,
            ),

            // =========================================================
            // EDIT PROFILE
            // =========================================================

            AppCard(
              onTap: () => context.push(
                RouteNames.editProfile,
              ),
              child: const _ActionRow(
                icon: Icons.edit_outlined,
                label: 'Edit profile',
              ),
            ),

            SizedBox(
              height: AppConstants.spaceSm,
            ),

            // =========================================================
            // BOOKMARKS
            // =========================================================

            AppCard(
              onTap: () => context.push(
                RouteNames.bookmarks,
              ),
              child: const _ActionRow(
                icon: Icons.bookmark_border,
                label: 'Bookmarks',
              ),
            ),

            SizedBox(
              height: AppConstants.spaceSm,
            ),

            // =========================================================
            // PURCHASE HISTORY
            // =========================================================

            AppCard(
              onTap: () => _openOrderHistory(context),
              child: const _ActionRow(
                icon: Icons.receipt_long_outlined,
                label: 'Purchase history',
              ),
            ),

            SizedBox(
              height: AppConstants.spaceSm,
            ),

            // =========================================================
            // WALLET
            // =========================================================

            AppCard(
              onTap: () => _openWallet(context),
              child: const _ActionRow(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Wallet',
              ),
            ),

            SizedBox(
              height: AppConstants.spaceSm,
            ),

            //My tickets
            AppCard(
              onTap: () => _openTickets(context),
              child: const _ActionRow(
                  icon: Icons.confirmation_num_outlined,
                  label: 'My tickets'),

            ),

            SizedBox(
              height: AppConstants.spaceSm,
            ),

            // =========================================================
            // SETTINGS
            // =========================================================

            AppCard(
              onTap: () => context.push(
                RouteNames.settings,
              ),
              child: const _ActionRow(
                icon: Icons.settings_outlined,
                label: 'Settings',
              ),
            ),

            SizedBox(
              height: AppConstants.spaceLg,
            ),

            // =========================================================
            // LOG OUT
            // =========================================================

            AppCard(
              onTap: () => _confirmLogout(context),
              child: const _ActionRow(
                icon: Icons.logout,
                label: 'Log out',
                isDestructive: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        SizedBox(
          width: AppConstants.spaceSm,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall,
              ),
              Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.onSurface;

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        SizedBox(
          width: AppConstants.spaceSm,
        ),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(
            color: color,
          ),
        ),
        const Spacer(),
        Icon(
          Icons.chevron_right,
          color: Theme.of(context).disabledColor,
        ),
      ],
    );
  }
}