import 'package:cloud_firestore/cloud_firestore.dart';

class FandomNews {
  final String id;
  final String fandomId;
  final String title;
  final String description;
  final String content;
  final String image;
  final String category;
  final DateTime publishedAt;

  const FandomNews({
    required this.id,
    required this.fandomId,
    required this.title,
    required this.description,
    required this.content,
    required this.image,
    required this.category,
    required this.publishedAt,
  });

  factory FandomNews.fromFirestore(
      String documentId,
      Map<String, dynamic> data,
      ) {
    return FandomNews(
      id: documentId,
      fandomId: data['fandomId']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      content: data['content']?.toString() ?? '',
      image: data['image']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
      publishedAt: data['publishedAt'] is Timestamp
          ? (data['publishedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fandomId': fandomId,
      'title': title,
      'description': description,
      'content': content,
      'image': image,
      'category': category,
      'publishedAt': Timestamp.fromDate(publishedAt),
    };
  }
}