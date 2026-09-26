import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Community'),
      ),
      body: const Center(
        child: Text('Community coming soon'),
      ),
    );
  }
}