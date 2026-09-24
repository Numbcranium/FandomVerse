import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Builds the app's [ThemeData] for dark and light mode.
///
/// The product is designed dark-first — every screen in the team's
/// mockups uses the dark navy/purple palette — so [dark] is the primary,
/// hand-built definition and [light] is derived from it by swapping
/// surface/text colors, kept around as a system-light fallback.
///
/// Everything a screen needs — button styles, input styles, card styles,
/// app bar style — is defined here once so individual widgets never need
/// to hard-code colors or radii.
class AppTheme {
  const AppTheme._();

  static OutlineInputBorder _inputBorder(Color borderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      borderSide: BorderSide(color: borderColor),
    );
  }

  static final RoundedRectangleBorder _buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
  );

  static ThemeData get dark {
    final inputBorder = _inputBorder(AppColors.borderDark);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      secondary: AppColors.primaryMuted,
      error: AppColors.error,
      surface: AppColors.surfaceDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: AppTextStyles.titleLarge,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: AppConstants.elevationNone,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          side: const BorderSide(color: AppColors.borderDark),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.textDisabledDark,
          minimumSize: const Size.fromHeight(52),
          textStyle: AppTextStyles.button,
          shape: _buttonShape,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryMuted,
          minimumSize: const Size.fromHeight(52),
          textStyle: AppTextStyles.button,
          shape: _buttonShape,
          side: const BorderSide(color: AppColors.primaryMuted),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryMuted,
          textStyle: AppTextStyles.button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceMd,
          vertical: AppConstants.spaceMd,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: AppTextStyles.bodyMedium,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textDisabledDark,
        ),
        errorStyle: AppTextStyles.caption.copyWith(color: AppColors.error),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceDarkElevated,
        contentTextStyle: AppTextStyles.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceDarkElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
        titleTextStyle: AppTextStyles.titleLarge,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),
    );
  }

  /// System-light fallback. Not what the mockups show — kept so the app
  /// doesn't look broken for a user/device forcing light mode.
  static ThemeData get light {
    final base = dark;
    final inputBorder = _inputBorder(AppColors.border);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.primaryMuted,
      error: AppColors.error,
      surface: AppColors.surface,
    );

    return base.copyWith(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: base.cardTheme.copyWith(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        fillColor: AppColors.surface,
        border: inputBorder,
        enabledBorder: inputBorder,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textDisabled,
        ),
      ),
      dividerTheme: base.dividerTheme.copyWith(color: AppColors.border),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        backgroundColor: AppColors.surface,
        unselectedItemColor: AppColors.textSecondary,
      ),
      snackBarTheme: base.snackBarTheme.copyWith(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
      ),
      dialogTheme: base.dialogTheme.copyWith(backgroundColor: AppColors.surface),
    );
  }
}
