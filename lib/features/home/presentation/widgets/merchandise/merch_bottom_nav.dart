import 'package:flutter/material.dart';
import '../../../../../app/theme/merchandise_colors.dart';

class MerchBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MerchBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(Icons.storefront_outlined, Icons.storefront),
      _NavItem(Icons.grid_view_outlined, Icons.grid_view),
      _NavItem(Icons.shopping_cart_outlined, Icons.shopping_cart),
      _NavItem(Icons.favorite_border, Icons.favorite),
      _NavItem(Icons.receipt_long_outlined, Icons.receipt_long),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final selected = i == currentIndex;
          final item = items[i];
          return GestureDetector(
            onTap: () => onTap(i),
            child: Icon(
              selected ? item.filled : item.outline,
              color: selected ? MerchColors.primary : Theme.of(context).textTheme.bodyMedium?.color,
              size: 24,
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData outline;
  final IconData filled;
  _NavItem(this.outline, this.filled);
}
