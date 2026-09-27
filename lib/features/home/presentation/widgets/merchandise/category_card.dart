import 'package:flutter/material.dart';
import '../../../../../models/merchandise/category_model.dart';
import '../../../../../app/theme/merchandise_colors.dart';

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
          color: selected ? MerchColors.primary.withOpacity(0.2) : MerchColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? MerchColors.primary : Colors.transparent, width: 1.5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, color: selected ? MerchColors.primaryLight : MerchColors.textSecondary, size: 28),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: TextStyle(
                color: selected ? MerchColors.textPrimary : MerchColors.textSecondary,
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
