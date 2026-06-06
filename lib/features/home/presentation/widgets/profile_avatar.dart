import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/core/constants/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.radius = 22});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF425548), Color(0xFF123B2C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.nightlight_round,
              color: Colors.white,
              size: radius * 1.22,
            ),
            Transform.translate(
              offset: Offset(radius * 0.26, -radius * 0.14),
              child: Icon(
                Icons.star_rounded,
                color: AppColors.accent,
                size: radius * 0.58,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
