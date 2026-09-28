import 'package:flutter/material.dart';

import '../../../../../app/theme/merchandise_colors.dart';

class ProductImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 14,
    this.fit = BoxFit.cover,
  });

  bool get _hasImage {
    return imageUrl != null && imageUrl!.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasImage) {
      return _buildNoImage(context);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,

        // Keep the image loading smoothly.
        loadingBuilder: (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
            ) {
          if (loadingProgress == null) {
            return child;
          }

          return _buildLoading(context);
        },

        // Only show "No image available" when the URL actually fails.
        errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
            ) {
          debugPrint('Product image failed to load.');
          debugPrint('Image URL: $imageUrl');
          debugPrint('Error: $error');

          return _buildNoImage(context);
        },
      ),
    );
  }

  // =====================================================
  // LOADING
  // =====================================================

  Widget _buildLoading(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).cardColor,
      alignment: Alignment.center,
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
    );
  }

  // =====================================================
  // NO IMAGE
  // =====================================================

  Widget _buildNoImage(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).cardColor,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 36,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          SizedBox(height: 8),
          Text(
            'No image available',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}