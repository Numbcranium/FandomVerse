import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:techwiz7_starter/app/theme/merchandise_colors.dart';

import 'package:techwiz7_starter/models/merchandise/cart_item_model.dart';
import '../../../../auth/data/repositories/merchandise/cart_repository.dart';
import '../../widgets/merchandise/cart_item_tile.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final CartRepository _cartRepository;

  List<CartItemModel> cartItems = [];
  bool isLoading = true;

  String get userId {
    return FirebaseAuth.instance.currentUser?.uid ?? 'guest';
  }

  @override
  void initState() {
    super.initState();

    _cartRepository = CartRepositoryImpl(
      userId: userId,
    );

    _loadCart();
  }

  Future<void> _loadCart() async {
    try {
      final items = await _cartRepository.getCartItems();

      if (!mounted) {
        return;
      }

      setState(() {
        cartItems = items;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  double get total {
    return cartItems.fold<double>(
      0,
          (sum, item) => sum + item.subtotal,
    );
  }

  Future<void> _updateQuantity(
      CartItemModel item,
      int quantity,
      ) async {
    final updatedItem = item.copyWith(
      quantity: quantity,
    );

    await _cartRepository.updateCartItem(updatedItem);

    if (!mounted) {
      return;
    }

    setState(() {
      final index = cartItems.indexWhere(
            (cartItem) => cartItem.id == item.id,
      );

      if (index != -1) {
        cartItems[index] = updatedItem;
      }
    });
  }

  Future<void> _removeItem(String itemId) async {
    await _cartRepository.removeFromCart(itemId);

    if (!mounted) {
      return;
    }

    setState(() {
      cartItems.removeWhere(
            (item) => item.id == itemId,
      );
    });
  }

  Future<void> _clearCart() async {
    await _cartRepository.clearCart();

    if (!mounted) {
      return;
    }

    setState(() {
      cartItems.clear();
    });
  }

  void _openCheckout() {
    if (cartItems.isEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          items: cartItems,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MerchColors.background,
      appBar: AppBar(
        backgroundColor: MerchColors.background,
        foregroundColor: MerchColors.textPrimary,
        title: const Text('Cart'),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              onPressed: _clearCart,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear cart',
            ),
        ],
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: MerchColors.primary,
        ),
      )
          : cartItems.isEmpty
          ? const Center(
        child: Text(
          'Your cart is empty',
          style: TextStyle(
            color: MerchColors.textSecondary,
            fontSize: 16,
          ),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];

                return CartItemTile(
                  item: item,
                  onQuantityChanged: (quantity) {
                    _updateQuantity(
                      item,
                      quantity,
                    );
                  },
                  onRemove: () {
                    _removeItem(item.id);
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: MerchColors.surface,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        color: MerchColors.textSecondary,
                      ),
                    ),
                    Text(
                      '₦${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: MerchColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _openCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MerchColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}