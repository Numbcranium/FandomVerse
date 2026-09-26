import 'package:techwiz7_starter/core/services/merchandise/merchandise_firebase_service.dart';
import 'package:techwiz7_starter/core/services/merchandise/product_sqlite_service.dart';
import 'package:techwiz7_starter/mock/merchandise_mock.dart';
import 'package:techwiz7_starter/models/merchandise/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts();

  Future<ProductModel?> getProductById(String productId);

  Future<List<ProductModel>> getProductsByCategory(String category);

  Future<List<ProductModel>> searchProducts(String query);
}

class ProductRepositoryImpl implements ProductRepository {
  final MerchandiseFirebaseService _firebaseService;
  final ProductSqliteService _sqliteService;

  ProductRepositoryImpl({
    MerchandiseFirebaseService? firebaseService,
    ProductSqliteService? sqliteService,
  })  : _firebaseService =
      firebaseService ?? MerchandiseFirebaseService(),
        _sqliteService = sqliteService ?? ProductSqliteService();

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final products = await _firebaseService.getProducts();

      if (products.isNotEmpty) {
        await _sqliteService.saveProducts(products);
        return products;
      }
    } catch (_) {
      // Firebase unavailable.
      // Continue with SQLite cache.
    }

    final cachedProducts = await _sqliteService.getProducts();

    if (cachedProducts.isNotEmpty) {
      return cachedProducts;
    }

    // Temporary fallback while Firebase/SQLite has no products.
    return List<ProductModel>.from(MerchandiseMock.products);
  }

  @override
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final product = await _firebaseService.getProductById(productId);

      if (product != null) {
        await _sqliteService.saveProduct(product);
        return product;
      }
    } catch (_) {
      // Firebase unavailable.
    }

    final cachedProduct =
    await _sqliteService.getProductById(productId);

    if (cachedProduct != null) {
      return cachedProduct;
    }

    try {
      return MerchandiseMock.products.firstWhere(
            (product) => product.id == productId,
      );
    } on StateError {
      return null;
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(
      String category,
      ) async {
    final products = await getProducts();

    if (category.toLowerCase() == 'all') {
      return products;
    }

    return products.where(
          (product) {
        return product.category.toLowerCase() ==
            category.toLowerCase();
      },
    ).toList();
  }

  @override
  Future<List<ProductModel>> searchProducts(
      String query,
      ) async {
    final search = query.trim().toLowerCase();

    final products = await getProducts();

    if (search.isEmpty) {
      return products;
    }

    return products.where(
          (product) {
        return product.name.toLowerCase().contains(search) ||
            product.category.toLowerCase().contains(search);
      },
    ).toList();
  }
}