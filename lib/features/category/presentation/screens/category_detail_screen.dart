import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/core/constants/app_colors.dart';
import 'package:pakistani_independence_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:pakistani_independence_wallpapers/features/category/presentation/screens/greeting_card_detail_screen.dart';
import 'package:pakistani_independence_wallpapers/features/category/presentation/screens/live_wallpapers_detail_screen.dart';
import 'package:pakistani_independence_wallpapers/features/category/presentation/screens/wallpaper_detail_screen.dart';
import 'package:pakistani_independence_wallpapers/features/favorites/provider/favorite_provider.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';
import '../widgets/wallpaper_tile.dart';

class CategoryDetailScreen extends StatefulWidget {
  const CategoryDetailScreen({super.key, required this.categoryId});

  final int categoryId;

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WallpaperProvider>().loadWallpapers(
        categoryId: widget.categoryId,
      );
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0) {
      return;
    }

    final triggerOffset = position.maxScrollExtent * 0.8;
    if (position.pixels >= triggerOffset) {
      context.read<WallpaperProvider>().loadMore(categoryId: widget.categoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentWhite,
      appBar: AppBar(
        title: Text(_titleFor(widget.categoryId)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<WallpaperProvider>(
        builder: (context, provider, child) {
          final wallpapers = provider.wallpapersFor(widget.categoryId);
          final isFirstLoading =
              provider.isLoadingCategory(widget.categoryId) &&
              wallpapers.isEmpty;
          final errorMessage = provider.errorFor(widget.categoryId);
          final paginationError = provider.paginationErrorFor(
            widget.categoryId,
          );

          if (isFirstLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (wallpapers.isEmpty && errorMessage != null) {
            return _MessageState(
              icon: Icons.wifi_off_rounded,
              message: errorMessage,
              onRetry: () => provider.loadWallpapers(
                categoryId: widget.categoryId,
                refresh: true,
              ),
            );
          }

          if (wallpapers.isEmpty) {
            return _MessageState(
              icon: Icons.auto_awesome_rounded,
              message: 'No wallpapers available',
              onRetry: () => provider.loadWallpapers(
                categoryId: widget.categoryId,
                refresh: true,
              ),
            );
          }

          return RefreshIndicator(
            color: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
            onRefresh: () => provider.loadWallpapers(
              categoryId: widget.categoryId,
              refresh: true,
            ),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  sliver: SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: _gridAspectRatioFor(widget.categoryId),
                    ),
                    itemCount: wallpapers.length,
                    itemBuilder: (context, index) {
                      final wallpaper = wallpapers[index];
                      return GestureDetector(
                        onTap: () {
                          _openWallpaperDetail(context, wallpaper);
                        },
                        child: Hero(
                          tag: 'wallpaper-${wallpaper.id}',
                          child: _WallpaperGridItem(wallpaper: wallpaper),
                        ),
                      );
                    },
                  ),
                ),
                if (provider.isLoadingMoreCategory(widget.categoryId))
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                if (paginationError != null)
                  SliverToBoxAdapter(
                    child: _PaginationErrorFooter(
                      message: paginationError,
                      onRetry: () =>
                          provider.retryLoadMore(categoryId: widget.categoryId),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _titleFor(int categoryId) {
    return switch (categoryId) {
      1 => 'Independence Wallpapers',
      2 => 'Live Wallpapers',
      3 => 'Greeting Cards',
      _ => 'Wallpapers',
    };
  }

  double _gridAspectRatioFor(int categoryId) {
    return switch (categoryId) {
      3 => 0.68,
      _ => 0.68,
    };
  }

  void _openWallpaperDetail(BuildContext context, WallpaperEntity wallpaper) {
    final screen = switch (widget.categoryId) {
      2 => LiveWallpaperDetailScreen(wallpaper: wallpaper),
      3 => GreetingCardDetailScreen(wallpaper: wallpaper),
      _ => WallpaperDetailScreen(wallpaper: wallpaper),
    };

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

class _WallpaperGridItem extends StatelessWidget {
  const _WallpaperGridItem({required this.wallpaper});

  final WallpaperEntity wallpaper;

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final isFavorite = favoritesProvider.isFavorite(wallpaper.imageUrl);

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary, width: 1),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: WallpaperTile(imageUrl: wallpaper.thumbnailUrl),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Material(
                  color: Colors.black.withValues(alpha: 0.42),
                  shape: const CircleBorder(),
                  child: IconButton(
                    onPressed: () {
                      favoritesProvider.toggleFavorite(wallpaper);
                    },
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFavorite ? Colors.redAccent : Colors.white,
                    ),
                    tooltip: isFavorite
                        ? 'Remove from favorites'
                        : 'Add favorite',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.message,
    required this.onRetry,
  });

  final IconData icon;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.accent, size: 48),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text(
                'Try again',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaginationErrorFooter extends StatelessWidget {
  const _PaginationErrorFooter({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
