import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../constants/app_constants.dart';

enum StatusBadgeType { success, warning, error, info, neutral }

/// Small pill/chip used to show a status word (e.g. "Active", "Pending",
/// "Read", "Unread") with a semantic color.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.label,
    this.type = StatusBadgeType.neutral,
    super.key,
  });

  final String label;
  final StatusBadgeType type;

  (Color, Color) get _colors {
    switch (type) {
      case StatusBadgeType.success:
        return (AppColors.success, AppColors.successBg);
      case StatusBadgeType.warning:
        return (AppColors.warning, AppColors.warningBg);
      case StatusBadgeType.error:
        return (AppColors.error, AppColors.errorBg);
      case StatusBadgeType.info:
        return (AppColors.info, AppColors.infoBg);
      case StatusBadgeType.neutral:
        return (AppColors.neutralText, AppColors.neutralBg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spaceSm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppConstants.radiusPill),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: fg,
              fontSize: 12,
            ),
      ),
    );
  }
}
