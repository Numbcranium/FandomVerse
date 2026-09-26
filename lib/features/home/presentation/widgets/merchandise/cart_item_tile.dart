import 'package:flutter/material.dart';

import '../../../../../app/theme/merchandise_colors.dart';
import '../../../../../models/merchandise/cart_item_model.dart';
import 'price_widget.dart';
import 'product_image.dart';
import 'quantity_selector.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: MerchColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: ProductImage(
              imageUrl: item.product.imageUrl,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MerchColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                PriceWidget(
                  price: item.subtotal,
                  fontSize: 13,
                ),
              ],
            ),
          ),
          QuantitySelector(
            quantity: item.quantity,
            onChanged: onQuantityChanged,
          ),
          IconButton(
            icon: const Icon(
              Icons.close,
              size: 18,
              color: MerchColors.textSecondary,
            ),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}