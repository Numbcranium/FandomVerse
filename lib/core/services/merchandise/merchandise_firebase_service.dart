import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:techwiz7_starter/models/merchandise/product_model.dart';

class MerchandiseFirebaseService {
  final FirebaseFirestore _firestore;

  MerchandiseFirebaseService({
    FirebaseFirestore? firestore,
  }) : _firestore =
      firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _products {
    return _firestore.collection('products');
  }

  Future<List<ProductModel>> getProducts() async {
    final snapshot = await _products.get();

    return snapshot.docs.map(
          (doc) {
        return ProductModel.fromMap({
          'id': doc.id,
          ...doc.data(),
        });
      },
    ).toList();
  }

  Future<ProductModel?> getProductById(
      String productId,
      ) async {
    final doc = await _products.doc(productId).get();

    if (!doc.exists) {
      return null;
    }

    return ProductModel.fromMap({
      'id': doc.id,
      ...doc.data()!,
    });
  }

  Future<void> saveProduct(
      ProductModel product,
      ) async {
    await _products.doc(product.id).set(
      product.toMap(),
    );
  }

  Future<void> updateProduct(
      ProductModel product,
      ) async {
    await _products.doc(product.id).update(
      product.toMap(),
    );
  }

  Future<void> deleteProduct(
      String productId,
      ) async {
    await _products.doc(productId).delete();
  }
}