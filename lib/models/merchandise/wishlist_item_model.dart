
import 'product_model.dart';

class WishlistItemModel {
final String id;
final ProductModel product;
final DateTime savedAt;

const WishlistItemModel({
required this.id,
required this.product,
required this.savedAt,
});

factory WishlistItemModel.fromMap(Map<String, dynamic> map) {
return WishlistItemModel(
id: map['id']?.toString() ?? '',
  product: ProductModel.fromMap(
    Map<String, dynamic>.from(
      (map['product'] as Map?) ?? {},
    ),
  ),
savedAt: DateTime.tryParse(
map['savedAt']?.toString() ?? '',
) ??
DateTime.now(),
);
}

Map<String, dynamic> toMap() {
return {
'id': id,
'product': product.toMap(),
'savedAt': savedAt.toIso8601String(),
};
}
}

