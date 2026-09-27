import 'package:flutter/material.dart';

import '../../../../../app/theme/merchandise_colors.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final int min;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MerchColors.surfaceLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _button(
            Icons.remove,
                () {
              if (quantity > min) {
                onChanged(quantity - 1);
              }
            },
          ),
          SizedBox(
            width: 28,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: MerchColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _button(
            Icons.add,
                () => onChanged(quantity + 1),
          ),
        ],
      ),
    );
  }

  Widget _button(
      IconData icon,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 16,
          color: MerchColors.textPrimary,
        ),
      ),
    );
  }
}