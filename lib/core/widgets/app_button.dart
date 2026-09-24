import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../constants/app_constants.dart';

/// Primary filled button used for the main action on a screen.
///
/// Handles loading and disabled states itself so screens don't need to
/// juggle spinner widgets — just pass [isLoading].
class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.fullWidth = true,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final canTap = enabled && !isLoading && onPressed != null;

    final child = isLoading
        ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: AppConstants.spaceSm),
              ],
              Text(text),
            ],
          );

    final button = ElevatedButton(
      onPressed: canTap ? onPressed : null,
      child: child,
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Secondary / low-emphasis button — outlined instead of filled.
///
/// Use for a screen's secondary action (e.g. "Cancel" next to a primary
/// "Save"), or for less important calls to action.
class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.fullWidth = true,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final canTap = enabled && !isLoading && onPressed != null;

    final child = isLoading
        ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: AppConstants.spaceSm),
              ],
              Text(text),
            ],
          );

    final button = OutlinedButton(
      onPressed: canTap ? onPressed : null,
      child: child,
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
