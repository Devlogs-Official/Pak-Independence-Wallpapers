import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/core/constants/app_assets.dart';
import 'package:pakistani_independence_wallpapers/features/home/presentation/pages/home_page.dart';
import 'package:provider/provider.dart';
import '../category/presentation/providers/wallpaper_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgFadeController;
  late final Animation<double> _bgFadeAnimation;

  late final AnimationController _textController;
  late final Animation<double> _textFadeAnimation;
  late final Animation<Offset> _textSlideAnimation;

  late final AnimationController _shimmerController;

  late final AnimationController _starsController;

  @override
  void initState() {
    super.initState();

    // Background fade
    _bgFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..forward();
    _bgFadeAnimation = CurvedAnimation(
      parent: _bgFadeController,
      curve: Curves.easeOut,
    );

    // Text entrance animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _textFadeAnimation = CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _textController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    // Shimmer for progress bar
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Stars twinkling
    _starsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Delay text entrance slightly
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _textController.forward();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  @override
  void dispose() {
    _bgFadeController.dispose();
    _textController.dispose();
    _shimmerController.dispose();
    _starsController.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final provider = context.read<WallpaperProvider>();
    await Future.wait([
      Future<void>.delayed(const Duration(seconds: 3)),
      provider.preloadInitialWallpapers().timeout(
        const Duration(milliseconds: 2500),
        onTimeout: () {},
      ),
    ]);

    if (!mounted) return;

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with fade
          FadeTransition(
            opacity: _bgFadeAnimation,
            child: Image.asset(
              AppAssets.splash,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const _FallbackBackground();
              },
            ),
          ),

          // Dark overlay for text legibility
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x00000000),
                  Color(0x55000000),
                  Color(0xCC01411C),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Twinkling stars
          AnimatedBuilder(
            animation: _starsController,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: _StarsPainter(_starsController.value),
              );
            },
          ),

          // Crescent + Star watermark (top right)
          Positioned(
            top: 48,
            right: 24,
            child: FadeTransition(
              opacity: _bgFadeAnimation,
              child: const _CrescentWatermark(),
            ),
          ),

          // "Happy Independence Day" text block
          Positioned(
            left: 0,
            right: 0,
            bottom: 110,
            child: SlideTransition(
              position: _textSlideAnimation,
              child: FadeTransition(
                opacity: _textFadeAnimation,
                child: const _IndependenceText(),
              ),
            ),
          ),

          // Shimmer progress bar
          Positioned(
            left: 40,
            right: 40,
            bottom: 32,
            child: _ShimmerProgressBar(controller: _shimmerController),
          ),
        ],
      ),
    );
  }
}

class _FallbackBackground extends StatelessWidget {
  const _FallbackBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF01411C), Color(0xFF022D13), Color(0xFF000D06)],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Independence Day Text
// ──────────────────────────────────────────────
class _IndependenceText extends StatelessWidget {
  const _IndependenceText();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Decorative divider
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _dividerLine(),
            const SizedBox(width: 10),
            const Icon(Icons.star, color: Color(0xFFFFD700), size: 14),
            const SizedBox(width: 10),
            _dividerLine(),
          ],
        ),
        const SizedBox(height: 14),

        // "Happy" label
        Text(
          'HAPPY',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.85),
            letterSpacing: 8,
          ),
        ),
        const SizedBox(height: 4),

        // "Independence" main headline
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFF3B0), Color(0xFFFFD700)],
            stops: [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: const Text(
            'Independence',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
              height: 1.1,
            ),
          ),
        ),

        // "Day" subline
        const Text(
          'DAY',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 28,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            letterSpacing: 12,
          ),
        ),
        const SizedBox(height: 14),

        // Date badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.35),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(2),
            color: Colors.white.withValues(alpha: 0.08),
          ),
          child: Text(
            '14 AUGUST 1947',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 4,
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 14),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _dividerLine(),
            const SizedBox(width: 10),
            const Icon(Icons.star, color: Color(0xFFFFD700), size: 14),
            const SizedBox(width: 10),
            _dividerLine(),
          ],
        ),
      ],
    );
  }

  Widget _dividerLine() => Container(
    width: 50,
    height: 1,
    color: Colors.white.withValues(alpha: 0.4),
  );
}

// ──────────────────────────────────────────────
// Shimmer Progress Bar
// ──────────────────────────────────────────────
class _ShimmerProgressBar extends StatelessWidget {
  final AnimationController controller;
  const _ShimmerProgressBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ShimmerBarPainter(controller.value),
          child: const SizedBox(height: 48, width: double.infinity),
        );
      },
    );
  }
}

class _ShimmerBarPainter extends CustomPainter {
  final double progress;
  _ShimmerBarPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    const barHeight = 3.0;
    const barY = 0.0;

    // Track background
    final trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, barY, size.width, barHeight),
        const Radius.circular(2),
      ),
      trackPaint,
    );

    // Shimmer sweep
    final shimmerX = progress * (size.width + 200) - 100;
    final shimmerPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.15),
          Colors.white.withValues(alpha: 0.9),
          Colors.white.withValues(alpha: 0.15),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(shimmerX - 80, barY, 160, barHeight));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, barY, size.width, barHeight),
        const Radius.circular(2),
      ),
      shimmerPaint,
    );

    // Pakistani green glow dots
    for (int i = 0; i < 5; i++) {
      final dotX = (shimmerX - 40 + i * 20).clamp(0.0, size.width);
      final dotPaint = Paint()
        ..color = const Color(0xFF01F060).withValues(alpha: 0.6 - i * 0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(Offset(dotX, barY + barHeight / 2), 3, dotPaint);
    }

    // Bottom label "Loading..."
    const textStyle = TextStyle(
      color: Color(0xAAFFFFFF),
      fontSize: 10,
      letterSpacing: 3,
    );
    final textSpan = TextSpan(text: 'LOADING...', style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, barY + barHeight + 10),
    );
  }

  @override
  bool shouldRepaint(_ShimmerBarPainter old) => old.progress != progress;
}

// ──────────────────────────────────────────────
// Crescent Watermark (top-right)
// ──────────────────────────────────────────────
class _CrescentWatermark extends StatelessWidget {
  const _CrescentWatermark();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(60, 60), painter: _CrescentPainter());
  }
}

class _CrescentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.42;

    // Outer circle
    final path = Path()
      ..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    // Cutout for crescent
    path.addOval(
      Rect.fromCircle(center: Offset(cx + r * 0.35, cy), radius: r * 0.78),
    );
    path.fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);

    // Star
    final starPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    _drawStar(canvas, Offset(cx + r * 0.55, cy - r * 0.1), r * 0.22, starPaint);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 4 * math.pi / 5) - math.pi / 2;
      final innerAngle = outerAngle + 2 * math.pi / 10;
      final outerX = center.dx + radius * math.cos(outerAngle);
      final outerY = center.dy + radius * math.sin(outerAngle);
      final innerX = center.dx + (radius * 0.4) * math.cos(innerAngle);
      final innerY = center.dy + (radius * 0.4) * math.sin(innerAngle);
      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CrescentPainter old) => false;
}

// ──────────────────────────────────────────────
// Stars Painter
// ──────────────────────────────────────────────
class _StarsPainter extends CustomPainter {
  final double animValue;

  static final List<_StarData> _stars = List.generate(30, (i) {
    final rng = math.Random(i * 17 + 3);
    return _StarData(
      x: rng.nextDouble(),
      y: rng.nextDouble() * 0.65,
      size: rng.nextDouble() * 2.5 + 0.5,
      phase: rng.nextDouble(),
    );
  });

  _StarsPainter(this.animValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in _stars) {
      final opacity =
          0.2 +
          0.6 * ((math.sin((animValue + star.phase) * 2 * math.pi) + 1) / 2);
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarsPainter old) => old.animValue != animValue;
}

class _StarData {
  final double x, y, size, phase;
  const _StarData({
    required this.x,
    required this.y,
    required this.size,
    required this.phase,
  });
}
