import 'package:flutter/material.dart';
import 'package:pakistani_independence_wallpapers/core/constants/app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.accent,
      surface: AppColors.background,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Lato',
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.accentWhite,
        surfaceTintColor: Colors.transparent,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.accentWhite,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side: const BorderSide(color: AppColors.accent),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accent,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.w800,
          height: 1.04,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          height: 1.08,
        ),
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          height: 1.08,
        ),
        titleMedium: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          height: 1.08,
        ),
        bodyLarge: TextStyle(
          color: Color(0xD9FFFFFF),
          fontSize: 17,
          fontWeight: FontWeight.w500,
          height: 1.24,
        ),
        bodyMedium: TextStyle(
          color: Color(0xCCFFFFFF),
          fontSize: 15,
          fontWeight: FontWeight.w500,
          height: 1.18,
        ),
      ),
    );
  }
}
