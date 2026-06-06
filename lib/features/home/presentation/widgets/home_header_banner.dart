import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/core/constants/app_colors.dart';

class HomeHeaderBanner extends StatelessWidget {
  const HomeHeaderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).width < 380 ? 224.0 : 240.0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF063423),
            Color(0xFF0B6E3E),
            Color(0xFF042418),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned.fill(child: _BannerGlowField()),
          Positioned(
            left: 16,
            top: 16,
            child: Builder(
              builder: (context) {
                return IconButton.filledTonal(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu_rounded),
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.12),
                  ),
                );
              },
            ),
          ),
          Positioned(
            right: 100,
            top: 70,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 176),
              child: const _BannerTitle(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerTitle extends StatelessWidget {
  const _BannerTitle();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Happy',
          style: textTheme.titleLarge,
        ),
        Text(
          'Independence',
          style: textTheme.titleLarge?.copyWith(color: AppColors.accent),
        ),
        Text(
          'Day - 14 August',
          style: textTheme.titleLarge,
        ),
      ],
    );
  }
}

class _BannerGlowField extends StatelessWidget {
  const _BannerGlowField();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BannerGlowPainter());
  }
}

class _BannerGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);
    final dotPaint = Paint();
    final points = [
      Offset(size.width * 0.42, size.height * 0.16),
      Offset(size.width * 0.62, size.height * 0.22),
      Offset(size.width * 0.52, size.height * 0.62),
      Offset(size.width * 0.76, size.height * 0.68),
      Offset(size.width * 0.26, size.height * 0.78),
    ];

    for (final point in points) {
      glowPaint.color = AppColors.accent.withValues(alpha: 0.36);
      canvas.drawCircle(point, 7, glowPaint);
      dotPaint.color = AppColors.accent.withValues(alpha: 0.9);
      canvas.drawCircle(point, 2.4, dotPaint);
    }

    dotPaint.color = Colors.white.withValues(alpha: 0.15);
    for (var index = 0; index < 34; index++) {
      final x = (index * 37 % size.width.toInt()).toDouble();
      final y = (index * 53 % size.height.toInt()).toDouble();
      canvas.drawCircle(Offset(x, y), index.isEven ? 1.6 : 1.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
