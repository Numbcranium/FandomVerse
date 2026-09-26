import 'package:flutter/material.dart';

import '../../../../models/fandom-news-service.dart';
import 'fandom_news.dart';

class FandomNewsDetailsScreen extends StatelessWidget {
  final String fandomId;
  final String newsId;

  const FandomNewsDetailsScreen({
    super.key,
    required this.fandomId,
    required this.newsId,
  });

  @override
  Widget build(BuildContext context) {
    final newsService = FandomNewsService();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0C24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0C24),
        foregroundColor: Colors.white,
        title: const Text('News'),
      ),
      body: FutureBuilder<FandomNews?>(
        future: newsService.getNewsById(
          fandomId: fandomId,
          newsId: newsId,
        ),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong.',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          // News doesn't exist
          final news = snapshot.data;

          if (news == null) {
            return const Center(
              child: Text(
                'News not found.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            );
          }

          // News details
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // News image
                Image.asset(
                  news.image,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                  errorBuilder: (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return Container(
                      width: double.infinity,
                      height: 240,
                      color: const Color(0xFF292745),
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.white54,
                        size: 50,
                      ),
                    );
                  },
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // Category
                      Text(
                        news.category,
                        style: const TextStyle(
                          color: Color(0xFF8FA8F5),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Title
                      Text(
                        news.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Date
                      Text(
                        _formatDate(news.publishedAt),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Short description
                      Text(
                        news.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Full news content
                      Text(
                        news.content,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}