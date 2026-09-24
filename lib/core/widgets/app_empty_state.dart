import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../constants/app_constants.dart';
import 'app_button.dart';

/// Standard "nothing here yet" state.
///
/// Use for the "empty" branch of a screen's Loading/Success/Empty/Error
/// state — e.g. no notifications yet, no search results, empty list.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.title,
    this.actionText,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String? title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.textDisabled),
            const SizedBox(height: AppConstants.spaceMd),
            if (title != null) ...[
              Text(title!, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppConstants.spaceSm),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: AppConstants.spaceLg),
              AppButton(
                text: actionText!,
                onPressed: onAction,
                fullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
