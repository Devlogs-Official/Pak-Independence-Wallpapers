import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/core/constants/app_assets.dart';
import 'package:pakistani_independence_wallpapers/core/constants/app_colors.dart';
import 'package:video_player/video_player.dart';

class HomeHeaderBanner extends StatefulWidget {
  const HomeHeaderBanner({super.key});

  @override
  State<HomeHeaderBanner> createState() => _HomeHeaderBannerState();
}

class _HomeHeaderBannerState extends State<HomeHeaderBanner> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(AppAssets.hero)
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).width < 380 ? 224.0 : 240.0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF063423), Color(0xFF0B6E3E), Color(0xFF042418)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // border: Border.all(color: Colors.white24),
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
          Positioned.fill(
            child: _controller.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width * 0.9,
                      height: _controller.value.size.height * 0.9,
                      child: Transform.scale(
                        scale: 1.12,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  )
                : const _VideoPlaceholder(),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.62),
                    AppColors.primary.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.28),
                  ],
                ),
              ),
            ),
          ),
          // const Positioned.fill(child: _BannerGlowField()),
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
            right: 24,
            bottom: 26,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 230),
              child: const _BannerTitle(),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoPlaceholder extends StatelessWidget {
  const _VideoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF063423), Color(0xFF0B6E3E), Color(0xFF042418)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('Happy', textAlign: TextAlign.right, style: textTheme.titleLarge),
        Text(
          'Independence',
          textAlign: TextAlign.right,
          style: textTheme.titleLarge?.copyWith(color: AppColors.accent),
        ),
        Text(
          'Day - 14 August',
          textAlign: TextAlign.right,
          style: textTheme.titleLarge,
        ),
      ],
    );
  }
}
