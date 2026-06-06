import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/core/constants/app_colors.dart';

class WallpaperTile extends StatelessWidget {
  const WallpaperTile({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 260),
        placeholder: (context, url) {
          return const ColoredBox(
            color: AppColors.deepGreen,
            child: Center(child: CircularProgressIndicator()),
          );
        },
        errorWidget: (context, url, error) {
          return const ColoredBox(
            color: AppColors.deepGreen,
            child: Center(
              child: Icon(Icons.broken_image_rounded, color: AppColors.accent),
            ),
          );
        },
      ),
    );
  }
}
