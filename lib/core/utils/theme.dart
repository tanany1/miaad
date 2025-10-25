import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  // Centralized method to create a color scheme
  static ColorScheme _colorScheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ColorScheme.fromSeed(
      seedColor: AppColors.lightPrimary, // Use one primary color to generate tones
      brightness: brightness,
      primary: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
      secondary: isDark ? AppColors.darkSecondary : AppColors.lightSecondary,
      tertiary: isDark ? AppColors.darkTertiary : AppColors.lightTertiary,
      background: isDark ? AppColors.darkPrimaryBackground : AppColors.lightPrimaryBackground,
      surface: isDark ? AppColors.darkSecondaryBackground : AppColors.lightSecondaryBackground,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      onBackground: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
      onSurface: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
      error: Colors.red.shade400,
      onError: Colors.white,
    );
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        titleTextStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      textTheme: const TextTheme(
        // Define your text styles here
      ),
      // Other theme properties...
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return null;
        }),
      ),
    );
  }

  static ThemeData lightTheme = _buildTheme(_colorScheme(Brightness.light));
  static ThemeData darkTheme = _buildTheme(_colorScheme(Brightness.dark));
}