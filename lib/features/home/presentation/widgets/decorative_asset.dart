import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/core/constants/app_colors.dart';

class DecorativeAsset extends StatelessWidget {
  const DecorativeAsset({
    super.key,
    required this.imagePath,
    required this.icon,
    this.fit = BoxFit.contain,
  });

  final String imagePath;
  final IconData icon;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
          ),
          child: Center(
            child: Icon(
              icon,
              color: AppColors.accent,
              size: 34,
            ),
          ),
        );
      },
    );
  }
}
