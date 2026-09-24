import 'package:flutter/material.dart';

/// Central color palette for the app.
///
/// Matches the team's design system exactly: primary `#7C3AED`, dark-navy
/// surface `#0F172A`, near-white text `#F8FAFC`, muted purple `#9E57E6`,
/// success `#22C55E`, error `#EF4444`. The product is designed dark-first
/// (every mockup screen uses the dark palette) — see [AppTheme.dark] and
/// `App`'s `themeMode`.
///
/// Keep this as the single source of truth for color values — widgets and
/// [AppTheme] should reference these constants rather than hard-coding
/// colors inline.
class AppColors {
  const AppColors._();

  // --- Brand (design system swatches) ---
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryMuted = Color(0xFF9E57E6);
  static const Color primaryDark = Color(0xFF6D28D9);
  static const Color primaryLight = Color(0xFFEDE4FC);

  static const Color secondary = Color(0xFF0F172A);

  // --- Dark theme surfaces (primary look — matches the mockups) ---
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1A2236);
  static const Color surfaceDarkElevated = Color(0xFF212B42);
  static const Color borderDark = Color(0xFF2E3852);

  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFFA3ADC2);
  static const Color textDisabledDark = Color(0xFF6B7590);

  // --- Light theme surfaces (secondary — system-light fallback) ---
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E5EC);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF63666D);
  static const Color textDisabled = Color(0xFFA0A3A8);

  // --- Semantic (design system swatches) ---
  static const Color success = Color(0xFF22C55E);
  static const Color successBg = Color(0xFF163224);

  static const Color warning = Color(0xFFEAB308);
  static const Color warningBg = Color(0xFF332B12);

  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFF351A1A);

  static const Color info = Color(0xFF7C3AED);
  static const Color infoBg = Color(0xFF241A3D);

  static const Color neutralBg = Color(0xFF212B42);
  static const Color neutralText = Color(0xFFA3ADC2);
}
