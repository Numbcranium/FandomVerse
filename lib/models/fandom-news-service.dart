import 'package:cloud_firestore/cloud_firestore.dart';

import '../features/home/presentation/widgets/fandom_news.dart';

class FandomNewsService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> addNews(FandomNews news) async {
    await _firestore
        .collection('fandoms')
        .doc(news.fandomId)
        .collection('news')
        .doc(news.id)
        .set(news.toFirestore());
  }

  Stream<List<FandomNews>> getNews(String fandomId) {
    return _firestore
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

  Future<FandomNews?> getNewsById({
    required String fandomId,
    required String newsId,
  }) async {
    final doc = await _firestore
        .collection('fandoms')
        .doc(fandomId)
        .collection('news')
        .doc(newsId)
        .get();

    if (!doc.exists) {
      return null;
    }

    return FandomNews.fromFirestore(
      doc.id,
      doc.data()!,
    );
  }
}