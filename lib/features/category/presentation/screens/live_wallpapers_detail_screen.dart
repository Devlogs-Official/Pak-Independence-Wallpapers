import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/core/utils/share_file_helper.dart';
import 'package:pakistani_independence_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:pakistani_independence_wallpapers/features/category/presentation/providers/wallpaper_apply_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class LiveWallpaperDetailScreen extends StatefulWidget {
  const LiveWallpaperDetailScreen({super.key, required this.wallpaper});

  final WallpaperEntity wallpaper;

  @override
  State<LiveWallpaperDetailScreen> createState() =>
      _LiveWallpaperDetailScreenState();
}

class _LiveWallpaperDetailScreenState extends State<LiveWallpaperDetailScreen> {
  VideoPlayerController? _videoController;
  Future<void>? _videoInitFuture;
  bool _isSharing = false;
  bool _isVideoReady = false;
  bool _videoFailed = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.wallpaper.imageUrl),
    );
    _videoInitFuture = _videoController!
        .initialize()
        .then((_) async {
          await _videoController!.setLooping(true);
          await _videoController!.setVolume(0);
          await _videoController!.play();
          if (!mounted) return;
          setState(() => _isVideoReady = true);
        })
        .catchError((_) {
          if (!mounted) return;
          setState(() => _videoFailed = true);
        });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _onApplyTapped() async {
    if (context.read<WallpaperApplyProvider>().isApplying) {
      return;
    }
    await _applyLiveWallpaper();
  }

  Future<void> _applyLiveWallpaper() async {
    final WallpaperApplyProvider applyProvider = context
        .read<WallpaperApplyProvider>();
    if (applyProvider.isApplying) return;

    final WallpaperApplyResult result = await applyProvider.applyLive(
      videoUrl: widget.wallpaper.imageUrl,
      id: widget.wallpaper.id.toString(),
    );

    if (!mounted) return;
    _showSnack(result.message, result.success);
  }

  Future<void> _shareWallpaper() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      await ShareFileHelper.shareRemoteFile(
        url: widget.wallpaper.imageUrl,
        filename: ShareFileHelper.videoFilename(widget.wallpaper.name),
        subject: 'Pakistan Independence Day Live Wallpaper',
        text: 'Happy Independence Day',
      );
    } catch (_) {
      if (!mounted) return;
      _showSnack('Sharing is unavailable on this device.', false);
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  void _showSnack(String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: success
            ? const Color(0xFF1A7F44)
            : const Color(0xFFB23838),
        content: Text(message),
      ),
    );
  }

  Widget _buildVideoLayer() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        if (widget.wallpaper.thumbnailUrl.isNotEmpty)
          CachedNetworkImage(
            imageUrl: widget.wallpaper.thumbnailUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const ShimmerBox(height: double.infinity, radius: 0),
          )
        else
          const ShimmerBox(height: double.infinity, radius: 0),
        FutureBuilder<void>(
          future: _videoInitFuture,
          builder: (context, snapshot) {
            if (_isVideoReady &&
                snapshot.connectionState == ConnectionState.done &&
                _videoController != null &&
                !snapshot.hasError) {
              return AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoController!.value.size.width,
                    height: _videoController!.value.size.height,
                    child: VideoPlayer(_videoController!),
                  ),
                ),
              );
            }
            if (snapshot.hasError) {
              return const ColoredBox(
                color: Colors.black45,
                child: Center(
                  child: Icon(
                    Icons.broken_image_rounded,
                    color: Colors.white70,
                    size: 42,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final applyProvider = context.watch<WallpaperApplyProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Positioned.fill(child: _buildVideoLayer()),
          if (!_isVideoReady && !_videoFailed)
            const Positioned.fill(child: _LiveDetailShimmer()),
          SafeArea(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 8,
                  left: 12,
                  child: _CircleButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      color: Colors.black45,
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: _DetailActionButton(
                              onPressed: applyProvider.isApplying
                                  ? null
                                  : _onApplyTapped,
                              icon: applyProvider.isApplying
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.4,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.wallpaper_outlined),
                              label: applyProvider.isApplying
                                  ? 'Applying'
                                  : 'Apply Wallpaper',
                              isPrimary: true,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: _DetailActionButton(
                              onPressed: _isSharing ? null : _shareWallpaper,
                              icon: _isSharing
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.4,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.share_outlined),
                              label: '',
                              isPrimary: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveDetailShimmer extends StatelessWidget {
  const _LiveDetailShimmer();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: ShimmerBox(height: double.infinity, radius: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailActionButton extends StatelessWidget {
  const _DetailActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.isPrimary,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final String label;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final start = isPrimary ? const Color(0xFF01411C) : const Color(0x33FFFFFF);
    final end = isPrimary ? const Color(0xFF0B6E2F) : const Color(0x1FFFFFFF);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(colors: <Color>[start, end]),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: (isPrimary ? const Color(0xFFD4AF37) : Colors.black)
                .withValues(alpha: isPrimary ? 0.34 : 0.18),
            blurRadius: isPrimary ? 22 : 16,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(999),
          child: Opacity(
            opacity: onPressed == null ? 0.62 : 1,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isPrimary ? 18 : 14,
                vertical: isPrimary ? 15 : 13,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconTheme.merge(
                    data: const IconThemeData(color: Colors.white, size: 20),
                    child: icon,
                  ),
                  if (label.isNotEmpty) ...<Widget>[
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(icon, color: Colors.black87),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class ShimmerBox extends StatefulWidget {
  const ShimmerBox({super.key, required this.height, required this.radius});

  final double height;
  final double radius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + _controller.value * 2, -0.2),
              end: Alignment(1.0 + _controller.value * 2, 0.2),
              colors: const [
                Color(0xFF151515),
                Color(0xFF303030),
                Color(0xFF151515),
              ],
            ),
          ),
        );
      },
    );
  }
}
