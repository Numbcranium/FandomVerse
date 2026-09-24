import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Cached network image with a consistent loading/error fallback.
///
/// Use the default constructor for rectangular images (cards, banners) and
/// [AppNetworkImage.avatar] for circular profile photos with an
/// initials/icon fallback.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
    super.key,
  })  : _isAvatar = false,
        _radius = null,
        _fallbackText = null;

  const AppNetworkImage.avatar({
    required this.imageUrl,
    required double radius,
    String? fallbackText,
    super.key,
  })  : _isAvatar = true,
        _radius = radius,
        _fallbackText = fallbackText,
        width = null,
        height = null,
        borderRadius = null,
        fit = BoxFit.cover;

  final String? imageUrl;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  final bool _isAvatar;
  final double? _radius;
  final String? _fallbackText;

  @override
  Widget build(BuildContext context) {
    if (_isAvatar) {
      final radius = _radius!;
      if (imageUrl == null || imageUrl!.isEmpty) {
        return CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.primaryLight,
          child: Text(
            (_fallbackText != null && _fallbackText!.isNotEmpty)
                ? _fallbackText![0].toUpperCase()
                : '?',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: radius * 0.7,
            ),
          ),
        );
      }
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.primaryLight,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl!,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(
              strokeWidth: 2,
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.person,
              color: AppColors.primary,
              size: radius,
            ),
          ),
        ),
      );
    }

    final image = (imageUrl == null || imageUrl!.isEmpty)
        ? Container(
            width: width,
            height: height,
            color: AppColors.neutralBg,
            alignment: Alignment.center,
            child: const Icon(Icons.image_outlined, color: AppColors.textDisabled),
          )
        : CachedNetworkImage(
            imageUrl: imageUrl!,
            width: width,
            height: height,
            fit: fit,
            placeholder: (context, url) => Container(
              width: width,
              height: height,
              color: AppColors.neutralBg,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (context, url, error) => Container(
              width: width,
              height: height,
              color: AppColors.neutralBg,
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image_outlined, color: AppColors.textDisabled),
            ),
          );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }
}
