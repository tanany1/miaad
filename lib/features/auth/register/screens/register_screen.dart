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
  // --- Common Controllers ---
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();

  // --- User Specific Controllers ---
  final TextEditingController _phoneController = TextEditingController();

  // --- Vendor Specific Controllers ---
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _businessDescController = TextEditingController();
  final TextEditingController _docLinkController = TextEditingController();
  String? _selectedCategory;
  final List<String> _categories = [
    'Venue',
    'Photography',
    'Decoration',
    'Catering',
    'Other'
  ];

  String? _errorMessage;
  bool _isLoading = false;

  // --- OTP Email Sending Logic (For Regular Users) ---
  Future<void> _sendOtpEmail(String otp, String recipientEmail) async {
    final String username = 'miaad.app@gmail.com';
    final String password = 'mkia mbyp peas qdmy'; // Use App Password

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Miaad App')
      ..recipients.add(recipientEmail)
      ..subject = 'Your Verification Code'
      ..html = "<h3>Your verification code is:</h3>\n<h1>$otp</h1>";

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      print('Message not sent. \n$e');
      setState(() {
        _errorMessage = "Failed to send OTP. Please try again.";
        _isLoading = false;
      });
    }
  }

  // --- Regular User Registration Logic ---
  void _registerUser() async {
    if (_isLoading) return;

    if (_passwordController.text != _repasswordController.text) {
      setState(() => _errorMessage = "Passwords do not match");
      return;
    }

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

    String otp = (100000 + Random().nextInt(900000)).toString();
    await _sendOtpEmail(otp, _emailController.text.trim());

    if (!mounted || _errorMessage != null) return;

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

  // --- Vendor Application Logic ---
  void _submitVendorApplication() {
    // 1. Validate Fields
    if (_nameController.text.isEmpty ||
        _selectedCategory == null ||
        _emailController.text.isEmpty ||
        _confirmEmailController.text.isEmpty ||
        _businessDescController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _repasswordController.text.isEmpty ||
        _docLinkController.text.isEmpty) {
      setState(() => _errorMessage = "Please fill in all fields.");
      return;
    }

    if (_emailController.text != _confirmEmailController.text) {
      setState(() => _errorMessage = "Email addresses do not match.");
      return;
    }

    if (_passwordController.text != _repasswordController.text) {
      setState(() => _errorMessage = "Passwords do not match.");
      return;
    }

    // 2. Show Success Dialog
    showDialog(
      context: context,
      barrierDismissible: false, // User must click OK
      builder: (BuildContext ctx) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.sentiment_satisfied_alt_rounded,
                size: 80,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              const SizedBox(height: 20),
              Text(
                "Thank you",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Your application will be reviewed and you will receive an email from us soon",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Close dialog
                    Navigator.of(ctx).pop();
                    // Return back to Onboarding (Assuming Onboarding is the first route)
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check role to decide which layout to show
    if (widget.role.toLowerCase() == 'vendor') {
      return _buildVendorLayout(context);
    } else {
      return _buildUserLayout(context);
    }
  }

  // --- Layout 1: Vendor Form ---
  Widget _buildVendorLayout(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
    isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Welcome',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? AppColors.darkPrimaryText
                      : AppColors.lightPrimaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tell us about your business to get started',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),

              // Vendor Fields
              _buildTextField(_nameController, 'Name', isDarkMode),
              const SizedBox(height: 16),
              _buildDropdownField(isDarkMode),
              const SizedBox(height: 16),
              _buildTextField(_emailController, 'Email', isDarkMode,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildTextField(_confirmEmailController, 'Confirm email', isDarkMode,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildTextField(_businessDescController,
                  'Describe your business in up to 200 characters', isDarkMode,
                  maxLines: 4, maxLength: 200),
              // Note: maxLength automatically adds a counter (0/200)

              _buildTextField(_passwordController, 'Password', isDarkMode,
                  isPassword: true),
              const SizedBox(height: 16),
              _buildTextField(
                  _repasswordController, 'Confirm password', isDarkMode,
                  isPassword: true),
              const SizedBox(height: 16),
              _buildTextField(_docLinkController,
                  'Upload required documents via Google Drive link', isDarkMode,
                  keyboardType: TextInputType.url),

              const SizedBox(height: 24),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),

              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitVendorApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Submit application',
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
                  Navigator.pop(context); // Go back to Login/Role selection
                },
                child: RichText(
                  text: TextSpan(
                    text: "Already a provider? ",
                    style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[700]),
                    children: [
                      TextSpan(
                        text: "Sign in here",
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- Layout 2: Regular User Form (Original) ---
  Widget _buildUserLayout(BuildContext context) {
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
                _buildTextField(_emailController, 'Email', isDarkMode,
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 20),
                _buildTextField(_phoneController, 'Phone Number', isDarkMode,
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 20),
                _buildTextField(
                    _passwordController, 'Password', isDarkMode,
                    isPassword: true),
                const SizedBox(height: 20),
                _buildTextField(_repasswordController, 'Re-enter Password',
                    isDarkMode, isPassword: true),
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
                    onPressed: _registerUser,
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

  // --- Helper Widgets ---

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      bool isDarkMode, {
        bool isPassword = false,
        int maxLines = 1,
        int? maxLength,
        TextInputType? keyboardType,
      }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor:
        isDarkMode ? AppColors.darkSecondaryBackground : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        // Hide default counter if you prefer, or keep it for the description
        counterText: maxLength != null ? null : "",
      ),
    );
  }

  Widget _buildDropdownField(bool isDarkMode) {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      items: _categories
          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
          .toList(),
      onChanged: (val) => setState(() => _selectedCategory = val),
      decoration: InputDecoration(
        labelText: 'Choose your business category',
        filled: true,
        fillColor:
        isDarkMode ? AppColors.darkSecondaryBackground : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      dropdownColor:
      isDarkMode ? AppColors.darkSecondaryBackground : Colors.white,
    );
  }
}