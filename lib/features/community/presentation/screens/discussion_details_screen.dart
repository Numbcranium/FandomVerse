import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/auth/presentation/bloc/auth_bloc.dart';

class DiscussionDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> post;

  const DiscussionDetailsScreen({super.key, required this.post});

  @override
  State<DiscussionDetailsScreen> createState() => _DiscussionDetailsScreenState();
}

class _DiscussionDetailsScreenState extends State<DiscussionDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isPosting = false;

  Future<void> _postComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isPosting = true);

    final user = context.read<AuthBloc>().state.user;
    if (user == null) {
      setState(() => _isPosting = false);
      return;
    }

    try {
      final postId = widget.post['id'] as String? ?? '';
      
      // Add comment to subcollection
      await FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').add({
        'content': text,
        'userId': user.id,
        'username': user.fullName,
        'avatar': user.photoUrl ?? 'https://ui-avatars.com/api/?name=${user.fullName}&background=random',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Increment comments count on post
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'comments': FieldValue.increment(1),
      });

      _commentController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isPosting = false);
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
        title: Text('Discussion Details', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          _buildOriginalPost(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Comments', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.post['id'] as String? ?? '')
                  .collection('comments')
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading comments', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return Center(child: Text('No comments yet. Be the first!', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return _buildComment(
                      username: data['username'] as String? ?? 'User',
                      avatar: data['avatar'] as String? ?? 'https://ui-avatars.com/api/?name=User&background=random',
                      time: 'Just now',
                      content: data['content'] as String? ?? '',
                    );
                  },
                );
              },
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildOriginalPost() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.post['avatar'] as String? ?? ''),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.post['username'] as String? ?? '', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold)),
                  Text(widget.post['time'] as String? ?? '', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 12)),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(widget.post['content'] as String? ?? '', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 16)),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.favorite, color: Color(0xFF6C4DFF), size: 20),
              SizedBox(width: 4),
              Text('${widget.post['likes']}', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
              SizedBox(width: 16),
              Icon(Icons.chat_bubble_outline, color: Theme.of(context).textTheme.bodyMedium?.color, size: 20),
              SizedBox(width: 4),
              Text('${widget.post['comments']}', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComment({required String username, required String avatar, required String time, required String content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(avatar),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(time, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 12)),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(content, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 14)),
          SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerRight,
            child: Text('Reply', style: TextStyle(color: Color(0xFF6C4DFF), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _commentController,
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: const Color(0xFF6C4DFF),
            child: IconButton(
              icon: _isPosting 
                ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Theme.of(context).textTheme.bodyLarge?.color, strokeWidth: 2))
                : Icon(Icons.send, color: Theme.of(context).textTheme.bodyLarge?.color, size: 20),
              onPressed: _isPosting ? null : _postComment,
            ),
          ),
        ],
      ),
    );
  }
}
