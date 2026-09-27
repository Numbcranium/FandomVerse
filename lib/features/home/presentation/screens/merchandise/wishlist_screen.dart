import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../app/theme/merchandise_colors.dart';
import '../../../../../models/merchandise/cart_item_model.dart';
import '../../../../../models/merchandise/wishlist_item_model.dart';
import '../../../../auth/data/repositories/merchandise/cart_repository.dart';
import '../../../../auth/data/repositories/merchandise/wishlist_repository.dart';
import '../../widgets/merchandise/wishlist_item_tile.dart';
import 'cart_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late final WishlistRepository _wishlistRepository;
  late final CartRepository _cartRepository;

  List<WishlistItemModel> items = [];

  bool _isLoading = true;
  String? _errorMessage;

  String get userId {
    return FirebaseAuth.instance.currentUser?.uid ?? 'guest';
  }

  @override
  void initState() {
    super.initState();

    _wishlistRepository = WishlistRepositoryImpl(
      userId: userId,
    );

    _cartRepository = CartRepositoryImpl(
      userId: userId,
    );

    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    try {
      final wishlist =
      await _wishlistRepository.getWishlist();

      if (!mounted) {
        return;
      }

      setState(() {
        items = wishlist;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Could not load wishlist.';
      });
    }
  }

  Future<void> _removeFromWishlist(
      WishlistItemModel item,
      ) async {
    try {
      await _wishlistRepository.removeFromWishlist(
        item.id,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        items.removeWhere(
              (wishlistItem) => wishlistItem.id == item.id,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${item.product.name} removed from wishlist',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not remove item from wishlist.',
          ),
        ),
      );
    }
  }

  Future<void> _moveToCart(
      WishlistItemModel item,
      ) async {
    try {
      final existingItems =
      await _cartRepository.getCartItems();

      final existingIndex = existingItems.indexWhere(
            (cartItem) =>
        cartItem.product.id == item.product.id,
      );

      if (existingIndex != -1) {
        final existingItem =
        existingItems[existingIndex];

        await _cartRepository.updateCartItem(
          existingItem.copyWith(
            quantity: existingItem.quantity + 1,
          ),
        );
      } else {
        final cartItem = CartItemModel(
          id:
          '${item.product.id}_${DateTime.now().millisecondsSinceEpoch}',
          product: item.product,
          quantity: 1,
        );

        await _cartRepository.addToCart(cartItem);
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${item.product.name} added to cart',
          ),
          backgroundColor: MerchColors.success,
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const CartScreen(),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not add product to cart.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MerchColors.background,
      appBar: AppBar(
        backgroundColor: MerchColors.background,
        foregroundColor: MerchColors.textPrimary,
        title: const Text('Wishlist'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: MerchColors.primary,
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: MerchColors.textSecondary,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: MerchColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });

                  _loadWishlist();
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              color: MerchColors.textSecondary,
              size: 60,
            ),
            SizedBox(height: 16),
            Text(
              'Your wishlist is empty',
              style: TextStyle(
                color: MerchColors.textSecondary,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Save your favourite anime products here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MerchColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return WishlistItemTile(
          item: item,
          onMoveToCart: () {
            _moveToCart(item);
          },
          onRemove: () {
            _removeFromWishlist(item);
          },
        );
      },
    );
  }
}