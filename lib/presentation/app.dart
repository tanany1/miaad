import 'package:flutter/material.dart';
import 'package:miaad/features/welcome/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/theme.dart';
import '../presentation/navigation/bottom_nav_bar.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('themeMode');
    if (themeModeString != null) {
      themeMode.value = ThemeMode.values.firstWhere(
            (mode) => mode.toString().split('.').last == themeModeString,
        orElse: () => ThemeMode.system,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Miaad',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          home: WelcomeScreen(themeMode: themeMode),
        );
      },
    );
  }
}