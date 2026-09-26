
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../app/theme/merchandise_colors.dart';
import '../../../../../models/merchandise/cart_item_model.dart';
import '../../../../../models/merchandise/order_model.dart';
import '../../../../../widgets/merchandise/price_widget.dart';
import '../../../../auth/data/repositories/merchandise/cart_repository.dart';
import '../../../../auth/data/repositories/merchandise/order_repository.dart';
import '../../widgets/merchandise/price_widget.dart';
import 'order_details_screen.dart';

class CheckoutScreen extends StatefulWidget {
const CheckoutScreen({
super.key,
this.items,
});

final List<CartItemModel>? items;

@override
State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
late final OrderRepository _orderRepository;
late final CartRepository _cartRepository;

bool _isPlacingOrder = false;

String get userId {
return FirebaseAuth.instance.currentUser?.uid ?? 'guest';
}

List<CartItemModel> get checkoutItems {
return widget.items ?? [];
}

double get subtotal {
return checkoutItems.fold<double>(
0,
(sum, item) => sum + item.subtotal,
);
}

double get total {
return subtotal;
}

@override
void initState() {
super.initState();

_orderRepository = OrderRepositoryImpl(
userId: userId,
);

_cartRepository = CartRepositoryImpl(
userId: userId,
);
}

Future<void> _placeOrder() async {
if (_isPlacingOrder || checkoutItems.isEmpty) {
return;
}

setState(() {
_isPlacingOrder = true;
});

try {
final order = OrderModel(
id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
productIds: checkoutItems
    .map((item) => item.product.id)
    .toList(),
totalAmount: total,
status: 'Paid',
createdAt: DateTime.now(),
);

// Save the order through the repository.
// The repository saves to SQLite first and then Firebase.
await _orderRepository.createOrder(order);

// Clear the cart after the order has been created.
await _cartRepository.clearCart();

if (!mounted) {
return;
}

Navigator.pushReplacement<void, void>(
context,
MaterialPageRoute<void>(
builder: (_) => OrderDetailsScreen(
order: order,
products: checkoutItems
    .map((item) => item.product)
    .toList(),
),
),
);
} catch (error) {
if (!mounted) {
return;
}

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
'Could not place order: $error',
),
),
);
} finally {
if (mounted) {
setState(() {
_isPlacingOrder = false;
});
}
}
}

@override
Widget build(BuildContext context) {
final currentItems = checkoutItems;

return Scaffold(
backgroundColor: MerchColors.background,
appBar: AppBar(
title: const Text('Checkout'),
backgroundColor: MerchColors.background,
foregroundColor: MerchColors.textPrimary,
),
body: currentItems.isEmpty
? const Center(
child: Text(
'Your cart is empty',
style: TextStyle(
color: MerchColors.textSecondary,
),
),
)
    : SingleChildScrollView(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'Order Summary',
style: TextStyle(
color: MerchColors.textPrimary,
fontSize: 20,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 16),
...currentItems.map(
(item) => _OrderItem(item: item),
),
const SizedBox(height: 24),
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: MerchColors.surface,
borderRadius: BorderRadius.circular(16),
),
child: Column(
children: [
_SummaryRow(
label: 'Subtotal',
value: subtotal,
),
const SizedBox(height: 12),
const Divider(
color: MerchColors.divider,
),
const SizedBox(height: 12),
Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,
children: [
const Text(
'Total',
style: TextStyle(
color: MerchColors.textPrimary,
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
PriceWidget(
price: total,
fontSize: 18,
),
],
),
],
),
),
const SizedBox(height: 24),
const Text(
'Payment',
style: TextStyle(
color: MerchColors.textPrimary,
fontSize: 20,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 12),
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: MerchColors.surface,
borderRadius: BorderRadius.circular(16),
border: Border.all(
color: MerchColors.primary,
),
),
child: const Row(
children: [
Icon(
Icons.payments_outlined,
color: MerchColors.primaryLight,
),
SizedBox(width: 12),
Expanded(
child: Text(
'Simulated payment',
style: TextStyle(
color: MerchColors.textPrimary,
fontSize: 16,
fontWeight: FontWeight.w600,
),
),
),
Icon(
Icons.check_circle,
color: MerchColors.primary,
),
],
),
),
const SizedBox(height: 32),
SizedBox(
width: double.infinity,
child: ElevatedButton(
onPressed:
_isPlacingOrder ? null : _placeOrder,
style: ElevatedButton.styleFrom(
backgroundColor: MerchColors.primary,
foregroundColor: Colors.white,
padding: const EdgeInsets.symmetric(
vertical: 16,
),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
),
child: _isPlacingOrder
? const SizedBox(
width: 22,
height: 22,
child: CircularProgressIndicator(
strokeWidth: 2,
color: Colors.white,
),
)
    : const Text(
'Place Order',
style: TextStyle(
fontSize: 16,
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

class _OrderItem extends StatelessWidget {
const _OrderItem({
required this.item,
});

final CartItemModel item;

@override
Widget build(BuildContext context) {
return Container(
margin: const EdgeInsets.only(bottom: 12),
padding: const EdgeInsets.all(14),
decoration: BoxDecoration(
color: MerchColors.surface,
borderRadius: BorderRadius.circular(14),
),
child: Row(
children: [
Container(
width: 64,
height: 64,
decoration: BoxDecoration(
color: MerchColors.surfaceLight,
borderRadius: BorderRadius.circular(12),
),
child: const Icon(
Icons.shopping_bag_outlined,
color: MerchColors.textSecondary,
),
),
const SizedBox(width: 12),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
item.product.name,
style: const TextStyle(
color: MerchColors.textPrimary,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 4),
Text(
'Quantity: ${item.quantity}',
style: const TextStyle(
color: MerchColors.textSecondary,
),
),
],
),
),
PriceWidget(
price: item.subtotal,
),
],
),
);
}
}

class _SummaryRow extends StatelessWidget {
const _SummaryRow({
required this.label,
required this.value,
});

final String label;
final double value;

@override
Widget build(BuildContext context) {
return Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
label,
style: const TextStyle(
color: MerchColors.textSecondary,
),
),
PriceWidget(
price: value,
),
],
);
}
}
