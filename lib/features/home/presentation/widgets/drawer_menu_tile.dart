import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/core/constants/app_colors.dart';

class DrawerMenuTile extends StatelessWidget {
  const DrawerMenuTile({
    super.key,
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: Material(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Navigator.of(context).maybePop(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(icon, color: AppColors.accent, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
