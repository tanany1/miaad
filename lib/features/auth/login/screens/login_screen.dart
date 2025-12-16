import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/colors.dart';
import '../../../../presentation/navigation/bottom_nav_bar.dart';
import '../../../../presentation/widgets/vendor_dashboard.dart';
import '../../register/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  final ValueNotifier<ThemeMode> themeMode;

  const LoginScreen({
    super.key,
    required this.role,
    required this.themeMode,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _errorMessage;
  bool _isLoading = false;

  void _login() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Authenticate
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (widget.role.toLowerCase() == 'vendor') {
        // 2. Check Vendor Status in Firestore
        DocumentSnapshot vendorDoc = await FirebaseFirestore.instance
            .collection('vendors')
            .doc(cred.user!.uid)
            .get();

        if (vendorDoc.exists) {
          String status = vendorDoc.get('status') ?? 'pending';

          if (status == 'approved') {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => VendorDashboard(themeMode: widget.themeMode),
                ),
              );
            }
          } else if (status == 'rejected') {
            await _auth.signOut();
            setState(() => _errorMessage = "Your application was rejected.");
          } else {
            await _auth.signOut();
            setState(() => _errorMessage = "Account under review. Please wait for admin approval.");
          }
        } else {
          // Fallback if they logged in as vendor but have no vendor doc
          await _auth.signOut();
          setState(() => _errorMessage = "Vendor profile not found.");
        }
      } else {
        // Regular User Login Flow
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(themeMode: widget.themeMode),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.darkPrimaryBackground
                        : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: isDarkMode
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: isDarkMode
                        ? AppColors.darkSecondaryBackground
                        : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: isDarkMode
                        ? AppColors.darkSecondaryBackground
                        : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen(
                              role: widget.role,
                              themeMode: widget.themeMode)),
                    );
                  },
                  child: Text(
                    "Don't have an account? Register",
                    style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

