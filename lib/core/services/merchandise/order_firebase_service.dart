import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:techwiz7_starter/models/merchandise/order_model.dart';

class OrderFirebaseService {
  final FirebaseFirestore _firestore;

  OrderFirebaseService({
    FirebaseFirestore? firestore,
  }) : _firestore =
      firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _orders(
      String userId,
      ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('orders');
  }

  Future<List<OrderModel>> getOrders(
      String userId,
      ) async {
    final snapshot = await _orders(userId)
        .orderBy(
      'createdAt',
      descending: true,
    )
        .get();

    return snapshot.docs.map(
          (doc) {
        return OrderModel.fromMap({
          'id': doc.id,
          ...doc.data(),
        });
      },
    ).toList();
  }

  Future<OrderModel?> getOrderById(
      String userId,
      String orderId,
      ) async {
    final doc = await _orders(userId).doc(orderId).get();

    if (!doc.exists) {
      return null;
    }

    return OrderModel.fromMap({
      'id': doc.id,
      ...doc.data()!,
    });
  }

  Future<void> saveOrder(
      String userId,
      OrderModel order,
      ) async {
    await _orders(userId).doc(order.id).set(
      order.toMap(),
    );
  }

  Future<void> updateOrder(
      String userId,
      OrderModel order,
      ) async {
    await _orders(userId).doc(order.id).update(
      order.toMap(),
    );
  }

  Future<void> deleteOrder(
      String userId,
      String orderId,
      ) async {
    await _orders(userId).doc(orderId).delete();
  }
}