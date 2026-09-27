import 'product_model.dart';

class CartItemModel {
  final String id;
  final ProductModel product;
  final int quantity;

  const CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
  });

  double get subtotal => product.price * quantity;

  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    final productMap = map['product'];

    return CartItemModel(
      id: map['id']?.toString() ?? '',
      product: ProductModel.fromMap(
        productMap is Map
            ? Map<String, dynamic>.from(productMap)
            : <String, dynamic>{},
      ),
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product.toMap(),
      'quantity': quantity,
    };
  }
}