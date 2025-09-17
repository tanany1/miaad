import 'package:flutter/material.dart';

import '../../../presentation/navigation/bottom_nav_bar.dart';

class WelcomeScreen extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeMode;

  const WelcomeScreen({
    super.key,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff4fa6a8), // Teal from your app colors
              Color(0xff39d2c0), // Secondary teal
              Color(0xfff4d03f), // Yellow bottom
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Avatar Circle
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                ),

                const SizedBox(height: 40),

                // Welcome Text
                const Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 16),

                // Subtitle Text
                Text(
                  'Thanks for joining! Access or create your account\nbelow and get started on your journey.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),

                const Spacer(flex: 3),

                // Buttons
                Row(
                  children: [
                    // Vendor Button
                    Expanded(
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavBar(
                                  themeMode: themeMode,
                                ),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Vendor',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff4fa6a8),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // User Button
                    Expanded(
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xff4fa6a8),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavBar(
                                  themeMode: themeMode,
                                ),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'User',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}