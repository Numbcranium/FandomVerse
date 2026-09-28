import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Static helpers for the app's standard dialogs.
///
/// Keeps dialog-building code out of screens — call `AppDialog.confirm(...)`
/// etc. instead of constructing a [showDialog] + [AlertDialog] pair inline.
class AppDialog {
  const AppDialog._();

  /// Shows a confirm/cancel dialog and returns `true` if the user confirmed.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: isDestructive
                ? TextButton.styleFrom(foregroundColor: AppColors.error)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Shows a single-button informational dialog.
  static Future<void> info(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Shows a non-dismissible loading dialog. Call
  /// `Navigator.of(context, rootNavigator: true).pop()` to dismiss it.
  static Future<void> loading(BuildContext context, {String? message}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(strokeWidth: 2.5),
              SizedBox(width: 20),
              Flexible(child: Text(message ?? 'Please wait…')),
            ],
          ),
        ),
      ),
    );
  }
}
