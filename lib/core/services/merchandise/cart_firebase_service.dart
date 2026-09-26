import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:techwiz7_starter/models/merchandise/cart_item_model.dart';

class CartFirebaseService {
  final FirebaseFirestore _firestore;

  CartFirebaseService({
    FirebaseFirestore? firestore,
  }) : _firestore =
      firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _cart(
      String userId,
      ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cart');
  }

  Future<List<CartItemModel>> getCartItems(
      String userId,
      ) async {
    final snapshot = await _cart(userId).get();

    return snapshot.docs.map(
          (doc) {
        return CartItemModel.fromMap({
          'id': doc.id,
          ...doc.data(),
        });
      },
    ).toList();
  }

  Future<void> saveCartItem(
      String userId,
      CartItemModel item,
      ) async {
    await _cart(userId).doc(item.id).set(
      item.toMap(),
    );
  }

  Future<void> updateCartItem(
      String userId,
      CartItemModel item,
      ) async {
    await _cart(userId).doc(item.id).update(
      item.toMap(),
    );
  }

  Future<void> deleteCartItem(
      String userId,
      String itemId,
      ) async {
    await _cart(userId).doc(itemId).delete();
  }

  Future<void> clearCart(
      String userId,
      ) async {
    final snapshot = await _cart(userId).get();

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}