import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/colors.dart';
import '../../features/welcome/screens/welcome_screen.dart';

class VendorDashboard extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeMode;

  const VendorDashboard({super.key, required this.themeMode});

  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  int _currentIndex = 0;

  // The two screens for the vendor
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const VendorChatListScreen(), // Tab 0
      const VendorProfileScreen(),  // Tab 1
    ];
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen(themeMode: widget.themeMode)),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? "Messages" : "My Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// --- TAB 1: Chat List Placeholder ---
class VendorChatListScreen extends StatelessWidget {
  const VendorChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real app, use StreamBuilder on the 'chats' collection
    // filtering where 'vendorId' == currentUser.uid
    return const Center(
      child: Text("No messages from users yet."),
    );
  }
}

// --- TAB 2: Vendor Profile ---
class VendorProfileScreen extends StatelessWidget {
  const VendorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('vendors').doc(user!.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        var data = snapshot.data!.data() as Map<String, dynamic>;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data['name'] ?? "Name", style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Chip(label: Text(data['category'] ?? "Category")),
              const SizedBox(height: 16),
              Text("Email: ${data['email']}"),
              const SizedBox(height: 16),
              const Text("Business Description:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(data['description'] ?? "No description."),
              const SizedBox(height: 16),
              const Text("Status:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                  data['status'].toString().toUpperCase(),
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)
              ),
            ],
          ),
        );
      },
    );
  }
}