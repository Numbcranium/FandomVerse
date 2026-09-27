import 'package:flutter/material.dart';

/// Shared color palette for the Merchandise & Wishlist module.
/// Keep every screen/widget pulling from here so the module stays
/// visually consistent with the mockups (dark navy/purple theme).
class MerchColors {
  static const background = Color(0xFF0F0D1C);
  static const surface = Color(0xFF1A1730);
  static const surfaceLight = Color(0xFF25213F);

  static const primary = Color(0xFF7C5CFC);
  static const primaryLight = Color(0xFFA48CFE);

  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFA9A5C2);

  static const success = Color(0xFF34D399);
  static const rating = Color(0xFFFBBF24);

  // Divider/border color used by checkout, order details, cards, etc.
  static const divider = Color(0xFF393451);
}