import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/core/constants/app_colors.dart';
import 'package:pakistani_independence_wallpapers/features/home/presentation/widgets/drawer_menu_tile.dart';
import 'package:pakistani_independence_wallpapers/features/home/presentation/widgets/profile_avatar.dart';

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
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(30)),
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
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const DrawerMenuTile(icon: Icons.home_rounded, title: 'Home'),
              const DrawerMenuTile(icon: Icons.auto_awesome_rounded, title: 'Live Wallpapers'),
              const DrawerMenuTile(icon: Icons.mail_rounded, title: 'Greeting Cards'),
              const DrawerMenuTile(icon: Icons.edit, title: 'National Anthem'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                child: Divider(color: AppColors.border.withValues(alpha: 0.5)),
              ),
              const DrawerMenuTile(icon: Icons.share_rounded, title: 'Share App'),
              const DrawerMenuTile(icon: Icons.star_rate_rounded, title: 'Rate App'),
            ],
          ),
        ),
      ),
    );
  }
}
