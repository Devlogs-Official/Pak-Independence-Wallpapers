import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/core/utils/share_file_helper.dart';
import 'package:pakistani_independence_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:pakistani_independence_wallpapers/features/category/presentation/providers/wallpaper_apply_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';

class WallpaperDetailScreen extends StatefulWidget {
  const WallpaperDetailScreen({super.key, required this.wallpaper});

  final WallpaperEntity wallpaper;

  @override
  State<WallpaperDetailScreen> createState() => _WallpaperDetailScreenState();
}

class _WallpaperDetailScreenState extends State<WallpaperDetailScreen> {
  bool _isSharing = false;

  Future<void> _showApplySheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Consumer<WallpaperApplyProvider>(
          builder: (context, applyProvider, child) {
            return _WallpaperApplySheet(
              isApplying: applyProvider.isApplying,
              onSelect: (target) => _applyWallpaper(sheetContext, target),
            );
          },
        );
      },
    );
  }

  Future<void> _applyWallpaper(
    BuildContext sheetContext,
    WallpaperTarget target,
  ) async {
    final applyProvider = context.read<WallpaperApplyProvider>();
    if (applyProvider.isApplying) return;

    final sheetNavigator = Navigator.of(sheetContext);
    final result = await applyProvider.apply(
      imageUrl: widget.wallpaper.imageUrl,
      target: target,
    );

    if (!mounted) return;
    sheetNavigator.pop();
    _showSnack(result.message, result.success);
  }

  Future<void> _shareWallpaper() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);

    try {
      await ShareFileHelper.shareRemoteFile(
        url: widget.wallpaper.imageUrl,
        filename: ShareFileHelper.imageFilename(widget.wallpaper.name),
        subject: 'Pakistan Independence Day Wallpaper',
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

  @override
  Widget build(BuildContext context) {
    final applyProvider = context.watch<WallpaperApplyProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full-screen image
          Positioned.fill(
            child: Hero(
              tag: 'wallpaper-${widget.wallpaper.id}',
              child: CachedNetworkImage(
                imageUrl: widget.wallpaper.imageUrl,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 260),
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)),
              ),
            ),
          ),

          // Back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.primary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    color: Colors.black45,
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _DetailActionButton(
                            onPressed: applyProvider.isApplying
                                ? null
                                : _showApplySheet,
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
                            label: _isSharing ? 'Sharing' : 'Share',
                            isPrimary: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WallpaperApplySheet extends StatelessWidget {
  const _WallpaperApplySheet({
    required this.isApplying,
    required this.onSelect,
  });

  final bool isApplying;
  final ValueChanged<WallpaperTarget> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.34)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.32),
            blurRadius: 28,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apply Wallpaper',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
            for (final target in WallpaperTarget.values)
              _ApplyTargetTile(
                target: target,
                isApplying: isApplying,
                onTap: () => onSelect(target),
              ),
          ],
        ),
      ),
    );
  }
}

class _ApplyTargetTile extends StatelessWidget {
  const _ApplyTargetTile({
    required this.target,
    required this.isApplying,
    required this.onTap,
  });

  final WallpaperTarget target;
  final bool isApplying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Material(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        child: ListTile(
          enabled: !isApplying,
          onTap: onTap,
          leading: const Icon(Icons.wallpaper_rounded, color: AppColors.accent),
          title: Text(target.title),
          subtitle: Text(target.subtitle),
          trailing: isApplying
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.chevron_right_rounded),
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
    final start = isPrimary ? AppColors.primary : const Color(0x33FFFFFF);
    final end = isPrimary ? AppColors.secondary : const Color(0x1FFFFFFF);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(colors: [start, end]),
        boxShadow: [
          BoxShadow(
            color: (isPrimary ? AppColors.accent : Colors.black).withValues(
              alpha: isPrimary ? 0.34 : 0.18,
            ),
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
                children: [
                  IconTheme.merge(
                    data: const IconThemeData(color: Colors.white, size: 20),
                    child: icon,
                  ),
                  if (label.isNotEmpty) ...[
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
