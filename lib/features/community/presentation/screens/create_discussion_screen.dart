import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/auth/presentation/bloc/auth_bloc.dart';

class CreateDiscussionScreen extends StatefulWidget {
  const CreateDiscussionScreen({super.key});

  @override
  State<CreateDiscussionScreen> createState() => _CreateDiscussionScreenState();
}

class _CreateDiscussionScreenState extends State<CreateDiscussionScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _tags = ['Anime', 'Gaming', 'Movies'];
  final Set<String> _selectedTags = {};
  bool _isLoading = false;

  Future<void> _postDiscussion() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _isLoading = true);
    
    final user = context.read<AuthBloc>().state.user;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('posts').add({
        'content': text,
        'tags': _selectedTags.toList(),
        'userId': user.id,
        'username': user.fullName,
        'avatar': user.photoUrl ?? 'https://ui-avatars.com/api/?name=${user.fullName}&background=random',
        'createdAt': FieldValue.serverTimestamp(),
        'likes': 0,
        'comments': 0,
      });

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Dark background matching app theme
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).textTheme.bodyLarge?.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Create Discussion', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _controller,
                maxLines: 6,
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Start a discussion...',
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text('Add tags', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _tags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  selectedColor: const Color(0xFF6C4DFF),
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  side: BorderSide.none,
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _postDiscussion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4DFF), // Purple accent
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading 
                  ? CircularProgressIndicator(color: Theme.of(context).textTheme.bodyLarge?.color) 
                  : Text('Post', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
