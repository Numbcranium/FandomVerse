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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: Text('News', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
      ),
      body: FutureBuilder<FandomNews?>(
        future: newsService.getNewsById(
          fandomId: fandomId,
          newsId: newsId,
        ),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong.',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            );
          }

          // News doesn't exist
          final news = snapshot.data;

          if (news == null) {
            return Center(
              child: Text(
                'News not found.',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
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
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
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
                        style: TextStyle(
                          color: Color(0xFF8FA8F5),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      // Title
                      Text(
                        news.title,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      // Date
                      Text(
                        _formatDate(news.publishedAt),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontSize: 13,
                        ),
                      ),

                      SizedBox(height: 20),

                      // Short description
                      Text(
                        news.description,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 20),

                      // Full news content
                      Text(
                        news.content,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
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