import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');
  double _fontSize = 16.0;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  double get fontSize => _fontSize;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Theme
    final themeModeString = prefs.getString('themeMode') ?? 'system';
    _themeMode = ThemeMode.values.firstWhere((mode) => mode.toString().split('.').last == themeModeString, orElse: () => ThemeMode.system);

    // Load Locale
    final languageCode = prefs.getString('languageCode') ?? 'en';
    _locale = Locale(languageCode);

    // Load Font Size
    _fontSize = prefs.getDouble('fontSize') ?? 16.0;

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.toString().split('.').last);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    notifyListeners();
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', size);
    notifyListeners();
  }
}