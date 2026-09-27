class OrderModel {
  final String id;
  final List<String> productIds;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.productIds,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id']?.toString() ?? '',
      productIds: (map['productIds'] as List?)
          ?.map((item) => item.toString())
          .toList() ??
          [],
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0,
      status: map['status']?.toString() ?? 'Pending',
      createdAt: DateTime.tryParse(
        map['createdAt']?.toString() ?? '',
      ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productIds': productIds,
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}