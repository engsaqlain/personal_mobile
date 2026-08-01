import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

// Smart image widget that works for both local dummy assets (asset paths)
// and real Firestore data (network URLs) - so we don't crash when
// real data replaces dummy data.
class ProductImage extends StatelessWidget {
  final List<String> images;
  final BoxFit fit;

  const ProductImage({super.key, required this.images, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    // If no images at all, show a placeholder icon instead of crashing
    if (images.isEmpty) {
      return Container(
        color: AppColors.softGray,
        child: const Icon(Icons.image_not_supported_outlined, color: AppColors.lightGray, size: 40),
      );
    }

    final String imagePath = images.first;

    // Network images start with "http" (real Firestore data);
    // anything else is treated as a local asset (our dummy data)
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: fit,
        // Shows a loading spinner while the network image downloads
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
        // Shows a fallback icon if the URL is broken/unreachable
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.softGray,
          child: const Icon(Icons.broken_image_outlined, color: AppColors.lightGray, size: 40),
        ),
      );
    } else {
      return Image.asset(
        imagePath,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.softGray,
          child: const Icon(Icons.broken_image_outlined, color: AppColors.lightGray, size: 40),
        ),
      );
    }
  }
}