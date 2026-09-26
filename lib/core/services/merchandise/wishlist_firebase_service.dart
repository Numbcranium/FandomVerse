import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:techwiz7_starter/models/merchandise/wishlist_item_model.dart';

class WishlistFirebaseService {
  final FirebaseFirestore _firestore;

  WishlistFirebaseService({
    FirebaseFirestore? firestore,
  }) : _firestore =
      firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _wishlist(
      String userId,
      ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist');
  }

  Future<List<WishlistItemModel>> getWishlist(
      String userId,
      ) async {
    final snapshot = await _wishlist(userId).get();

    return snapshot.docs.map(
          (doc) {
        return WishlistItemModel.fromMap({
          'id': doc.id,
          ...doc.data(),
        });
      },
    ).toList();
  }

  Future<void> saveWishlistItem(
      String userId,
      WishlistItemModel item,
      ) async {
    await _wishlist(userId).doc(item.id).set(
      item.toMap(),
    );
  }

  Future<void> deleteWishlistItem(
      String userId,
      String itemId,
      ) async {
    await _wishlist(userId).doc(itemId).delete();
  }

  Future<void> clearWishlist(
      String userId,
      ) async {
    final snapshot = await _wishlist(userId).get();

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}