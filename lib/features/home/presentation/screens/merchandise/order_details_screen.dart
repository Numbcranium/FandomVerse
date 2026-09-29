
import 'package:flutter/material.dart';

import '../../../../../app/theme/merchandise_colors.dart';
import '../../../../../models/merchandise/order_model.dart';
import '../../../../../models/merchandise/product_model.dart';

class OrderDetailsScreen extends StatelessWidget {
const OrderDetailsScreen({
super.key,
required this.order,
required this.products,
});

final OrderModel order;
final List<ProductModel> products;

String _formatDate(DateTime date) {
final day = date.day.toString().padLeft(2, '0');
final month = date.month.toString().padLeft(2, '0');

return '$day/$month/${date.year}';
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Theme.of(context).scaffoldBackgroundColor,
appBar: AppBar(
title: Text('Order Details'),
backgroundColor: Theme.of(context).scaffoldBackgroundColor,
foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
),
body: SingleChildScrollView(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
width: double.infinity,
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
color: Theme.of(context).cardColor,
borderRadius: BorderRadius.circular(16),
),
child: Column(
children: [
Icon(
Icons.check_circle,
color: MerchColors.primary,
size: 60,
),
SizedBox(height: 12),
Text(
'Order Placed',
style: TextStyle(
color: Theme.of(context).textTheme.bodyLarge?.color,
fontSize: 22,
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 6),
Text(
order.id,
style: TextStyle(
color: Theme.of(context).textTheme.bodyMedium?.color,
),
),
],
),
),

SizedBox(height: 24),

Text(
'Order Information',
style: TextStyle(
color: Theme.of(context).textTheme.bodyLarge?.color,
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

SizedBox(height: 12),

Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Theme.of(context).cardColor,
borderRadius: BorderRadius.circular(16),
),
child: Column(
children: [
_InfoRow(
label: 'Status',
value: order.status,
),
SizedBox(height: 12),
_InfoRow(
label: 'Date',
value: _formatDate(order.createdAt),
),
SizedBox(height: 12),
_InfoRow(
label: 'Items',
value: '${products.length}',
),
],
),
),

SizedBox(height: 24),

Text(
'Products',
style: TextStyle(
color: Theme.of(context).textTheme.bodyLarge?.color,
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

SizedBox(height: 12),

if (products.isEmpty)
Container(
width: double.infinity,
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Theme.of(context).cardColor,
borderRadius: BorderRadius.circular(14),
),
child: Text(
'Product information is no longer available.',
style: TextStyle(
color: Theme.of(context).textTheme.bodyMedium?.color,
),
),
)
else
...products.map(
(product) => Container(
margin: const EdgeInsets.only(bottom: 10),
padding: const EdgeInsets.all(14),
decoration: BoxDecoration(
color: Theme.of(context).cardColor,
borderRadius: BorderRadius.circular(14),
),
child: Row(
children: [
Container(
width: 55,
height: 55,
decoration: BoxDecoration(
color: Theme.of(context).cardColor,
borderRadius: BorderRadius.circular(10),
),
child: Icon(
Icons.shopping_bag_outlined,
color: Theme.of(context).textTheme.bodyMedium?.color,
),
),

SizedBox(width: 12),

Expanded(
child: Text(
product.name,
style: TextStyle(
color: Theme.of(context).textTheme.bodyLarge?.color,
fontWeight: FontWeight.w600,
),
),
),

Text(
'₦${product.price.toStringAsFixed(0)}',
style: TextStyle(
color: MerchColors.primaryLight,
fontWeight: FontWeight.bold,
),
),
],
),
),
),

SizedBox(height: 12),

Container(
width: double.infinity,
padding: const EdgeInsets.all(18),
decoration: BoxDecoration(
color: Theme.of(context).cardColor,
borderRadius: BorderRadius.circular(16),
),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
'Total',
style: TextStyle(
color: Theme.of(context).textTheme.bodyLarge?.color,
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
Text(
'₦${order.totalAmount.toStringAsFixed(0)}',
style: TextStyle(
color: MerchColors.primaryLight,
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
],
),
),

SizedBox(height: 28),

SizedBox(
width: double.infinity,
child: OutlinedButton(
onPressed: () {
Navigator.pop(context);
},
style: OutlinedButton.styleFrom(
foregroundColor: MerchColors.primaryLight,
side: const BorderSide(
color: MerchColors.primary,
),
padding: const EdgeInsets.symmetric(
vertical: 15,
),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
),
child: Text(
'Back to Shop',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),
),
],
),
),
);
}
}

class _InfoRow extends StatelessWidget {
const _InfoRow({
required this.label,
required this.value,
});

final String label;
final String value;

@override
Widget build(BuildContext context) {
return Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
label,
style: TextStyle(
color: Theme.of(context).textTheme.bodyMedium?.color,
),
),
Text(
value,
style: TextStyle(
color: Theme.of(context).textTheme.bodyLarge?.color,
fontWeight: FontWeight.w600,
),
),
],
);
}
}

