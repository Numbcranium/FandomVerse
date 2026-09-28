import 'package:flutter/material.dart';

import '../../../../../app/theme/merchandise_colors.dart';
import '../../../../../models/merchandise/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;
  final bool selected;

  const CategoryCard({super.key, required this.category, required this.onTap, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? MerchColors.primary.withOpacity(0.2) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? MerchColors.primary : Colors.transparent, width: 1.5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, color: selected ? MerchColors.primaryLight : Theme.of(context).textTheme.bodyMedium?.color, size: 28),
            SizedBox(height: 8),
            Text(
              category.name,
              style: TextStyle(
                color: selected ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
