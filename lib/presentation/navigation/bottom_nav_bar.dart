import 'package:flutter/material.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/catering/screens/catering_screen.dart';
import '../../features/new_invitation/screens/new_invitation_screen.dart';
import '../../features/invitation_card/screens/invitation_card_screen.dart';
import '../../features/history/screens/history_screen.dart';
import '../../features/notification/screens/notifications_screen.dart';
import '../widgets/side_menu.dart';
import '../../core/constants/colors.dart';

class BottomNavBar extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeMode;

  const BottomNavBar({super.key, required this.themeMode});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    CateringScreen(),
    NewInvitationScreen(),
    InvitationCardScreen(),
    HistoryScreen(),
  ];
  static const List<String> _pageLabels = <String>[
    'Home',
    'Catering',
    'New Invitation',
    'Invitation Card',
    'History',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: widget.themeMode,
      builder: (context, mode, child) {
        final isDarkMode =
            mode == ThemeMode.dark ||
                (mode == ThemeMode.system &&
                    Theme.of(context).brightness == Brightness.dark);

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              _pageLabels[_selectedIndex],
              style: TextStyle(
                color: isDarkMode
                    ? AppColors.darkPrimaryText
                    : Colors.white,
              ),
            ),
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  color: isDarkMode
                      ? AppColors.darkPrimaryText
                      : Colors.white,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: _selectedIndex == 0 // Show notification icon only on Home tab
                ? [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: isDarkMode
                      ? AppColors.darkPrimaryText
                      : Colors.white,
                ),
                onPressed: _showNotifications,
              ),
            ]
                : null,
            backgroundColor: isDarkMode
                ? AppColors.darkPrimary
                : AppColors.lightPrimary,
          ),
          drawer: SideMenu(themeMode: widget.themeMode),
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_dining),
                label: 'Catering',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'New Invitation',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard),
                label: 'Invitation Card',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: isDarkMode
                ? AppColors.darkSecondary
                : AppColors.lightSecondary,
            unselectedItemColor: isDarkMode
                ? AppColors.darkTertiary
                : AppColors.lightTertiary,
            backgroundColor: isDarkMode
                ? AppColors.darkPrimaryBackground
                : AppColors.lightPrimaryBackground,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}