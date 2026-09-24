import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized text styles built on Poppins (design system typeface —
/// Bold/Semibold/Regular), layered on Material 3 typography.
///
/// Use these instead of constructing [TextStyle]s inline so font sizes and
/// weights stay consistent across the app. Colors default to the dark
/// theme's text color since that's the app's primary look — screens on
/// the light theme get the right color automatically via [AppTheme],
/// which applies `textTheme.apply(...)`.
class AppTextStyles {
  const AppTextStyles._();

  static TextStyle _poppins({
    required double fontSize,
    required FontWeight fontWeight,
    Color color = AppColors.textPrimaryDark,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle get displayLarge => _poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get headlineMedium => _poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  static TextStyle get titleLarge => _poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get titleMedium => _poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get bodyLarge => _poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle get bodyMedium => _poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle get bodySmall => _poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondaryDark,
        height: 1.4,
      );

  static TextStyle get labelLarge => _poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  static TextStyle get button => _poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );

  static TextStyle get caption => _poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondaryDark,
      );
}
