import 'package:techwiz7_starter/core/services/merchandise/cart_firebase_service.dart';
import 'package:techwiz7_starter/core/services/merchandise/cart_sqlite_service.dart';
import 'package:techwiz7_starter/models/merchandise/cart_item_model.dart';

abstract class CartRepository {
  Future<List<CartItemModel>> getCartItems();

  Future<void> addToCart(CartItemModel item);

  Future<void> updateCartItem(CartItemModel item);

  Future<void> removeFromCart(String itemId);

  Future<void> clearCart();

  Future<double> getCartTotal();
}

class CartRepositoryImpl implements CartRepository {
  final CartFirebaseService _firebaseService;
  final CartSqliteService _sqliteService;

  final String userId;

  CartRepositoryImpl({
    required this.userId,
    CartFirebaseService? firebaseService,
    CartSqliteService? sqliteService,
  })  : _firebaseService =
      firebaseService ?? CartFirebaseService(),
        _sqliteService =
            sqliteService ?? CartSqliteService();

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final items = await _firebaseService.getCartItems(userId);

      await _sqliteService.clearCart();

      for (final item in items) {
        await _sqliteService.saveCartItem(item);
      }

      return items;
    } catch (_) {
      return _sqliteService.getCartItems();
    }
  }

  @override
  Future<void> addToCart(CartItemModel item) async {
    await _sqliteService.saveCartItem(item);

    try {
      await _firebaseService.saveCartItem(userId, item);
    } catch (_) {
      // Keep the item in SQLite for offline use.
    }
  }

  @override
  Future<void> updateCartItem(CartItemModel item) async {
    await _sqliteService.updateCartItem(item);

    try {
      await _firebaseService.updateCartItem(userId, item);
    } catch (_) {
      // SQLite keeps the latest local version.
    }
  }

  @override
  Future<void> removeFromCart(String itemId) async {
    await _sqliteService.deleteCartItem(itemId);

    try {
      await _firebaseService.deleteCartItem(
        userId,
        itemId,
      );
    } catch (_) {
      // Local deletion is already complete.
    }
  }

  @override
  Future<void> clearCart() async {
    await _sqliteService.clearCart();

    try {
      await _firebaseService.clearCart(userId);
    } catch (_) {
      // Local cart is already cleared.
    }
  }

  @override
  Future<double> getCartTotal() async {
    final items = await getCartItems();

    return items.fold<double>(
      0.0,
          (total, item) => total + item.subtotal,
    );
  }
}