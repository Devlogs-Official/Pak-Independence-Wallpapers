import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/core/constants/app_colors.dart';
import 'package:pakistani_independence_wallpapers/features/home/presentation/models/category_ui_model.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  final CategoryUiModel category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.18),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  category.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const ColoredBox(
                      color: AppColors.deepGreen,
                      child: Center(
                        child: Icon(
                          Icons.image_rounded,
                          color: AppColors.accent,
                          size: 34,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.54),
                        Colors.black.withValues(alpha: 0.08),
                        Colors.black.withValues(alpha: 0.38),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                bottom: 14,
                right: 14,
                child: Text(
                  category.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.72),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
