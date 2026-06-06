import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/core/network/api_client.dart';
import 'package:pakistani_independence_wallpapers/core/theme/app_theme.dart';
import 'package:pakistani_independence_wallpapers/data/datasource/wallpaper_remote_datasource.dart';
import 'package:pakistani_independence_wallpapers/data/repositories/wallpaper_repository_impl.dart';
import 'package:pakistani_independence_wallpapers/domain/usecases/get_wallpapers_usecase.dart';
import 'package:provider/provider.dart';
import 'features/category/presentation/providers/wallpaper_apply_provider.dart';
import 'features/category/presentation/providers/wallpaper_provider.dart';
import 'features/favorites/provider/favorite_provider.dart';
import 'features/splash/splash_screen.dart';

void main() {
  runApp(const PakistaniIndependenceWallpapersApp());
}

class PakistaniIndependenceWallpapersApp extends StatelessWidget {
  const PakistaniIndependenceWallpapersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final apiClient = ApiClient();
            final apiService = WallpaperApiService(apiClient);
            final repository = WallpaperRepositoryImpl(apiService);
            final usecase = GetWallpapersUsecase(repository);
            return WallpaperProvider(usecase);
          },
        ),
        ChangeNotifierProvider(create: (context) => WallpaperApplyProvider()),
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pakistani Independence Wallpapers',
        theme: AppTheme.light,
        home: const SplashScreen(),
      ),
    );
  }
}
