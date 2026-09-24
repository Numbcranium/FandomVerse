import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

/// A small, generic settings screen.
///
/// Reached from Profile's "Settings" entry (the team's 5-tab bottom nav —
/// Home/Explore/Events/Shop/Profile — has no room for a Settings tab), so
/// this is a plain pushed sub-page with a back button.
///
/// Notification/dark-mode toggles below are local UI state only (not
/// persisted) — wiring them to `shared_preferences` and an actual theme
/// controller is straightforward to add once the competition's SRS says
/// whether settings need to persist or sync anywhere.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: 'Log out',
      message: 'Are you sure you want to log out?',
      confirmText: 'Log out',
      isDestructive: true,
    );
    if (confirmed && context.mounted) {
      context.read<AuthBloc>().add(const AuthLogoutRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spaceMd),
          children: [
            AppCard(
              padding: EdgeInsets.zero,
              child: SwitchListTile(
                title: const Text('Push notifications'),
                subtitle: const Text('Get notified about updates'),
                value: _notificationsEnabled,
                onChanged: (value) => setState(() => _notificationsEnabled = value),
              ),
            ),
            const SizedBox(height: AppConstants.spaceSm),
            AppCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                subtitle: Text('${AppConstants.appName} • v0.1.0'),
              ),
            ),
            const SizedBox(height: AppConstants.spaceSm),
            AppCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & support'),
                onTap: () {},
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: AppConstants.spaceLg),
            AppCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
                title: Text(
                  'Log out',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onTap: () => _confirmLogout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
