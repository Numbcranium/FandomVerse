import 'package:sqflite/sqflite.dart';
import 'package:techwiz7_starter/models/merchandise/product_model.dart';

import 'db_helper.dart';

class ProductSqliteService {
  Future<List<ProductModel>> getProducts() async {
    final db = await DbHelper.instance.database;

    final result = await db.query('products');

    return result.map(
          (map) {
        return ProductModel.fromMap(map);
      },
    ).toList();
  }

  Future<ProductModel?> getProductById(
      String productId,
      ) async {
    final db = await DbHelper.instance.database;

    final result = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return ProductModel.fromMap(result.first);
  }

  Future<void> saveProduct(
      ProductModel product,
      ) async {
    final db = await DbHelper.instance.database;

    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> saveProducts(
      List<ProductModel> products,
      ) async {
    final db = await DbHelper.instance.database;

    final batch = db.batch();

    for (final product in products) {
      batch.insert(
        'products',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> deleteProduct(
      String productId,
      ) async {
    final db = await DbHelper.instance.database;

    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  Future<void> clearProducts() async {
    final db = await DbHelper.instance.database;

    await db.delete('products');
  }
}