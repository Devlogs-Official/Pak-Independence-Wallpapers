import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/core/constants/app_colors.dart';
import 'package:pakistani_independence_wallpapers/core/utils/share_file_helper.dart';
import 'package:pakistani_independence_wallpapers/domain/entities/wallpaper_entity.dart';

class GreetingCardDetailScreen extends StatefulWidget {
  const GreetingCardDetailScreen({super.key, required this.wallpaper});

  final WallpaperEntity wallpaper;

  @override
  State<GreetingCardDetailScreen> createState() =>
      _GreetingCardDetailScreenState();
}

class _GreetingCardDetailScreenState extends State<GreetingCardDetailScreen> {
  int _retryToken = 0;
  bool _isSharing = false;
  late Future<Size> _imageSizeFuture;

  @override
  void initState() {
    super.initState();
    _imageSizeFuture = _loadImageSize(widget.wallpaper.imageUrl);
  }

  @override
  void didUpdateWidget(covariant GreetingCardDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.wallpaper.imageUrl != widget.wallpaper.imageUrl) {
      _imageSizeFuture = _loadImageSize(widget.wallpaper.imageUrl);
    }
  }

  Future<Size> _loadImageSize(String imageUrl) {
    final completer = Completer<Size>();
    final imageProvider = CachedNetworkImageProvider(imageUrl);
    final imageStream = imageProvider.resolve(ImageConfiguration.empty);
    late final ImageStreamListener listener;

    listener = ImageStreamListener(
      (imageInfo, _) {
        imageStream.removeListener(listener);
        if (!completer.isCompleted) {
          completer.complete(
            Size(
              imageInfo.image.width.toDouble(),
              imageInfo.image.height.toDouble(),
            ),
          );
        }
      },
      onError: (error, stackTrace) {
        imageStream.removeListener(listener);
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
      },
    );

    imageStream.addListener(listener);
    return completer.future;
  }

  void _retryImageLoad() {
    setState(() {
      _retryToken++;
      _imageSizeFuture = _loadImageSize(widget.wallpaper.imageUrl);
    });
  }

  Future<void> _shareGreetingCard() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);

    try {
      await ShareFileHelper.shareRemoteFile(
        url: widget.wallpaper.imageUrl,
        filename: ShareFileHelper.imageFilename(widget.wallpaper.name),
        subject: 'Pakistan Independence Day Greeting Card',
        text: 'Happy Independence Day',
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFFB23838),
          content: Text('Sharing is unavailable on this device.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.background,
              AppColors.secondary,
            ],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              right: -28,
              top: 52,
              child: _DecorativeCrescent(size: 150),
            ),
            Positioned(
              left: -42,
              bottom: 118,
              child: Icon(
                Icons.star_rounded,
                color: AppColors.accent.withValues(alpha: 0.12),
                size: 118,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Row(
                      children: [
                        _CircleButton(
                          icon: Icons.arrow_back_rounded,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Greeting Card',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(22),
                        child: FutureBuilder<Size>(
                          future: _imageSizeFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return _GreetingCardError(
                                onRetry: _retryImageLoad,
                              );
                            }

                            final imageSize = snapshot.data;
                            final aspectRatio = imageSize == null
                                ? 4 / 3
                                : imageSize.width / imageSize.height;

                            return _GreetingCardFrame(
                              aspectRatio: aspectRatio,
                              child: CachedNetworkImage(
                                key: ValueKey(_retryToken),
                                imageUrl: widget.wallpaper.imageUrl,
                                fit: BoxFit.cover,
                                fadeInDuration: const Duration(
                                  milliseconds: 260,
                                ),
                                placeholder: (context, url) {
                                  return const ColoredBox(
                                    color: AppColors.deepGreen,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                                errorWidget: (context, url, error) {
                                  return _GreetingCardError(
                                    onRetry: _retryImageLoad,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _isSharing ? null : _shareGreetingCard,
                        icon: _isSharing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.share_rounded),
                        label: Text(
                          _isSharing ? 'Sharing...' : 'Share Greeting Card',
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.primary,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GreetingCardFrame extends StatelessWidget {
  const _GreetingCardFrame({required this.aspectRatio, required this.child});

  final double aspectRatio;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const borderRadius = 24.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        var width = constraints.maxWidth;
        var height = width / aspectRatio;

        if (height > constraints.maxHeight) {
          height = constraints.maxHeight;
          width = height * aspectRatio;
        }

        return Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: width,
            height: height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.28),
                    blurRadius: 32,
                    offset: const Offset(0, 18),
                  ),
                ],
                border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GreetingCardError extends StatelessWidget {
  const _GreetingCardError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.deepGreen,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.broken_image_rounded,
                color: AppColors.accent,
                size: 44,
              ),
              const SizedBox(height: 14),
              Text(
                'Unable to load greeting card',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 14),
              OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.34)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class _DecorativeCrescent extends StatelessWidget {
  const _DecorativeCrescent({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CrescentPainter()),
    );
  }
}

class _CrescentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.11)
      ..style = PaintingStyle.fill;
    final radius = size.shortestSide * 0.42;
    final center = Offset(size.width / 2, size.height / 2);
    final path = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius))
      ..addOval(
        Rect.fromCircle(
          center: Offset(center.dx + radius * 0.36, center.dy),
          radius: radius * 0.78,
        ),
      )
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
