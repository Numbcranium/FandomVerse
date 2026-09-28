import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/theme_cubit.dart';
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

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: 'Delete Account',
      message: 'Are you sure you want to permanently delete your account? This action cannot be undone.',
      confirmText: 'Delete',
      isDestructive: true,
    );
    if (confirmed && context.mounted) {
      context.read<AuthBloc>().add(const AuthAccountDeleted());
    }
  }

  Future<void> _showUpdatePasswordDialog(BuildContext context) async {
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Update Password'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'New Password',
              hintText: 'Enter new password',
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(ctx).pop(true);
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<AuthBloc>().add(
            AuthPasswordUpdateSubmitted(passwordController.text),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updating...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setting and security')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spaceMd),
          children: [
            AppCard(
              padding: EdgeInsets.zero,
              child: SwitchListTile(
                title: Text('Push notifications'),
                subtitle: Text('Get notified about updates'),
                value: _notificationsEnabled,
                onChanged: (value) => setState(() => _notificationsEnabled = value),
              ),
            ),
            SizedBox(height: AppConstants.spaceSm),
            AppCard(
              padding: EdgeInsets.zero,
              child: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return SwitchListTile(
                    title: Text('Dark Mode'),
                    subtitle: Text('Enable dark theme'),
                    value: themeMode == ThemeMode.dark || themeMode == ThemeMode.system,
                    onChanged: (value) {
                      context.read<ThemeCubit>().toggleTheme(value);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: AppConstants.spaceSm),
            AppCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('Change password'),
                onTap: () => _showUpdatePasswordDialog(context),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            SizedBox(height: AppConstants.spaceSm),
            const AppCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('About'),
                subtitle: Text('${AppConstants.appName} • v0.1.0'),
              ),
            ),
            SizedBox(height: AppConstants.spaceSm),
            AppCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: Icon(Icons.help_outline),
                title: Text('Help & support'),
                onTap: () {},
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            SizedBox(height: AppConstants.spaceLg),
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
            SizedBox(height: AppConstants.spaceSm),
            AppCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.error),
                title: Text(
                  'Delete account',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onTap: () => _confirmDeleteAccount(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
