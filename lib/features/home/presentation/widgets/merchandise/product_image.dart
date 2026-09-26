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
      return _buildNoImage();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,

        // Show "No image available" while the image is loading.
        loadingBuilder: (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
            ) {
          if (loadingProgress == null) {
            return child;
          }

          return _buildLoading();
        },

        // Show "No image available" if the online image fails.
        errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
            ) {
          return _buildNoImage();
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      width: width,
      height: height,
      color: MerchColors.surfaceLight,
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 32,
            color: MerchColors.textSecondary,
          ),
          SizedBox(height: 8),
          Text(
            'No image available',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MerchColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoImage() {
    return Container(
      width: width,
      height: height,
      color: MerchColors.surfaceLight,
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 36,
            color: MerchColors.textSecondary,
          ),
          SizedBox(height: 8),
          Text(
            'No image available',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MerchColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}