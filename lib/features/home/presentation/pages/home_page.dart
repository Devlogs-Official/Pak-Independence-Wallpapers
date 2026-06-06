import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/core/constants/app_assets.dart';
import 'package:pakistani_independence_wallpapers/core/constants/app_colors.dart';
import 'package:pakistani_independence_wallpapers/core/utils/responsive_values.dart';
import 'package:pakistani_independence_wallpapers/features/home/presentation/models/category_ui_model.dart';
import 'package:pakistani_independence_wallpapers/features/home/presentation/widgets/category_grid.dart';
import 'package:pakistani_independence_wallpapers/features/home/presentation/widgets/home_header_banner.dart';
import 'package:pakistani_independence_wallpapers/features/home/presentation/widgets/independence_drawer.dart';
import 'package:pakistani_independence_wallpapers/features/home/presentation/widgets/section_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<CategoryUiModel> _categories = [
    CategoryUiModel(
      id: 1,
      title: 'Independence Wallpapers',
      imagePath: AppAssets.independence,
    ),
    CategoryUiModel(
      id: 2,
      title: 'Live Wallpapers',
      imagePath: AppAssets.liveIndependence,
    ),
    CategoryUiModel(
      id: 3,
      title: 'Greeting Cards',
      imagePath: AppAssets.greetingCard,
    ),
    CategoryUiModel(id: 0, title: 'Favorites', imagePath: AppAssets.favorites),
  ];

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveValues.horizontalPadding(context);

    return Scaffold(
      drawer: const IndependenceDrawer(),
      body: Stack(
        children: [
          const Positioned.fill(child: _HomeBackground()),
          SafeArea(
            child: Center(
              child: SizedBox(
                width: ResponsiveValues.contentWidth(context),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(padding, 12, padding, 32),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          const SizedBox(height: 10),
                          const HomeHeaderBanner(),
                          const SizedBox(height: 26),
                          const SectionHeader(title: 'Explore Categories'),
                          const SizedBox(height: 22),
                          const CategoryGrid(categories: _categories),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeBackground extends StatelessWidget {
  const _HomeBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.15,
          colors: [
            Color(0xFF0E5C39),
            AppColors.background,
            Color(0xFF0E5C39),
            // Color(0xFF03110D),
          ],
          stops: [0, 0.48, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -80,
            top: 120,
            child: _Glow(
              size: 190,
              color: AppColors.primary.withValues(alpha: 0.22),
            ),
          ),
          Positioned(
            right: -70,
            bottom: 160,
            child: _Glow(
              size: 180,
              color: AppColors.accent.withValues(alpha: 0.1),
            ),
          ),
          Positioned.fill(child: CustomPaint(painter: _ConfettiPainter())),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: size * 0.46,
            spreadRadius: size * 0.18,
          ),
        ],
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final colors = [
      AppColors.primary.withValues(alpha: 0.46),
      AppColors.accent.withValues(alpha: 0.34),
      Colors.white.withValues(alpha: 0.15),
    ];

    for (var index = 0; index < 36; index++) {
      final x = (index * 83 % size.width.toInt()).toDouble();
      final y = (index * 127 % size.height.toInt()).toDouble();
      paint.color = colors[index % colors.length];
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate((index % 8) * 0.22);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: 12, height: 5),
          const Radius.circular(4),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
