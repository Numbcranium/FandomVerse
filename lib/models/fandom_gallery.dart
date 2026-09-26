import 'package:cloud_firestore/cloud_firestore.dart';

class FandomGallery {
  final String id;
  final String fandomId;
  final String title;
  final String image;
  final String category;
  final DateTime uploadedAt;

  const FandomGallery({
    required this.id,
    required this.fandomId,
    required this.title,
    required this.image,
    required this.category,
    required this.uploadedAt,
  });

  factory FandomGallery.fromFirestore(
      String documentId,
      Map<String, dynamic> data,
      ) {
    return FandomGallery(
      id: documentId,
      fandomId: data['fandomId']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      image: data['image']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
      uploadedAt: data['uploadedAt'] is Timestamp
          ? (data['uploadedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fandomId': fandomId,
      'title': title,
      'image': image,
      'category': category,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
    };
  }
}