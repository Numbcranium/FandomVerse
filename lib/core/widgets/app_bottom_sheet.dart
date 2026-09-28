import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Static helper for showing a standard, rounded-top modal bottom sheet
/// with a drag handle — consistent across the app instead of every screen
/// calling [showModalBottomSheet] with its own shape.
class AppBottomSheet {
  const AppBottomSheet._();

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusLg),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppConstants.spaceMd,
            AppConstants.spaceSm,
            AppConstants.spaceMd,
            AppConstants.spaceLg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppConstants.spaceMd),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                  ),
                ),
              ),
              if (title != null) ...[
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: AppConstants.spaceMd),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}
