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
      final postId = widget.post['id'];
      
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
      backgroundColor: const Color(0xFF0F111A), // Dark background matching app theme
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F111A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Discussion Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          _buildOriginalPost(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Comments', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.post['id'])
                  .collection('comments')
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading comments', style: TextStyle(color: Colors.white)));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(child: Text('No comments yet. Be the first!', style: TextStyle(color: Colors.white70)));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return _buildComment(
                      username: data['username'] ?? 'User',
                      avatar: data['avatar'] ?? 'https://ui-avatars.com/api/?name=User&background=random',
                      time: 'Just now', // Ideally formatted from timestamp
                      content: data['content'] ?? '',
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
        color: const Color(0xFF1A1D2D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.post['avatar']),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.post['username'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(widget.post['time'], style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(widget.post['content'], style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.favorite, color: Color(0xFF6C4DFF), size: 20),
              const SizedBox(width: 4),
              Text('${widget.post['likes']}', style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 16),
              const Icon(Icons.chat_bubble_outline, color: Colors.white54, size: 20),
              const SizedBox(width: 4),
              Text('${widget.post['comments']}', style: const TextStyle(color: Colors.white54)),
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
        color: const Color(0xFF1A1D2D),
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
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(time, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 8),
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
      decoration: const BoxDecoration(
        color: Color(0xFF1A1D2D),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F111A),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _commentController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: const Color(0xFF6C4DFF),
            child: IconButton(
              icon: _isPosting 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: _isPosting ? null : _postComment,
            ),
          ),
        ],
      ),
    );
  }
}
