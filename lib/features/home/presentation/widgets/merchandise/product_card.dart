import 'package:flutter/material.dart';

import '../../../../../app/theme/merchandise_colors.dart';
import '../../../../../models/merchandise/product_model.dart';
import 'price_widget.dart';
import 'product_image.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback? onWishlistTap;
  final bool isWishlisted;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onWishlistTap,
    this.isWishlisted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PRODUCT IMAGE
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ProductImage(
                      imageUrl: product.imageUrl,
                      borderRadius: 0,
                    ),
                  ),

                  // WISHLIST BUTTON
                  if (onWishlistTap != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onWishlistTap,
                          borderRadius: BorderRadius.circular(20),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            child: Icon(
                              isWishlisted
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 17,
                              color: isWishlisted
                                  ? MerchColors.primary
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // PRODUCT DETAILS
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                  PriceWidget(
                    price: product.price,
                    fontSize: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}