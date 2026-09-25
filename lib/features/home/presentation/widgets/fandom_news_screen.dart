import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import 'fandom_news.dart';

class FandomNewsScreen extends StatelessWidget {
  final String fandomId;

  const FandomNewsScreen({
    super.key,
    required this.fandomId,
  });

  // ==========================================
  // GET NEWS FROM FIREBASE
  // ==========================================

  Stream<List<FandomNews>> getNews() {
    return FirebaseFirestore.instance
        .collection('fandoms')
        .doc(fandomId)
        .collection('news')
        .orderBy('publishedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FandomNews.fromFirestore(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0A24),

      // ========================================
      // APP BAR
      // ========================================

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0A24),
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),

        title: const Text(
          'News',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ========================================
      // NEWS FROM FIREBASE
      // ========================================

      body: StreamBuilder<List<FandomNews>>(
        stream: getNews(),

        builder: (context, snapshot) {

          // ======================================
          // LOADING
          // ======================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ======================================
          // ERROR
          // ======================================

          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Unable to load news. Try again later.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
            );
          }

          // ======================================
          // NEWS
          // ======================================

          final news = snapshot.data ?? [];

          // ======================================
          // NO NEWS
          // ======================================

          if (news.isEmpty) {
            return const Center(
              child: Text(
                'No news available',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 15,
                ),
              ),
            );
          }

          // ======================================
          // NEWS LIST
          // ======================================

          return ListView.separated(
            padding: const EdgeInsets.all(16),

            itemCount: news.length,

            separatorBuilder: (context, index) {
              return const SizedBox(height: 14);
            },

            itemBuilder: (context, index) {
              final item = news[index];

              return _NewsCard(
                news: item,

                // onTap: () {
                //   context.pushNamed(
                //     RouteNames.fandomNewsDetailsName,
                //     pathParameters: {
                //       'fandomId': fandomId,
                //       'newsId': item.id,
                //     },
                //   );
                // },

              );
            },
          );
        },
      ),
    );
  }
}

// ======================================================
// NEWS CARD
// ======================================================

class _NewsCard extends StatelessWidget {
  final FandomNews news;

  const _NewsCard({
    required this.news,

  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(


        borderRadius: BorderRadius.circular(14),

        child: Container(
          width: double.infinity,

          decoration: BoxDecoration(
            color: const Color(0xFF17163D),
            borderRadius: BorderRadius.circular(14),
          ),

          clipBehavior: Clip.antiAlias,

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // ====================================
              // IMAGE
              // ====================================

              SizedBox(
                width: double.infinity,
                height: 190,

                child: Image.asset(
                  news.image,
                  fit: BoxFit.cover,

                  errorBuilder:
                      (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF292745),

                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.white38,
                        size: 45,
                      ),
                    );
                  },
                ),
              ),

              // TEXT

              Padding(
                padding: const EdgeInsets.all(15),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    // CATEGORY
                    Text(
                      news.category,

                      style: const TextStyle(
                        color: Color(0xFF8FA8F5),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 7),

                    // TITLE
                    Text(
                      news.title,

                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // DESCRIPTION
                    Text(
                      news.description,

                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // DATE
                    Text(
                      _formatDate(
                        news.publishedAt,
                      ),

                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}