import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightPrimaryBackground,
    textTheme: TextTheme(
      headlineLarge: TextStyle(color: AppColors.lightPrimaryText, fontSize: 20),
      bodyMedium: TextStyle(color: AppColors.lightSecondaryText, fontSize: 14),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightPrimary,
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    dividerColor: AppColors.lightAlternate,
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.lightPrimary,
      inactiveTrackColor: AppColors.lightAlternate,
      thumbColor: AppColors.lightSecondaryBackground,
      valueIndicatorColor: AppColors.lightPrimary,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return AppColors.lightPrimary;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return AppColors.lightPrimary;
        }
        return null;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return AppColors.lightPrimary;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return AppColors.lightPrimary;
        }
        return null;
      }),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkPrimaryBackground,
    textTheme: TextTheme(
      headlineLarge: TextStyle(color: AppColors.darkPrimaryText, fontSize: 20),
      bodyMedium: TextStyle(color: AppColors.darkSecondaryText, fontSize: 14),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkPrimary,
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    dividerColor: AppColors.darkAlternate,
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.darkPrimary,
      inactiveTrackColor: AppColors.darkAlternate,
      thumbColor: AppColors.darkSecondaryBackground,
      valueIndicatorColor: AppColors.darkPrimary,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return AppColors.darkPrimary;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return AppColors.darkPrimary;
        }
        return null;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return AppColors.darkPrimary;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return AppColors.darkPrimary;
        }
        return null;
      }),
    ),
  );
}
