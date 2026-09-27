import 'package:flutter/material.dart';

import '../../../../../app/theme/merchandise_colors.dart';
import '../../../../../models/merchandise/wishlist_item_model.dart';
import 'price_widget.dart';
import 'product_image.dart';

class WishlistItemTile extends StatelessWidget {
  final WishlistItemModel item;
  final VoidCallback onMoveToCart;
  final VoidCallback onRemove;
  final VoidCallback? onTap;

  const WishlistItemTile({
    super.key,
    required this.item,
    required this.onMoveToCart,
    required this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: MerchColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: ProductImage(
                imageUrl: item.product.imageUrl,
                borderRadius: 0,
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: onRemove,
                child: const CircleAvatar(
                  radius: 13,
                  backgroundColor: Colors.black45,
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.black87,
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        PriceWidget(
                          price: item.product.price,
                          fontSize: 12,
                        ),
                        GestureDetector(
                          onTap: onMoveToCart,
                          child: const Icon(
                            Icons.add_shopping_cart,
                            size: 16,
                            color: MerchColors.primaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}