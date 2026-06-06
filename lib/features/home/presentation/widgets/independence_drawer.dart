import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/core/constants/app_constants.dart';
import 'package:pakistani_independence_wallpapers/core/constants/app_colors.dart';
import 'package:pakistani_independence_wallpapers/features/category/presentation/screens/category_detail_screen.dart';
import 'package:pakistani_independence_wallpapers/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:pakistani_independence_wallpapers/features/home/presentation/widgets/drawer_menu_tile.dart';
import 'package:pakistani_independence_wallpapers/features/home/presentation/widgets/profile_avatar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class IndependenceDrawer extends StatelessWidget {
  const IndependenceDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 12, 0, 12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(30),
            ),
            gradient: const LinearGradient(
              colors: [Color(0xFF092D22), Color(0xFF061A13)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.38),
                blurRadius: 30,
                offset: const Offset(10, 16),
              ),
            ],
          ),
          child: ListView(
            padding: const EdgeInsets.only(top: 22, bottom: 18),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    const ProfileAvatar(radius: 30),
                    const SizedBox(height: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Happy Independence Day',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Welcome to Independence Wallpapers',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              DrawerMenuTile(
                icon: Icons.home_rounded,
                title: 'Home',
                onTap: () => Navigator.of(context).maybePop(),
              ),
              DrawerMenuTile(
                icon: Icons.image_rounded,
                title: 'Independence Wallpapers',
                onTap: () => _openCategory(context, 1),
              ),
              DrawerMenuTile(
                icon: Icons.auto_awesome_rounded,
                title: 'Live Wallpapers',
                onTap: () => _openCategory(context, 2),
              ),
              DrawerMenuTile(
                icon: Icons.mail_rounded,
                title: 'Greeting Cards',
                onTap: () => _openCategory(context, 3),
              ),
              DrawerMenuTile(
                icon: Icons.favorite_rounded,
                title: 'Favorites',
                onTap: () => _openScreen(context, const FavoritesScreen()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 10,
                ),
                child: Divider(color: AppColors.border.withValues(alpha: 0.5)),
              ),
              DrawerMenuTile(
                icon: Icons.share_rounded,
                title: 'Share App',
                onTap: () => _shareApp(context),
              ),
              // DrawerMenuTile(
              //   icon: Icons.star_rate_rounded,
              //   title: 'Rate App',
              //   onTap: () =>
              //       _openExternal(context, AppConstants.playStoreDeepLink),
              // ),
              DrawerMenuTile(
                icon: Icons.privacy_tip_rounded,
                title: 'Privacy Policy',
                onTap: () =>
                    _openExternal(context, AppConstants.privacyPolicyUrl),
              ),
              DrawerMenuTile(
                icon: Icons.description_rounded,
                title: 'Terms & Conditions',
                onTap: () =>
                    _openExternal(context, AppConstants.termsAndConditionsUrl),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  'Version ${AppConstants.appVersion}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCategory(BuildContext context, int categoryId) {
    _openScreen(context, CategoryDetailScreen(categoryId: categoryId));
  }

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.of(context).maybePop();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _shareApp(BuildContext context) async {
    Navigator.of(context).maybePop();
    await SharePlus.instance.share(
      ShareParams(
        text: AppConstants.shareMessage,
        subject: AppConstants.appName,
      ),
    );
  }

  Future<void> _openExternal(BuildContext context, String url) async {
    Navigator.of(context).maybePop();
    final uri = Uri.parse(url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted && url == AppConstants.playStoreDeepLink) {
      await launchUrl(
        Uri.parse(AppConstants.playStoreUrl),
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
