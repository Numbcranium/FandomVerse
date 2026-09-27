import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      backgroundColor: const Color(0xFF0F111A),
      body: SafeArea(child: tabs[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: const Color(0xFF1A1D2D),
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
    return FutureBuilder(
      future: Future.wait([_count('users'), _count('events'), _count('products'), _count('posts')]),
      builder: (ctx, snap) {
        final c = snap.data ?? [0, 0, 0, 0];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _appBar('Admin Dashboard'),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text('Welcome, Admin!', style: TextStyle(color: Colors.white70, fontSize: 16)),
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
                  _navTile(Icons.people, 'Users', () => onTabSelected(1)),
                  _navTile(Icons.event, 'Events', () => onTabSelected(3)),
                  _navTile(Icons.folder, 'Content', () => onTabSelected(2)),
                  _navTile(Icons.category, 'Categories', () => onTabSelected(4)),
                  _navTile(Icons.bar_chart, 'Reports', () => _showReports(context)),
                  _navTile(Icons.settings, 'Settings', () => _showSettings(context)),
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
      backgroundColor: const Color(0xFF1A1D2D),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => FutureBuilder(
        future: Future.wait([
          _count('users'), _count('events'), _count('fandoms'),
          _count('categories'), _count('posts'),
        ]),
        builder: (ctx, snap) {
          final c = snap.data ?? [0, 0, 0, 0, 0];
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Reports & Analytics', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                _reportRow('Total Users', '${c[0]}', Icons.people),
                _reportRow('Total Events', '${c[1]}', Icons.event),
                _reportRow('Total Fandoms', '${c[2]}', Icons.star),
                _reportRow('Total Categories', '${c[3]}', Icons.category),
                _reportRow('Total Posts', '${c[4]}', Icons.article),
              ],
            ),
          )));
        },
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1D2D),
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
            const Text('Admin Settings', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _settingsTile(Icons.notifications_outlined, 'Push Notifications', 'Configure notification settings', onTap: () => _showSnack(context, 'Notification settings coming soon')),
            _settingsTile(Icons.security, 'Security', 'App security settings', onTap: () => _showSnack(context, 'Security settings coming soon')),
            _settingsTile(Icons.palette_outlined, 'Appearance', 'Theme and display settings', onTap: () => _showSnack(context, 'Appearance settings coming soon')),
            _settingsTile(Icons.info_outline, 'About', 'App version and info', onTap: () => _showSnack(context, 'About page coming soon')),
            const Divider(color: Colors.white24, height: 32),
            _settingsTile(
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
    )));
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: const Color(0xFF6C4DFF)));
  }

  Widget _reportRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Icon(icon, color: const Color(0xFF6C4DFF), size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(color: Colors.white70))),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ]),
    );
  }

  Widget _settingsTile(IconData icon, String title, String subtitle, {VoidCallback? onTap, Color? color}) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color ?? Colors.white54),
      title: Text(title, style: TextStyle(color: color ?? Colors.white)),
      subtitle: Text(subtitle, style: TextStyle(color: color?.withOpacity(0.7) ?? Colors.white38, fontSize: 12)),
      trailing: Icon(Icons.chevron_right, color: color?.withOpacity(0.5) ?? Colors.white38),
    );
  }

  Widget _statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _navTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: const Color(0xFF1A1D2D), borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.white54),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
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
                        Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text(d['email'] ?? '', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      ])),
                      GestureDetector(
                        onTap: () => _editRole(id, role),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFF6C4DFF).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                          child: Text(role, style: const TextStyle(color: Color(0xFF6C4DFF), fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(onTap: () => _deleteUser(id, name), child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20)),
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
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20)),
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
          stream: _db.collection('events').where('isUpcoming', isEqualTo: _showUpcoming).orderBy('createdAt', descending: true).snapshots(),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            final docs = snap.data?.docs ?? [];
            if (docs.isEmpty) return Center(child: Text('No ${_showUpcoming ? 'upcoming' : 'past'} events', style: const TextStyle(color: Colors.white54)));
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
                    title: Text(name, style: const TextStyle(color: Colors.white)),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      GestureDetector(onTap: () => _editCategory(docs[i].id, name), child: const Icon(Icons.edit_outlined, color: Colors.white54, size: 20)),
                      const SizedBox(width: 12),
                      GestureDetector(onTap: () => _delete(docs[i].id, name), child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20)),
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
    Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
      child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: GestureDetector(onTap: () => onDelete(id), child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20)),
    ),
  );
}
