import 'package:cloud_firestore/cloud_firestore.dart';

class FandomVideo {
  final String id;
  final String fandomId;
  final String title;
  final String videoUrl;
  final String thumbnail;
  final String category;
  final DateTime uploadedAt;

  const FandomVideo({
    required this.id,
    required this.fandomId,
    required this.title,
    required this.videoUrl,
    required this.thumbnail,
    required this.category,
    required this.uploadedAt,
  });

  factory FandomVideo.fromFirestore(
      String documentId,
      Map<String, dynamic> data,
      ) {
    return FandomVideo(
      id: documentId,
      fandomId: data['fandomId']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      videoUrl: data['videoUrl']?.toString() ?? '',
      thumbnail: data['thumbnail']?.toString() ?? '',
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
      'videoUrl': videoUrl,
      'thumbnail': thumbnail,
      'category': category,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
    };
  }
}