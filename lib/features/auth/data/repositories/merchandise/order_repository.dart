import 'package:techwiz7_starter/core/services/merchandise/order_firebase_service.dart';
import 'package:techwiz7_starter/core/services/merchandise/order_sqlite_service.dart';
import 'package:techwiz7_starter/models/merchandise/order_model.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> getOrders();

  Future<OrderModel?> getOrderById(String orderId);

  Future<void> createOrder(OrderModel order);

  Future<void> updateOrder(OrderModel order);
}

class OrderRepositoryImpl implements OrderRepository {
  final OrderFirebaseService _firebaseService;
  final OrderSqliteService _sqliteService;

  final String userId;

  OrderRepositoryImpl({
    required this.userId,
    OrderFirebaseService? firebaseService,
    OrderSqliteService? sqliteService,
  })  : _firebaseService =
      firebaseService ?? OrderFirebaseService(),
        _sqliteService =
            sqliteService ?? OrderSqliteService();

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final orders = await _firebaseService.getOrders(userId);

      for (final order in orders) {
        await _sqliteService.saveOrder(order);
      }

      return orders;
    } catch (_) {
      return _sqliteService.getOrders();
    }
  }

  @override
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final order = await _firebaseService.getOrderById(
        userId,
        orderId,
      );

      if (order != null) {
        await _sqliteService.saveOrder(order);
        return order;
      }
    } catch (_) {
      // Firebase unavailable.
    }

    return _sqliteService.getOrderById(orderId);
  }

  @override
  Future<void> createOrder(OrderModel order) async {
    // Save locally first so the order works offline.
    await _sqliteService.saveOrder(order);

    try {
      await _firebaseService.saveOrder(
        userId,
        order,
      );
    } catch (_) {
      // Keep the local order if Firebase is unavailable.
    }
  }

  @override
  Future<void> updateOrder(OrderModel order) async {
    await _sqliteService.updateOrder(order);

    try {
      await _firebaseService.updateOrder(
        userId,
        order,
      );
    } catch (_) {
      // SQLite keeps the updated local version.
    }
  }
}