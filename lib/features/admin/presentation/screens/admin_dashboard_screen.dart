import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/theme_cubit.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';

final _db = FirebaseFirestore.instance;

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      _DashboardTab(onTabSelected: (i) => setState(() => _currentIndex = i)),
      const _UserManagementTab(),
      const _ContentManagementTab(),
      const _EventManagementTab(),
      const _CategoryManagementTab(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: tabs[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: Theme.of(context).cardColor,
        selectedItemColor: const Color(0xFF6C4DFF),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Content'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
        ],
      ),
    );
  }
}

// ============================================================
// 1. DASHBOARD
// ============================================================
class _DashboardTab extends StatelessWidget {
  final void Function(int) onTabSelected;
  const _DashboardTab({required this.onTabSelected});

  Future<int> _count(String col) async {
    final s = await _db.collection(col).count().get();
    return s.count ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subheadColor = isDark ? Colors.white70 : Colors.black54;

    return FutureBuilder(
      future: Future.wait([_count('users'), _count('events'), _count('products'), _count('posts')]),
      builder: (ctx, snap) {
        final c = snap.data ?? [0, 0, 0, 0];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _appBar('Admin Dashboard'),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text('Welcome, Admin!', style: TextStyle(color: subheadColor, fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                Expanded(child: _statCard('Total Users', '${c[0]}')),
                const SizedBox(width: 12),
                Expanded(child: _statCard('Total Events', '${c[1]}')),
              ]),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                Expanded(child: _statCard('Total Products', '${c[2]}')),
                const SizedBox(width: 12),
                Expanded(child: _statCard('Total Posts', '${c[3]}')),
              ]),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _navTile(context, Icons.people, 'Users', () => onTabSelected(1)),
                  _navTile(context, Icons.event, 'Events', () => onTabSelected(3)),
                  _navTile(context, Icons.folder, 'Content', () => onTabSelected(2)),
                  _navTile(context, Icons.category, 'Categories', () => onTabSelected(4)),
                  _navTile(context, Icons.bar_chart, 'Reports', () => _showReports(context)),
                  _navTile(context, Icons.settings, 'Settings', () => _showSettings(context)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showReports(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => FutureBuilder(
        future: Future.wait([
          _count('users'), _count('events'), _count('fandoms'),
          _count('categories'), _count('posts'),
        ]),
        builder: (ctx, snap) {
          final c = snap.data ?? [0, 0, 0, 0, 0];
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final textColor = isDark ? Colors.white : Colors.black87;
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reports & Analytics', style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _reportRow(context, 'Total Users', '${c[0]}', Icons.people),
                    _reportRow(context, 'Total Events', '${c[1]}', Icons.event),
                    _reportRow(context, 'Total Fandoms', '${c[2]}', Icons.star),
                    _reportRow(context, 'Total Categories', '${c[3]}', Icons.category),
                    _reportRow(context, 'Total Posts', '${c[4]}', Icons.article),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSettings(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Admin Settings', style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                _settingsTile(
                  context,
                  Icons.notifications_outlined,
                  'Push Notifications',
                  'Configure broadcast & alert settings',
                  onTap: () {
                    Navigator.pop(context);
                    _showPushNotificationsDialog(context);
                  },
                ),
                _settingsTile(
                  context,
                  Icons.security,
                  'Security',
                  'Password & session security',
                  onTap: () {
                    Navigator.pop(context);
                    _showSecurityDialog(context);
                  },
                ),
                _settingsTile(
                  context,
                  Icons.palette_outlined,
                  'Appearance',
                  'Theme & display settings',
                  onTap: () {
                    Navigator.pop(context);
                    _showAppearanceDialog(context);
                  },
                ),
                _settingsTile(
                  context,
                  Icons.info_outline,
                  'About',
                  'App version & status diagnostics',
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog(context);
                  },
                ),
                Divider(color: Theme.of(context).dividerColor, height: 32),
                _settingsTile(
                  context,
                  Icons.logout,
                  'Log Out',
                  'End current admin session',
                  color: Colors.redAccent,
                  onTap: () {
                    Navigator.pop(context); // Close sheet
                    context.read<AuthBloc>().add(const AuthLogoutRequested());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPushNotificationsDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    bool adminAlerts = true;
    bool signupAlerts = true;
    bool reportAlerts = false;
    bool isSending = false;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setS) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          final textColor = Theme.of(ctx).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
          final cardBg = Theme.of(ctx).cardColor;

          return AlertDialog(
            backgroundColor: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                const Icon(Icons.notifications_active, color: Color(0xFF6C4DFF)),
                const SizedBox(width: 10),
                Text('Push Notifications', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Admin Alerts', style: TextStyle(color: textColor, fontSize: 14)),
                    subtitle: Text('Receive system error notifications', style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12)),
                    value: adminAlerts,
                    onChanged: (v) => setS(() => adminAlerts = v),
                    activeColor: const Color(0xFF6C4DFF),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('New Signup Alerts', style: TextStyle(color: textColor, fontSize: 14)),
                    subtitle: Text('Notify on new user registration', style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12)),
                    value: signupAlerts,
                    onChanged: (v) => setS(() => signupAlerts = v),
                    activeColor: const Color(0xFF6C4DFF),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Content Report Alerts', style: TextStyle(color: textColor, fontSize: 14)),
                    subtitle: Text('Notify on flagged posts or comments', style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12)),
                    value: reportAlerts,
                    onChanged: (v) => setS(() => reportAlerts = v),
                    activeColor: const Color(0xFF6C4DFF),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Theme.of(ctx).dividerColor),
                  const SizedBox(height: 8),
                  Text('Broadcast System Alert', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('Send a push notification to all users', style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleCtrl,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Alert Title',
                      labelStyle: TextStyle(color: textColor.withOpacity(0.6)),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF1A1D2D) : Colors.grey.shade100,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: bodyCtrl,
                    style: TextStyle(color: textColor),
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Alert Message',
                      labelStyle: TextStyle(color: textColor.withOpacity(0.6)),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF1A1D2D) : Colors.grey.shade100,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: Text('Close', style: TextStyle(color: textColor.withOpacity(0.6))),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4DFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: isSending
                    ? null
                    : () async {
                        final title = titleCtrl.text.trim();
                        final body = bodyCtrl.text.trim();
                        if (title.isEmpty || body.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill title and message')),
                          );
                          return;
                        }
                        setS(() => isSending = true);
                        try {
                          final userSnap = await _db.collection('users').get();
                          final batch = _db.batch();
                          for (final doc in userSnap.docs) {
                            final notifRef = _db.collection('notifications').doc();
                            batch.set(notifRef, {
                              'userId': doc.id,
                              'title': title,
                              'body': body,
                              'isRead': false,
                              'createdAt': FieldValue.serverTimestamp(),
                            });
                          }
                          await batch.commit();
                          if (context.mounted) {
                            Navigator.pop(dialogCtx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Broadcast sent to ${userSnap.docs.length} users!'),
                                backgroundColor: const Color(0xFF6C4DFF),
                              ),
                            );
                          }
                        } catch (e) {
                          setS(() => isSending = false);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to send broadcast: $e')),
                            );
                          }
                        }
                      },
                icon: isSending
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.send, size: 16, color: Colors.white),
                label: Text(isSending ? 'Sending...' : 'Broadcast Alert', style: const TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSecurityDialog(BuildContext context) {
    final passCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    final user = FirebaseAuth.instance.currentUser;
    bool require2FA = true;
    bool sessionAutoLock = true;
    bool isObscured = true;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setS) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          final textColor = Theme.of(ctx).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
          final cardBg = Theme.of(ctx).cardColor;

          return AlertDialog(
            backgroundColor: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                const Icon(Icons.security, color: Color(0xFF6C4DFF)),
                const SizedBox(width: 10),
                Text('Admin Security', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (isDark ? const Color(0xFF1A1D2D) : Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.admin_panel_settings_outlined, color: Color(0xFF6C4DFF)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Admin Account', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13)),
                              Text(user?.email ?? 'admin@fandomverse.com', style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Security Controls', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Require 2FA for Admin Actions', style: TextStyle(color: textColor, fontSize: 13)),
                    value: require2FA,
                    onChanged: (v) => setS(() => require2FA = v),
                    activeColor: const Color(0xFF6C4DFF),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Session Auto-Lock (15m)', style: TextStyle(color: textColor, fontSize: 13)),
                    value: sessionAutoLock,
                    onChanged: (v) => setS(() => sessionAutoLock = v),
                    activeColor: const Color(0xFF6C4DFF),
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Theme.of(ctx).dividerColor),
                  const SizedBox(height: 8),
                  Text('Update Password', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passCtrl,
                    obscureText: isObscured,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      labelStyle: TextStyle(color: textColor.withOpacity(0.6)),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF1A1D2D) : Colors.grey.shade100,
                      suffixIcon: IconButton(
                        icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility, color: textColor.withOpacity(0.5)),
                        onPressed: () => setS(() => isObscured = !isObscured),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmCtrl,
                    obscureText: isObscured,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      labelStyle: TextStyle(color: textColor.withOpacity(0.6)),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF1A1D2D) : Colors.grey.shade100,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: Text('Cancel', style: TextStyle(color: textColor.withOpacity(0.6))),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4DFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  final newPass = passCtrl.text;
                  final confirmPass = confirmCtrl.text;
                  if (newPass.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password must be at least 6 characters')),
                    );
                    return;
                  }
                  if (newPass != confirmPass) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match')),
                    );
                    return;
                  }
                  context.read<AuthBloc>().add(AuthPasswordUpdateSubmitted(newPass));
                  Navigator.pop(dialogCtx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Admin password update requested successfully!'),
                      backgroundColor: Color(0xFF6C4DFF),
                    ),
                  );
                },
                child: const Text('Update Password', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAppearanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (ctx, themeMode) {
          final isDark = themeMode == ThemeMode.dark ||
              (themeMode == ThemeMode.system &&
                  MediaQuery.of(ctx).platformBrightness == Brightness.dark);
          final textColor = isDark ? Colors.white : Colors.black87;
          final cardBg = Theme.of(ctx).cardColor;

          return AlertDialog(
            backgroundColor: cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                const Icon(Icons.palette_outlined, color: Color(0xFF6C4DFF)),
                const SizedBox(width: 10),
                Text('Appearance', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1D2D) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: const Color(0xFF6C4DFF)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isDark ? 'Dark Theme Active' : 'Light Theme Active',
                              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              isDark ? 'Sleek dark interface enabled' : 'Clean light interface enabled',
                              style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: isDark,
                        onChanged: (val) {
                          context.read<ThemeCubit>().toggleTheme(val);
                        },
                        activeColor: const Color(0xFF6C4DFF),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: !isDark ? const Color(0xFF6C4DFF).withOpacity(0.1) : Colors.transparent,
                          side: BorderSide(color: !isDark ? const Color(0xFF6C4DFF) : Colors.grey.shade400),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => context.read<ThemeCubit>().toggleTheme(false),
                        icon: const Icon(Icons.light_mode, size: 18),
                        label: const Text('Light'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF6C4DFF).withOpacity(0.1) : Colors.transparent,
                          side: BorderSide(color: isDark ? const Color(0xFF6C4DFF) : Colors.grey.shade400),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => context.read<ThemeCubit>().toggleTheme(true),
                        icon: const Icon(Icons.dark_mode, size: 18),
                        label: const Text('Dark'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: Text('Done', style: TextStyle(color: textColor.withOpacity(0.7))),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        final isDark = Theme.of(dialogCtx).brightness == Brightness.dark;
        final textColor = Theme.of(dialogCtx).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
        final cardBg = Theme.of(dialogCtx).cardColor;

        return AlertDialog(
          backgroundColor: cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.info_outline, color: Color(0xFF6C4DFF)),
              const SizedBox(width: 10),
              Text('About FandomVerse', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C4DFF).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.admin_panel_settings, color: Color(0xFF6C4DFF), size: 36),
                    ),
                    const SizedBox(height: 8),
                    Text('FandomVerse Admin Console', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Version 1.0.4 (Build 2026.09)', style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: Theme.of(dialogCtx).dividerColor),
              const SizedBox(height: 8),
              _diagRow(dialogCtx, 'Firestore DB', 'Connected', Colors.green, textColor),
              _diagRow(dialogCtx, 'Auth Provider', 'Firebase Auth', Colors.green, textColor),
              _diagRow(dialogCtx, 'Theme Engine', 'ThemeCubit Live', const Color(0xFF6C4DFF), textColor),
              _diagRow(dialogCtx, 'Platform', kIsWeb ? 'Web Engine' : 'Android / iOS', Colors.blue, textColor),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  '© 2026 FandomVerse. All Rights Reserved.',
                  style: TextStyle(color: textColor.withOpacity(0.4), fontSize: 11),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text('Close', style: TextStyle(color: textColor.withOpacity(0.7))),
            ),
          ],
        );
      },
    );
  }

  Widget _diagRow(BuildContext context, String label, String value, Color statusColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 13)),
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(value, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reportRow(BuildContext context, String label, String value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Icon(icon, color: const Color(0xFF6C4DFF), size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(color: textColor.withOpacity(0.7)))),
        Text(value.toString(), style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18)),
      ]),
    );
  }

  Widget _settingsTile(BuildContext context, IconData icon, String title, String subtitle, {VoidCallback? onTap, Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = color ?? (Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87));
    final subColor = color?.withOpacity(0.7) ?? textColor.withOpacity(0.6);
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color ?? const Color(0xFF6C4DFF)),
      title: Text(title.toString(), style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(color: subColor, fontSize: 12)),
      trailing: Icon(Icons.chevron_right, color: subColor.withOpacity(0.5)),
    );
  }

  Widget _statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title.toString(), style: const TextStyle(color: Colors.black54, fontSize: 13)),
        const SizedBox(height: 6),
        Text(value.toString(), style: const TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _navTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFF6C4DFF)),
        title: Text(title.toString(), style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.chevron_right, color: textColor.withOpacity(0.4)),
      ),
    );
  }
}


// ============================================================
// 2. USER MANAGEMENT
// ============================================================
class _UserManagementTab extends StatefulWidget {
  const _UserManagementTab();
  @override
  State<_UserManagementTab> createState() => _UserManagementTabState();
}

class _UserManagementTabState extends State<_UserManagementTab> {
  bool _addMode = false;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _selectedRole = 'user';
  String _search = '';

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _addUser() async {
    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty) return;
    await _db.collection('users').add({
      'fullName': _nameCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'role': _selectedRole,
      'selectedFandoms': [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    _nameCtrl.clear(); _emailCtrl.clear(); _phoneCtrl.clear();
    setState(() { _addMode = false; _selectedRole = 'user'; });
    _showSnack('User added!');
  }

  Future<void> _deleteUser(String id, String name) async {
    final ok = await _confirm('Delete "$name"?');
    if (!ok) return;
    await _db.collection('users').doc(id).delete();
    _showSnack('User deleted');
  }

  Future<void> _editRole(String id, String currentRole) async {
    String role = currentRole;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D2D),
        title: const Text('Change Role', style: TextStyle(color: Colors.white)),
        content: StatefulBuilder(
          builder: (ctx, setS) => Column(
            mainAxisSize: MainAxisSize.min,
            children: ['user', 'admin', 'provider'].map((r) => RadioListTile<String>(
              value: r,
              groupValue: role,
              onChanged: (v) => setS(() => role = v!),
              title: Text(r, style: const TextStyle(color: Colors.white)),
              activeColor: const Color(0xFF6C4DFF),
            )).toList(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C4DFF)),
            onPressed: () async {
              await _db.collection('users').doc(id).update({'role': role});
              if (mounted) Navigator.pop(context);
              _showSnack('Role updated to $role');
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: const Color(0xFF6C4DFF)));
  }

  Future<bool> _confirm(String msg) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D2D),
        title: Text(msg, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _appBar('User Management'),
      _segmentedControl(['All Users', 'Add User'], _addMode ? 1 : 0, (i) => setState(() => _addMode = i == 1)),
      const SizedBox(height: 12),
      if (!_addMode) ...[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: _inputDeco('Search users...', Icons.search),
            onChanged: (v) => setState(() => _search = v.toLowerCase()),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _db.collection('users').snapshots(),
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              final docs = snap.data?.docs ?? [];
              final filtered = _search.isEmpty ? docs : docs.where((d) {
                final data = d.data() as Map<String, dynamic>;
                return (data['fullName'] ?? '').toString().toLowerCase().contains(_search)
                    || (data['email'] ?? '').toString().toLowerCase().contains(_search);
              }).toList();
              if (filtered.isEmpty) return const Center(child: Text('No users found', style: TextStyle(color: Colors.white54)));
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filtered.length,
                itemBuilder: (ctx, i) {
                  final d = filtered[i].data() as Map<String, dynamic>;
                  final id = filtered[i].id;
                  final name = d['fullName'] ?? d['email'] ?? 'Unknown';
                  final role = d['role'] ?? 'user';
                  final colors = [Colors.pink, Colors.orange, Colors.blue, Colors.purple, Colors.teal];
                  final color = colors[i % colors.length];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFF1A1D2D), borderRadius: BorderRadius.circular(16)),
                    child: Row(children: [
                      CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(Icons.person, color: color)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(name.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text((d['email'] ?? '').toString(), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      ])),
                      GestureDetector(
                        onTap: () => _editRole(id, role.toString()),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFF6C4DFF).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                          child: Text(role.toString(), style: const TextStyle(color: Color(0xFF6C4DFF), fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(onTap: () => _deleteUser(id, name.toString()), child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20)),
                    ]),
                  );
                },
              );
            },
          ),
        ),
      ],
      if (_addMode)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              _textField(_nameCtrl, 'Full Name', Icons.person),
              const SizedBox(height: 12),
              _textField(_emailCtrl, 'Email', Icons.email),
              const SizedBox(height: 12),
              _textField(_phoneCtrl, 'Phone', Icons.phone),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: const Color(0xFF1A1D2D), borderRadius: BorderRadius.circular(12)),
                child: DropdownButton<String>(
                  value: _selectedRole,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF1A1D2D),
                  underline: const SizedBox(),
                  style: const TextStyle(color: Colors.white),
                  items: ['user', 'admin', 'provider'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  onChanged: (v) => setState(() => _selectedRole = v!),
                ),
              ),
              const SizedBox(height: 20),
              _primaryBtn('Add User', _addUser),
            ]),
          ),
        ),
    ]);
  }
}

// ============================================================
// 3. CONTENT MANAGEMENT
// ============================================================
class _ContentManagementTab extends StatefulWidget {
  const _ContentManagementTab();
  @override
  State<_ContentManagementTab> createState() => _ContentManagementTabState();
}

class _ContentManagementTabState extends State<_ContentManagementTab> {
  String _activeSection = 'fandoms';
  bool _addMode = false;
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  static const _sections = [
    {'key': 'fandoms', 'label': 'Fandoms', 'icon': Icons.star_border},
    {'key': 'news', 'label': 'News', 'icon': Icons.article_outlined},
    {'key': 'gallery', 'label': 'Gallery', 'icon': Icons.image_outlined},
    {'key': 'videos', 'label': 'Videos', 'icon': Icons.play_circle_outline},
    {'key': 'podcasts', 'label': 'Podcasts', 'icon': Icons.mic_none},
  ];

  @override
  void dispose() { _titleCtrl.dispose(); _descCtrl.dispose(); super.dispose(); }

  String get _titleField => _activeSection == 'fandoms' ? 'name' : 'title';

  Future<void> _add() async {
    if (_titleCtrl.text.isEmpty) return;
    await _db.collection(_activeSection).add({
      _titleField: _titleCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    _titleCtrl.clear(); _descCtrl.clear();
    setState(() => _addMode = false);
    _showSnack('Added to $_activeSection!');
  }

  Future<void> _delete(String id) async {
    await _db.collection(_activeSection).doc(id).delete();
    _showSnack('Deleted');
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: const Color(0xFF6C4DFF)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _appBar('Content Management'),
      // Section selector
      SizedBox(
        height: 44,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: _sections.map((s) {
            final active = _activeSection == s['key'];
            return GestureDetector(
              onTap: () => setState(() { _activeSection = s['key'] as String; _addMode = false; }),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? const Color(0xFF6C4DFF) : const Color(0xFF1A1D2D),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(children: [
                  Icon(s['icon'] as IconData, size: 16, color: active ? Colors.white : Colors.white54),
                  const SizedBox(width: 6),
                  Text(s['label'] as String, style: TextStyle(color: active ? Colors.white : Colors.white54, fontSize: 13)),
                ]),
              ),
            );
          }).toList(),
        ),
      ),
      const SizedBox(height: 12),
      _topBtn('Add to ${_sections.firstWhere((s) => s['key'] == _activeSection)['label']}', () => setState(() => _addMode = !_addMode)),
      if (_addMode) Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(children: [
          _textField(_titleCtrl, _activeSection == 'fandoms' ? 'Fandom Name' : 'Title', Icons.title),
          const SizedBox(height: 8),
          _textField(_descCtrl, 'Description (optional)', Icons.description),
          const SizedBox(height: 8),
          _primaryBtn('Save', _add),
        ]),
      ),
      const SizedBox(height: 8),
      Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: _db.collection(_activeSection).orderBy('createdAt', descending: true).snapshots(),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            final docs = snap.data?.docs ?? [];
            if (docs.isEmpty) return Center(child: Text('No $_activeSection yet. Add one!', style: const TextStyle(color: Colors.white54)));
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: docs.length,
              itemBuilder: (ctx, i) {
                final d = docs[i].data() as Map<String, dynamic>;
                final title = d[_titleField] ?? d['name'] ?? d['title'] ?? 'Untitled';
                return _dismissibleTile(docs[i].id, _sections.firstWhere((s) => s['key'] == _activeSection)['icon'] as IconData, title, _delete);
              },
            );
          },
        ),
      ),
    ]);
  }
}

// ============================================================
// 4. EVENT MANAGEMENT
// ============================================================
class _EventManagementTab extends StatefulWidget {
  const _EventManagementTab();
  @override
  State<_EventManagementTab> createState() => _EventManagementTabState();
}

class _EventManagementTabState extends State<_EventManagementTab> {
  bool _showUpcoming = true;
  bool _addMode = false;
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  DateTime? _date;

  @override
  void dispose() { _titleCtrl.dispose(); _descCtrl.dispose(); _locationCtrl.dispose(); super.dispose(); }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _addEvent() async {
    if (_titleCtrl.text.isEmpty) return;
    final isUpcoming = _date == null || _date!.isAfter(DateTime.now());
    await _db.collection('events').add({
      'title': _titleCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'location': _locationCtrl.text.trim(),
      'date': _date != null ? Timestamp.fromDate(_date!) : null,
      'isUpcoming': isUpcoming,
      'createdAt': FieldValue.serverTimestamp(),
    });
    _titleCtrl.clear(); _descCtrl.clear(); _locationCtrl.clear();
    setState(() { _addMode = false; _date = null; });
    _showSnack('Event added!');
  }

  Future<void> _delete(String id) async {
    await _db.collection('events').doc(id).delete();
    _showSnack('Event deleted');
  }

  Future<void> _viewAnalytics() async {
    final upcoming = await _db.collection('events').where('isUpcoming', isEqualTo: true).count().get();
    final past = await _db.collection('events').where('isUpcoming', isEqualTo: false).count().get();
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1D2D),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Event Analytics', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _analyticsRow('Upcoming Events', '${upcoming.count ?? 0}', Colors.green),
              _analyticsRow('Past Events', '${past.count ?? 0}', Colors.orange),
              _analyticsRow('Total Events', '${(upcoming.count ?? 0) + (past.count ?? 0)}', const Color(0xFF6C4DFF)),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _analyticsRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(color: Colors.white70))),
        Text(value.toString(), style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20)),
      ]),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: const Color(0xFF6C4DFF)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _appBar('Event Management'),
      Row(children: [
        Expanded(child: Padding(padding: const EdgeInsets.only(left: 16, right: 8), child: _topBtn('Add Event', () => setState(() => _addMode = !_addMode)))),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A1D2D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: _viewAnalytics,
            child: const Row(children: [Icon(Icons.analytics, color: Color(0xFF6C4DFF), size: 18), SizedBox(width: 4), Text('Analytics', style: TextStyle(color: Colors.white70))]),
          ),
        ),
      ]),
      if (_addMode) Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(children: [
          _textField(_titleCtrl, 'Event Title', Icons.event),
          const SizedBox(height: 8),
          _textField(_descCtrl, 'Description', Icons.description),
          const SizedBox(height: 8),
          _textField(_locationCtrl, 'Location', Icons.location_on_outlined),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF1A1D2D), borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                const Icon(Icons.calendar_today, color: Colors.white54, size: 18),
                const SizedBox(width: 8),
                Text(
                  _date == null ? 'Pick a date' : '${_date!.day}/${_date!.month}/${_date!.year}',
                  style: TextStyle(color: _date == null ? Colors.white54 : Colors.white),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 8),
          _primaryBtn('Save Event', _addEvent),
        ]),
      ),
      const SizedBox(height: 8),
      _segmentedControl(['Upcoming', 'Past'], _showUpcoming ? 0 : 1, (i) => setState(() => _showUpcoming = i == 0)),
      const SizedBox(height: 8),
      Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: _db.collection('events').snapshots(),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            final docs = (snap.data?.docs ?? []).where((doc) {
              final d = doc.data() as Map<String, dynamic>;
              return (d['isUpcoming'] ?? true) == _showUpcoming;
            }).toList();
            if (docs.isEmpty) return Center(child: Text('No ${_showUpcoming ? 'upcoming' : 'past'} events', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)));
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: docs.length,
              itemBuilder: (ctx, i) {
                final d = docs[i].data() as Map<String, dynamic>;
                final date = (d['date'] as Timestamp?)?.toDate();
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xFF1A1D2D), borderRadius: BorderRadius.circular(16)),
                  child: Row(children: [
                    Icon(_showUpcoming ? Icons.event_available : Icons.history, color: _showUpcoming ? Colors.green : Colors.orange),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(d['title'] ?? 'Untitled', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      if ((d['location'] ?? '').toString().isNotEmpty)
                        Text(d['location'], style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      if (date != null)
                        Text('${date.day}/${date.month}/${date.year}', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    ])),
                    GestureDetector(onTap: () => _delete(docs[i].id), child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20)),
                  ]),
                );
              },
            );
          },
        ),
      ),
    ]);
  }
}

// ============================================================
// 5. CATEGORY MANAGEMENT
// ============================================================
class _CategoryManagementTab extends StatefulWidget {
  const _CategoryManagementTab();
  @override
  State<_CategoryManagementTab> createState() => _CategoryManagementTabState();
}

class _CategoryManagementTabState extends State<_CategoryManagementTab> {
  bool _addMode = false;
  final _nameCtrl = TextEditingController();
  String _selectedIcon = 'category';
  final _editCtrl = TextEditingController();
  String? _editingId;

  static const _iconOptions = [
    {'key': 'animation', 'label': 'Anime'},
    {'key': 'sports_esports', 'label': 'Gaming'},
    {'key': 'movie', 'label': 'Movies & TV'},
    {'key': 'menu_book', 'label': 'Comics'},
    {'key': 'music_note', 'label': 'Music'},
    {'key': 'sports_soccer', 'label': 'Sports'},
    {'key': 'computer', 'label': 'Tech'},
    {'key': 'category', 'label': 'Other'},
  ];

  IconData _iconFromKey(String key) {
    switch (key) {
      case 'animation': return Icons.animation;
      case 'sports_esports': return Icons.sports_esports;
      case 'movie': return Icons.movie;
      case 'menu_book': return Icons.menu_book;
      case 'music_note': return Icons.music_note;
      case 'sports_soccer': return Icons.sports_soccer;
      case 'computer': return Icons.computer;
      default: return Icons.category;
    }
  }

  @override
  void dispose() { _nameCtrl.dispose(); _editCtrl.dispose(); super.dispose(); }

  Future<void> _addCategory() async {
    if (_nameCtrl.text.isEmpty) return;
    await _db.collection('categories').add({
      'name': _nameCtrl.text.trim(),
      'icon': _selectedIcon,
      'createdAt': FieldValue.serverTimestamp(),
    });
    _nameCtrl.clear();
    setState(() { _addMode = false; _selectedIcon = 'category'; });
    _showSnack('Category added!');
  }

  Future<void> _delete(String id, String name) async {
    await _db.collection('categories').doc(id).delete();
    _showSnack('Category "$name" deleted');
  }

  Future<void> _editCategory(String id, String currentName) async {
    _editCtrl.text = currentName;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D2D),
        title: const Text('Edit Category', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _editCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDeco('Category name', Icons.category),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C4DFF)),
            onPressed: () async {
              if (_editCtrl.text.isNotEmpty) {
                await _db.collection('categories').doc(id).update({'name': _editCtrl.text.trim()});
              }
              if (mounted) Navigator.pop(context);
              _showSnack('Category updated');
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: const Color(0xFF6C4DFF)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _appBar('Category Management'),
      _topBtn('Add Category', () => setState(() => _addMode = !_addMode)),
      if (_addMode) Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _textField(_nameCtrl, 'Category Name', Icons.category),
          const SizedBox(height: 8),
          const Text('Select Icon:', style: TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: _iconOptions.map((o) {
              final active = _selectedIcon == o['key'];
              return GestureDetector(
                onTap: () => setState(() => _selectedIcon = o['key']!),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFF6C4DFF) : const Color(0xFF1A1D2D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(children: [
                    Icon(_iconFromKey(o['key']!), color: Colors.white, size: 20),
                    Text(o['label']!, style: const TextStyle(color: Colors.white, fontSize: 10)),
                  ]),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          _primaryBtn('Save Category', _addCategory),
        ]),
      ),
      const SizedBox(height: 8),
      Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: _db.collection('categories').orderBy('createdAt', descending: false).snapshots(),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            final docs = snap.data?.docs ?? [];
            if (docs.isEmpty) return const Center(child: Text('No categories yet. Add one!', style: TextStyle(color: Colors.white54)));
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: docs.length,
              itemBuilder: (ctx, i) {
                final d = docs[i].data() as Map<String, dynamic>;
                final name = d['name'] ?? 'Unknown';
                final iconKey = d['icon'] ?? 'category';
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: const Color(0xFF1A1D2D), borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: Icon(_iconFromKey(iconKey), color: Colors.white54),
                    title: Text(name.toString(), style: const TextStyle(color: Colors.white)),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      GestureDetector(onTap: () => _editCategory(docs[i].id, name.toString()), child: const Icon(Icons.edit_outlined, color: Colors.white54, size: 20)),
                      const SizedBox(width: 12),
                      GestureDetector(onTap: () => _delete(docs[i].id, name.toString()), child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20)),
                    ]),
                  ),
                );
              },
            );
          },
        ),
      ),
    ]);
  }
}

// ============================================================
// SHARED HELPERS
// ============================================================
Widget _appBar(String title) => Padding(
  padding: const EdgeInsets.all(16),
  child: Row(children: [
    const Icon(Icons.admin_panel_settings, color: Color(0xFF6C4DFF)),
    const SizedBox(width: 12),
    Text(title.toString(), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
  ]),
);

Widget _topBtn(String title, VoidCallback onTap) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6C4DFF),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      onPressed: onTap,
      child: Text(title.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    ),
  ),
);

Widget _primaryBtn(String label, VoidCallback onTap) => SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6C4DFF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    onPressed: onTap,
    child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  ),
);

Widget _segmentedControl(List<String> labels, int selected, void Function(int) onSelect) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      decoration: BoxDecoration(color: const Color(0xFF1A1D2D), borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: labels.asMap().entries.map((e) {
          final active = e.key == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(e.key),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: active ? const Color(0xFF6C4DFF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: Text(e.value, style: TextStyle(color: active ? Colors.white : Colors.white54, fontWeight: FontWeight.bold)),
              ),
            ),
          );
        }).toList(),
      ),
    ),
  );
}

Widget _textField(TextEditingController ctrl, String hint, IconData icon) => TextField(
  controller: ctrl,
  style: const TextStyle(color: Colors.white),
  decoration: _inputDeco(hint, icon),
);

InputDecoration _inputDeco(String hint, IconData icon) => InputDecoration(
  hintText: hint,
  hintStyle: const TextStyle(color: Colors.white38),
  prefixIcon: Icon(icon, color: Colors.white38),
  filled: true,
  fillColor: const Color(0xFF1A1D2D),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
);

Widget _dismissibleTile(String id, IconData icon, String title, Future<void> Function(String) onDelete) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(color: const Color(0xFF1A1D2D), borderRadius: BorderRadius.circular(16)),
    child: ListTile(
      leading: Icon(icon, color: Colors.white54),
      title: Text(title.toString(), style: const TextStyle(color: Colors.white)),
      trailing: GestureDetector(onTap: () => onDelete(id), child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20)),
    ),
  );
}
