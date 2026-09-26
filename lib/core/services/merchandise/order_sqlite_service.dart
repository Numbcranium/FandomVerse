import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:techwiz7_starter/models/merchandise/order_model.dart';

import 'db_helper.dart';

class OrderSqliteService {
  Future<List<OrderModel>> getOrders() async {
    final db = await DbHelper.instance.database;

    final result = await db.query(
      'orders',
      orderBy: 'createdAt DESC',
    );

    return result.map(
          (map) {
        return OrderModel.fromMap({
          'id': map['id'],
          'productIds': jsonDecode(
            map['productIds'] as String,
          ),
          'totalAmount': map['totalAmount'],
          'status': map['status'],
          'createdAt': map['createdAt'],
        });
      },
    ).toList();
  }

  Future<OrderModel?> getOrderById(
      String orderId,
      ) async {
    final db = await DbHelper.instance.database;

    final result = await db.query(
      'orders',
      where: 'id = ?',
      whereArgs: [orderId],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    final map = result.first;

    return OrderModel.fromMap({
      'id': map['id'],
      'productIds': jsonDecode(
        map['productIds'] as String,
      ),
      'totalAmount': map['totalAmount'],
      'status': map['status'],
      'createdAt': map['createdAt'],
    });
  }

  Future<void> saveOrder(
      OrderModel order,
      ) async {
    final db = await DbHelper.instance.database;

    await db.insert(
      'orders',
      {
        'id': order.id,
        'productIds': jsonEncode(
          order.productIds,
        ),
        'totalAmount': order.totalAmount,
        'status': order.status,
        'createdAt': order.createdAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateOrder(
      OrderModel order,
      ) async {
    final db = await DbHelper.instance.database;

    await db.update(
      'orders',
      {
        'productIds': jsonEncode(
          order.productIds,
        ),
        'totalAmount': order.totalAmount,
        'status': order.status,
        'createdAt': order.createdAt.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  Future<void> deleteOrder(
      String orderId,
      ) async {
    final db = await DbHelper.instance.database;

    await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }
}