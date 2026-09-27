import 'package:flutter/material.dart';
import '../../../../../app/theme/merchandise_colors.dart';

class EmptyMerchandiseState extends StatelessWidget {
  final IconData icon;
  final String message;
  const EmptyMerchandiseState({super.key, this.icon = Icons.shopping_bag_outlined, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: MerchColors.textSecondary),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: MerchColors.textSecondary, fontSize: 14)),
        ],
      ),
    );
  }
}
