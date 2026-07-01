import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pakistani_independence_wallpapers/core/network/api_client.dart';
import 'package:pakistani_independence_wallpapers/core/theme/app_theme.dart';
import 'package:pakistani_independence_wallpapers/data/datasource/wallpaper_remote_datasource.dart';
import 'package:pakistani_independence_wallpapers/data/repositories/wallpaper_repository_impl.dart';
import 'package:pakistani_independence_wallpapers/domain/usecases/get_wallpapers_usecase.dart';
import 'package:pakistani_independence_wallpapers/firebase_options.dart';
import 'package:provider/provider.dart';
import 'core/config/config_manager.dart';
import 'features/category/presentation/providers/wallpaper_apply_provider.dart';
import 'features/category/presentation/providers/wallpaper_provider.dart';
import 'features/favorites/provider/favorite_provider.dart';
import 'features/splash/splash_screen.dart';
import 'services/ad_service.dart';
import 'services/app_open_manager.dart';
import 'services/consent_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ConfigManager.instance.initialize();
  runApp(const PakistaniIndependenceWallpapersApp());
}

class PakistaniIndependenceWallpapersApp extends StatefulWidget {
  const PakistaniIndependenceWallpapersApp({super.key});

  @override
  State<PakistaniIndependenceWallpapersApp> createState() =>
      _PakistaniIndependenceWallpapersAppState();
}

class _PakistaniIndependenceWallpapersAppState
    extends State<PakistaniIndependenceWallpapersApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeAds());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AppOpenManager.instance.dispose();
    AppAdService.instance.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      AppOpenManager.instance.markBackgrounded();
      return;
    }

    if (state == AppLifecycleState.resumed) {
      AppOpenManager.instance.showResumeAdIfNeeded();
    }
  }

  Future<void> _initializeAds() async {
    await ConsentService.instance.initializeConsent();
    await AppAdService.instance.initialize();
    await AppOpenManager.instance.preload();
    await AppOpenManager.instance.showColdStartAd();
  }

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
