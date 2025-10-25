import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../../../../core/constants/colors.dart';
import '../../OTP/screens/otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  final String role;
  final ValueNotifier<ThemeMode> themeMode;

  const RegisterScreen({
    super.key,
    required this.role,
    required this.themeMode,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  // --- OTP Email Sending Logic ---
  Future<void> _sendOtpEmail(String otp, String recipientEmail) async {
    // IMPORTANT: Replace with your email and an "App Password" from your Google Account.
    // DO NOT use your regular password. This is still insecure for production apps.
    final String username = 'miaad.app@gmail.com';
    final String password = 'mkia mbyp peas qdmy';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Your App Name')
      ..recipients.add(recipientEmail)
      ..subject = 'Your Verification Code'
      ..html = "<h3>Your verification code is:</h3>\n<h1>$otp</h1>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      print('Message not sent. \n$e');
      // Handle failed email sending
      setState(() {
        _errorMessage = "Failed to send OTP. Please try again.";
        _isLoading = false;
      });
    }
  }

  // --- Main Registration Logic ---
  void _register() async {
    if (_isLoading) return;

    if (_passwordController.text != _repasswordController.text) {
      setState(() => _errorMessage = "Passwords do not match");
      return;
    }

    // Validate that all fields are filled
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() => _errorMessage = "Please fill in all fields.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // 1. Generate OTP
    String otp = (100000 + Random().nextInt(900000)).toString();

    // 2. Send OTP via Email
    await _sendOtpEmail(otp, _emailController.text.trim());

    if (!mounted || _errorMessage != null) return;

    // 3. Navigate to OTP Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpScreen(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text.trim(),
          role: widget.role,
          otp: otp,
          themeMode: widget.themeMode,
        ),
      ),
    );

    setState(() => _isLoading = false);
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
                Text(
                  'Create Account as ${widget.role}',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: isDarkMode
                          ? AppColors.darkPrimaryText
                          : AppColors.lightPrimaryText),
                ),
                const SizedBox(height: 30),
                _buildTextField(_nameController, 'Name', isDarkMode),
                const SizedBox(height: 20),
                _buildTextField(_emailController, 'Email', isDarkMode),
                const SizedBox(height: 20),
                _buildTextField(_phoneController, 'Phone Number', isDarkMode),
                const SizedBox(height: 20),
                _buildTextField(
                    _passwordController, 'Password', isDarkMode, true),
                const SizedBox(height: 20),
                _buildTextField(_repasswordController, 'Re-enter Password',
                    isDarkMode, true),
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
                    onPressed: _register,
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
                      'Register',
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
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Already have an account? Login",
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

  Widget _buildTextField(TextEditingController controller, String label,
      bool isDarkMode, [bool isPassword = false]) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor:
        isDarkMode ? AppColors.darkSecondaryBackground : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
