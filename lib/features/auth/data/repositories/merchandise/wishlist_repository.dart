import 'package:techwiz7_starter/core/services/merchandise/wishlist_firebase_service.dart';
import 'package:techwiz7_starter/core/services/merchandise/wishlist_sqlite_service.dart';
import 'package:techwiz7_starter/models/merchandise/wishlist_item_model.dart';

abstract class WishlistRepository {
  Future<List<WishlistItemModel>> getWishlist();

  Future<void> addToWishlist(WishlistItemModel item);

  Future<void> removeFromWishlist(String itemId);

  Future<bool> isInWishlist(String productId);

  Future<void> clearWishlist();
}

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistFirebaseService _firebaseService;
  final WishlistSqliteService _sqliteService;

  final String userId;

  WishlistRepositoryImpl({
    required this.userId,
    WishlistFirebaseService? firebaseService,
    WishlistSqliteService? sqliteService,
  })  : _firebaseService =
      firebaseService ?? WishlistFirebaseService(),
        _sqliteService =
            sqliteService ?? WishlistSqliteService();

  @override
  Future<List<WishlistItemModel>> getWishlist() async {
    try {
      final items = await _firebaseService.getWishlist(userId);

      await _sqliteService.clearWishlist();

      for (final item in items) {
        await _sqliteService.saveWishlistItem(item);
      }

      return items;
    } catch (_) {
      return _sqliteService.getWishlist();
    }
  }

  @override
  Future<void> addToWishlist(
      WishlistItemModel item,
      ) async {
    await _sqliteService.saveWishlistItem(item);

    try {
      await _firebaseService.saveWishlistItem(
        userId,
        item,
      );
    } catch (_) {
      // Keep the item locally when Firebase is unavailable.
    }
  }

  @override
  Future<void> removeFromWishlist(
      String itemId,
      ) async {
    await _sqliteService.deleteWishlistItem(itemId);

    try {
      await _firebaseService.deleteWishlistItem(
        userId,
        itemId,
      );
    } catch (_) {
      // Local deletion is already complete.
    }
  }

  @override
  Future<bool> isInWishlist(
      String productId,
      ) async {
    final wishlist = await getWishlist();

    return wishlist.any(
          (item) => item.product.id == productId,
    );
  }

  @override
  Future<void> clearWishlist() async {
    await _sqliteService.clearWishlist();

    try {
      await _firebaseService.clearWishlist(userId);
    } catch (_) {
      // Local wishlist is already cleared.
    }
  }
}