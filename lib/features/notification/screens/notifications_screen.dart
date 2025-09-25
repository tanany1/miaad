import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            color: isDarkMode ? AppColors.darkPrimaryText : Colors.white,
          ),
        ),
        backgroundColor: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
        iconTheme: IconThemeData(
          color: isDarkMode ? AppColors.darkPrimaryText : Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              size: 80,
              color: isDarkMode
                  ? AppColors.darkSecondaryText
                  : AppColors.lightSecondaryText,
            ),
            const SizedBox(height: 16),
            Text(
              'You have no notifications',
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode
                    ? AppColors.darkSecondaryText
                    : AppColors.lightSecondaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'New notifications will appear here',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode
                    ? AppColors.darkSecondaryText
                    : AppColors.lightSecondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}