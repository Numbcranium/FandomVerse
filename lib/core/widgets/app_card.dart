import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Standard rounded, bordered content container.
///
/// Wraps [Card] with the app's default padding and an optional [onTap] so
/// screens don't need to reach for [InkWell] + [Card] every time.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppConstants.spaceMd),
    this.margin,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shape = (theme.cardTheme.shape as RoundedRectangleBorder?) ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        );

    return Card(
      margin: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: shape.borderRadius.resolve(Directionality.of(context)),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
