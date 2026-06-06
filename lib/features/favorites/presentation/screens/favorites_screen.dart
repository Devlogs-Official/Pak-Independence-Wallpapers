import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pakistani_independence_wallpapers/core/constants/app_colors.dart';
import 'package:pakistani_independence_wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:pakistani_independence_wallpapers/features/category/presentation/screens/greeting_card_detail_screen.dart';
import 'package:pakistani_independence_wallpapers/features/category/presentation/screens/live_wallpapers_detail_screen.dart';
import 'package:pakistani_independence_wallpapers/features/category/presentation/screens/wallpaper_detail_screen.dart';
import 'package:pakistani_independence_wallpapers/features/category/presentation/widgets/wallpaper_tile.dart';
import 'package:pakistani_independence_wallpapers/features/favorites/provider/favorite_provider.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.accentWhite,
        appBar: AppBar(
          title: const Text('Favorites'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(62),
            child: Container(
              height: 46,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.3),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.white,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                tabs: const [
                  Tab(text: 'Static'),
                  Tab(text: 'Live'),
                  Tab(text: 'Cards'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            _FavoriteCategoryTab(categoryId: 1),
            _FavoriteCategoryTab(categoryId: 2),
            _FavoriteCategoryTab(categoryId: 3),
          ],
        ),
      ),
    );
  }
}

class _FavoriteCategoryTab extends StatelessWidget {
  const _FavoriteCategoryTab({required this.categoryId});

  final int categoryId;

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, provider, child) {
        final wallpapers = provider.byCategory(categoryId);

        if (wallpapers.isEmpty) {
          return _EmptyFavorites(categoryId: categoryId);
        }

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childCount: wallpapers.length,
                itemBuilder: (context, index) {
                  final wallpaper = wallpapers[index];
                  final height = index.isEven ? 230.0 : 290.0;

                  return GestureDetector(
                    onTap: () => _openDetail(context, wallpaper),
                    child: SizedBox(
                      height: height,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: WallpaperTile(
                              imageUrl: wallpaper.thumbnailUrl,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Material(
                              color: Colors.black.withValues(alpha: 0.42),
                              shape: const CircleBorder(),
                              child: IconButton(
                                onPressed: () {
                                  provider.removeFavorite(wallpaper.imageUrl);
                                },
                                icon: const Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.redAccent,
                                ),
                                tooltip: 'Remove from favorites',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _openDetail(BuildContext context, WallpaperEntity wallpaper) {
    final screen = switch (categoryId) {
      2 => LiveWallpaperDetailScreen(wallpaper: wallpaper),
      3 => GreetingCardDetailScreen(wallpaper: wallpaper),
      _ => WallpaperDetailScreen(wallpaper: wallpaper),
    };

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites({required this.categoryId});

  final int categoryId;

  @override
  Widget build(BuildContext context) {
    final label = switch (categoryId) {
      2 => 'live wallpapers',
      3 => 'greeting cards',
      _ => 'static wallpapers',
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_border_rounded,
              color: AppColors.accent,
              size: 54,
            ),
            const SizedBox(height: 14),
            Text(
              'No favorite $label yet',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
