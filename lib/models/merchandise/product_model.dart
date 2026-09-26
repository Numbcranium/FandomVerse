
class ProductModel {
final String id;
final String name;
final double price;
final String imageUrl;
final String category;

const ProductModel({
required this.id,
required this.name,
required this.price,
required this.imageUrl,
required this.category,
});

factory ProductModel.fromMap(Map<String, dynamic> map) {
return ProductModel(
id: map['id']?.toString() ?? '',
name: map['name']?.toString() ?? '',
price: (map['price'] as num?)?.toDouble() ?? 0,
imageUrl: map['imageUrl']?.toString() ?? '',
category: map['category']?.toString() ?? '',
);
}

Map<String, dynamic> toMap() {
return {
'id': id,
'name': name,
'price': price,
'imageUrl': imageUrl,
'category': category,
};
}
}

