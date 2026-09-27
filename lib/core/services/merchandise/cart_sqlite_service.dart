import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:techwiz7_starter/models/merchandise/cart_item_model.dart';

import 'db_helper.dart';

class CartSqliteService {
  Future<List<CartItemModel>> getCartItems() async {
    final db = await DbHelper.instance.database;

    final result = await db.query('cart');

    return result.map(
          (map) {
        return CartItemModel.fromMap({
          'id': map['id'],
          'product': jsonDecode(
            map['product'] as String,
          ),
          'quantity': map['quantity'],
        });
      },
    ).toList();
  }

  Future<void> saveCartItem(
      CartItemModel item,
      ) async {
    final db = await DbHelper.instance.database;

    await db.insert(
      'cart',
      {
        'id': item.id,
        'product': jsonEncode(
          item.product.toMap(),
        ),
        'quantity': item.quantity,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCartItem(
      CartItemModel item,
      ) async {
    final db = await DbHelper.instance.database;

    await db.update(
      'cart',
      {
        'product': jsonEncode(
          item.product.toMap(),
        ),
        'quantity': item.quantity,
      },
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteCartItem(
      String itemId,
      ) async {
    final db = await DbHelper.instance.database;

    await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [itemId],
    );
  }

  Future<void> clearCart() async {
    final db = await DbHelper.instance.database;

    await db.delete('cart');
  }
}