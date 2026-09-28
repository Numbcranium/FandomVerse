import 'package:flutter/material.dart';

import '../../../../../app/theme/merchandise_colors.dart';

class PriceWidget extends StatelessWidget {
  final double price;
  final double fontSize;

  const PriceWidget({
    super.key,
    required this.price,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '₦${price.toStringAsFixed(0)}',
      style: TextStyle(
        color: MerchColors.primaryLight,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}