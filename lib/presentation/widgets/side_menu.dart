import 'package:flutter/material.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/contacts/screens/contacts_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../core/constants/colors.dart';

class SideMenu extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeMode;

  const SideMenu({super.key, required this.themeMode});

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeMode.value == ThemeMode.dark ||
        (themeMode.value == ThemeMode.system &&
            Theme.of(context).brightness == Brightness.dark);

    return Drawer(
      child: Container(
        color: isDarkMode ? AppColors.darkPrimaryBackground : AppColors.lightPrimaryBackground,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
              title: Text(
                'My Profile',
                style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
              ),
              onTap: () => _navigateToPage(context, const ProfileScreen()),
            ),
            ListTile(
              leading: Icon(Icons.contacts, color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
              title: Text(
                'My Contacts',
                style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
              ),
              onTap: () => _navigateToPage(context, const ContactsScreen()),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
              title: Text(
                'Settings',
                style: TextStyle(color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
              ),
              onTap: () => _navigateToPage(context, SettingsScreen(themeMode: themeMode)),
            ),
          ],
        ),
      ),
    );
  }
}