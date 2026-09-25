import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      const _DashboardTab(),
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
        onTap: (index) => setState(() => _currentIndex = index),
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

// ==========================================
// 1. DASHBOARD TAB — Real Firestore counts
// ==========================================
class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  Future<int> _count(String collection) async {
    final snap = await FirebaseFirestore.instance.collection(collection).count().get();
    return snap.count ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        _count('users'),
        _count('events'),
        _count('products'),
        _count('posts'),
      ]),
      builder: (context, snapshot) {
        final counts = snapshot.data ?? [0, 0, 0, 0];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar('Admin Dashboard'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Welcome, Admin!', style: TextStyle(color: Colors.white70, fontSize: 16)),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(child: _buildStatCard('Total Users', '${counts[0]}')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard('Total Events', '${counts[1]}')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(child: _buildStatCard('Total Products', '${counts[2]}')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard('Total Posts', '${counts[3]}')),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildListTile(Icons.people, 'Users'),
                  _buildListTile(Icons.event, 'Events'),
                  _buildListTile(Icons.shopping_bag, 'Merchandise'),
                  _buildListTile(Icons.category, 'Categories'),
                  _buildListTile(Icons.bar_chart, 'Reports'),
                  _buildListTile(Icons.settings, 'Settings'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54, fontSize: 14)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: const Color(0xFF1A1D2D), borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white54),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
      ),
    );
  }
}

// ==========================================
// 2. USER MANAGEMENT TAB — Real Firestore users
// ==========================================
class _UserManagementTab extends StatefulWidget {
  const _UserManagementTab();

  @override
  State<_UserManagementTab> createState() => _UserManagementTabState();
}

class _UserManagementTabState extends State<_UserManagementTab> {
  bool _showAddUser = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  final List<Color> _avatarColors = [
    Colors.pink, Colors.orange, Colors.blue, Colors.purple,
    Colors.teal, Colors.red, Colors.green, Colors.indigo
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _addUser() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) return;
    await FirebaseFirestore.instance.collection('users').add({
      'displayName': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'role': 'fan',
      'createdAt': FieldValue.serverTimestamp(),
    });
    _nameController.clear();
    _emailController.clear();
    setState(() => _showAddUser = false);
  }

  Future<void> _deleteUser(String id) async {
    await FirebaseFirestore.instance.collection('users').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBar('User Management'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(color: const Color(0xFF1A1D2D), borderRadius: BorderRadius.circular(24)),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _showAddUser = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_showAddUser ? const Color(0xFF6C4DFF) : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: Text('All Users', style: TextStyle(color: !_showAddUser ? Colors.white : Colors.white54, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _showAddUser = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _showAddUser ? const Color(0xFF6C4DFF) : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: Text('Add User', style: TextStyle(color: _showAddUser ? Colors.white : Colors.white54, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_showAddUser) _buildAddUserForm(),
        if (!_showAddUser)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(child: Text('No users found.', style: TextStyle(color: Colors.white54)));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final color = _avatarColors[index % _avatarColors.length];
                    return _buildUserTile(docs[index].id, data['displayName'] ?? data['email'] ?? 'Unknown', data['role'] ?? 'fan', color);
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildAddUserForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildTextField(_nameController, 'Display Name', Icons.person),
          const SizedBox(height: 12),
          _buildTextField(_emailController, 'Email', Icons.email),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4DFF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: _addUser,
              child: const Text('Add User', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTile(String id, String name, String role, Color avatarColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF1A1D2D), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: avatarColor.withOpacity(0.2),
            child: Icon(Icons.person, color: avatarColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(role, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: const Text('Active', style: TextStyle(color: Colors.green, fontSize: 12)),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _deleteUser(id),
            child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. CONTENT MANAGEMENT TAB — Fandoms from Firestore
// ==========================================
class _ContentManagementTab extends StatefulWidget {
  const _ContentManagementTab();

  @override
  State<_ContentManagementTab> createState() => _ContentManagementTabState();
}

class _ContentManagementTabState extends State<_ContentManagementTab> {
  bool _showAddContent = false;
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _addFandom() async {
    if (_nameController.text.isEmpty) return;
    await FirebaseFirestore.instance.collection('fandoms').add({
      'name': _nameController.text.trim(),
      'description': _descController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    _nameController.clear();
    _descController.clear();
    setState(() => _showAddContent = false);
  }

  Future<void> _deleteFandom(String id) async {
    await FirebaseFirestore.instance.collection('fandoms').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBar('Content Management'),
        _buildTopButton('Add Fandom', () => setState(() => _showAddContent = !_showAddContent)),
        if (_showAddContent) _buildAddFandomForm(),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('fandoms').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return const Center(child: Text('No fandoms yet. Add one!', style: TextStyle(color: Colors.white54)));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  return _buildDismissibleItem(docs[index].id, Icons.star_border, data['name'] ?? 'Unknown', _deleteFandom);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddFandomForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildTextField(_nameController, 'Fandom Name', Icons.star_border),
          const SizedBox(height: 8),
          _buildTextField(_descController, 'Description (optional)', Icons.description),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4DFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: _addFandom,
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 4. EVENT MANAGEMENT TAB — Real Firestore events
// ==========================================
class _EventManagementTab extends StatefulWidget {
  const _EventManagementTab();

  @override
  State<_EventManagementTab> createState() => _EventManagementTabState();
}

class _EventManagementTabState extends State<_EventManagementTab> {
  bool _showAddEvent = false;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _addEvent() async {
    if (_titleController.text.isEmpty) return;
    await FirebaseFirestore.instance.collection('events').add({
      'title': _titleController.text.trim(),
      'description': _descController.text.trim(),
      'date': _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null,
      'isUpcoming': _selectedDate == null || _selectedDate!.isAfter(DateTime.now()),
      'createdAt': FieldValue.serverTimestamp(),
    });
    _titleController.clear();
    _descController.clear();
    setState(() {
      _showAddEvent = false;
      _selectedDate = null;
    });
  }

  Future<void> _deleteEvent(String id) async {
    await FirebaseFirestore.instance.collection('events').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBar('Event Management'),
        _buildTopButton('Add Event', () => setState(() => _showAddEvent = !_showAddEvent)),
        if (_showAddEvent) _buildAddEventForm(),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('events').orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return const Center(child: Text('No events yet. Add one!', style: TextStyle(color: Colors.white54)));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final isUpcoming = data['isUpcoming'] == true;
                  return _buildDismissibleItem(docs[index].id, isUpcoming ? Icons.event_available : Icons.history, data['title'] ?? 'Untitled', _deleteEvent);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddEventForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildTextField(_titleController, 'Event Title', Icons.event),
          const SizedBox(height: 8),
          _buildTextField(_descController, 'Description', Icons.description),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF1A1D2D), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.white54, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    _selectedDate == null ? 'Pick a date' : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    style: TextStyle(color: _selectedDate == null ? Colors.white54 : Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4DFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: _addEvent,
              child: const Text('Save Event', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 5. CATEGORY MANAGEMENT TAB — Real Firestore categories
// ==========================================
class _CategoryManagementTab extends StatefulWidget {
  const _CategoryManagementTab();

  @override
  State<_CategoryManagementTab> createState() => _CategoryManagementTabState();
}

class _CategoryManagementTabState extends State<_CategoryManagementTab> {
  bool _showAddCategory = false;
  final _nameController = TextEditingController();

  final List<Map<String, dynamic>> _categoryIcons = [
    {'label': 'Anime', 'icon': Icons.animation},
    {'label': 'Gaming', 'icon': Icons.sports_esports},
    {'label': 'Movies & TV', 'icon': Icons.movie_creation_outlined},
    {'label': 'Comics', 'icon': Icons.menu_book},
    {'label': 'Music', 'icon': Icons.music_note},
    {'label': 'Sports', 'icon': Icons.sports_soccer},
    {'label': 'Tech', 'icon': Icons.computer},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _addCategory() async {
    if (_nameController.text.isEmpty) return;
    await FirebaseFirestore.instance.collection('categories').add({
      'name': _nameController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    _nameController.clear();
    setState(() => _showAddCategory = false);
  }

  Future<void> _deleteCategory(String id) async {
    await FirebaseFirestore.instance.collection('categories').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBar('Category Management'),
        _buildTopButton('Add Category', () => setState(() => _showAddCategory = !_showAddCategory)),
        if (_showAddCategory)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(child: _buildTextField(_nameController, 'Category Name', Icons.category)),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4DFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _addCategory,
                  child: const Text('Add', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('categories').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = snapshot.data?.docs ?? [];
              // Seed with the default categories first if empty
              if (docs.isEmpty) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: _categoryIcons.map((c) => _buildListItem(c['icon'] as IconData, c['label'] as String)).toList(),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  return _buildDismissibleItem(docs[index].id, Icons.category, data['name'] ?? 'Unknown', _deleteCategory);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ==========================================
// SHARED HELPERS
// ==========================================

Widget _buildAppBar(String title) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        const Icon(Icons.arrow_back, color: Colors.white),
        const SizedBox(width: 16),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

Widget _buildTopButton(String title, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C4DFF),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        onPressed: onPressed,
        child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    ),
  );
}

Widget _buildListItem(IconData icon, String title) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(color: const Color(0xFF1A1D2D), borderRadius: BorderRadius.circular(16)),
    child: ListTile(
      leading: Icon(icon, color: Colors.white54),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white54),
    ),
  );
}

Widget _buildDismissibleItem(String id, IconData icon, String title, Future<void> Function(String) onDelete) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(color: const Color(0xFF1A1D2D), borderRadius: BorderRadius.circular(16)),
    child: ListTile(
      leading: Icon(icon, color: Colors.white54),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: GestureDetector(
        onTap: () => onDelete(id),
        child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
      ),
    ),
  );
}

Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
  return TextField(
    controller: controller,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: Colors.white54),
      filled: true,
      fillColor: const Color(0xFF1A1D2D),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    ),
  );
}
