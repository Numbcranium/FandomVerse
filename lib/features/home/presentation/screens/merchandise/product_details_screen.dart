import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../app/theme/merchandise_colors.dart';
import '../../../../../models/merchandise/cart_item_model.dart';
import '../../../../../models/merchandise/product_model.dart';
import '../../../../../models/merchandise/wishlist_item_model.dart';
import '../../../../auth/data/repositories/merchandise/cart_repository.dart';
import '../../../../auth/data/repositories/merchandise/wishlist_repository.dart';
import '../../widgets/merchandise/product_image.dart';
import 'cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState
    extends State<ProductDetailsScreen> {
  late final CartRepository _cartRepository;
  late final WishlistRepository _wishlistRepository;

  bool _isAddingToCart = false;
  bool _isInWishlist = false;
  bool _isUpdatingWishlist = false;

  String get userId {
    return FirebaseAuth.instance.currentUser?.uid ?? 'guest';
  }

  @override
  void initState() {
    super.initState();

    _cartRepository = CartRepositoryImpl(
      userId: userId,
    );

    _wishlistRepository = WishlistRepositoryImpl(
      userId: userId,
    );

    _checkWishlistStatus();
  }

  Future<void> _checkWishlistStatus() async {
    try {
      final isSaved =
      await _wishlistRepository.isInWishlist(
        widget.product.id,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isInWishlist = isSaved;
      });
    } catch (_) {
      // Keep the default wishlist state if loading fails.
    }
  }

  Future<void> _toggleWishlist() async {
    if (_isUpdatingWishlist) {
      return;
    }

    setState(() {
      _isUpdatingWishlist = true;
    });

    try {
      if (_isInWishlist) {
        final wishlist =
        await _wishlistRepository.getWishlist();

        final existingItem = wishlist.cast<WishlistItemModel?>().firstWhere(
              (item) =>
          item?.product.id == widget.product.id,
          orElse: () => null,
        );

        if (existingItem != null) {
          await _wishlistRepository.removeFromWishlist(
            existingItem.id,
          );
        }
      } else {
        final wishlistItem = WishlistItemModel(
          id:
          '${widget.product.id}_${DateTime.now().millisecondsSinceEpoch}',
          product: widget.product,
          savedAt: DateTime.now(),
        );

        await _wishlistRepository.addToWishlist(
          wishlistItem,
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _isInWishlist = !_isInWishlist;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isInWishlist
                ? '${widget.product.name} added to wishlist'
                : '${widget.product.name} removed from wishlist',
          ),
          backgroundColor: _isInWishlist
              ? MerchColors.success
              : MerchColors.surfaceLight,
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not update wishlist.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingWishlist = false;
        });
      }
    }
  }

  Future<void> _addToCart() async {
    if (_isAddingToCart) {
      return;
    }

    setState(() {
      _isAddingToCart = true;
    });

    try {
      final existingItems =
      await _cartRepository.getCartItems();

      final existingIndex = existingItems.indexWhere(
            (item) => item.product.id == widget.product.id,
      );

      if (existingIndex != -1) {
        final existingItem = existingItems[existingIndex];

        await _cartRepository.updateCartItem(
          existingItem.copyWith(
            quantity: existingItem.quantity + 1,
          ),
        );
      } else {
        final cartItem = CartItemModel(
          id:
          '${widget.product.id}_${DateTime.now().millisecondsSinceEpoch}',
          product: widget.product,
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
            '${widget.product.name} added to cart',
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
        SnackBar(
          content: Text(
            'Could not add product to cart: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MerchColors.background,
      appBar: AppBar(
        backgroundColor: MerchColors.background,
        foregroundColor: MerchColors.textPrimary,
        title: const Text('Product Details'),
        actions: [
          IconButton(
            onPressed:
            _isUpdatingWishlist ? null : _toggleWishlist,
            tooltip: _isInWishlist
                ? 'Remove from wishlist'
                : 'Add to wishlist',
            icon: _isUpdatingWishlist
                ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: MerchColors.primaryLight,
              ),
            )
                : Icon(
              _isInWishlist
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: _isInWishlist
                  ? Colors.redAccent
                  : MerchColors.textPrimary,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: ProductImage(
                imageUrl: widget.product.imageUrl,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              widget.product.name,
              style: const TextStyle(
                color: MerchColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '₦${widget.product.price.toStringAsFixed(0)}',
              style: const TextStyle(
                color: MerchColors.primaryLight,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: MerchColors.surface,
                borderRadius:
                BorderRadius.circular(10),
              ),
              child: Text(
                widget.product.category,
                style: const TextStyle(
                  color: MerchColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Product Information',
              style: TextStyle(
                color: MerchColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Official FandomVerse merchandise available for fans.',
              style: TextStyle(
                color: MerchColors.textSecondary,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                _isAddingToCart
                    ? null
                    : _addToCart,
                icon: _isAddingToCart
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(
                  Icons.shopping_cart,
                ),
                label: Text(
                  _isAddingToCart
                      ? 'Adding...'
                      : 'Add to Cart',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}