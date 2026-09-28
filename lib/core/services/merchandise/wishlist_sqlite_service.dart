import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:techwiz7_starter/models/merchandise/wishlist_item_model.dart';

import 'db_helper.dart';

class WishlistSqliteService {
  Future<List<WishlistItemModel>> getWishlist() async {
    if (kIsWeb) return [];
    final db = await DbHelper.instance.database;

    final result = await db.query('wishlist');

    return result.map(
          (map) {
        return WishlistItemModel.fromMap({
          'id': map['id'],
          'product': jsonDecode(
            map['product'] as String,
          ),
          'savedAt': map['savedAt'],
        });
      },
    ).toList();
  }

  Future<void> saveWishlistItem(
      WishlistItemModel item,
      ) async {
    if (kIsWeb) return;
    final db = await DbHelper.instance.database;

    await db.insert(
      'wishlist',
      {
        'id': item.id,
        'product': jsonEncode(
          item.product.toMap(),
        ),
        'savedAt': item.savedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteWishlistItem(
      String itemId,
      ) async {
    if (kIsWeb) return;
    final db = await DbHelper.instance.database;

    await db.delete(
      'wishlist',
      where: 'id = ?',
      whereArgs: [itemId],
    );
  }

  Future<void> clearWishlist() async {
    if (kIsWeb) return;
    final db = await DbHelper.instance.database;

    await db.delete('wishlist');
  }
}