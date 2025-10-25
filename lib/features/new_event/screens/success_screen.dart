import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../contacts/models/contacts.dart';

class SuccessScreen extends StatelessWidget {
  final File? image;
  final List<Contact> contacts;
  final bool isSent;

  const SuccessScreen(
      {super.key, this.image, required this.contacts, required this.isSent});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;
    final primaryColor = isDarkMode ? AppColors.darkPrimary : AppColors
        .lightPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Success',
          style: TextStyle(
            color: isDarkMode
                ? AppColors.darkPrimaryText
                : AppColors.lightPrimaryText,
          ),),
        backgroundColor: primaryColor,
        // Hide the back button
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/success.gif', height: 100),
            // User will provide the path
            const SizedBox(height: 16),
            Text(
              isSent
                  ? 'Invitation has been sent successfully'
                  : 'Invitation has been saved successfully',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? AppColors.darkPrimaryText
                    : AppColors.lightPrimaryText,
              ),
              textAlign: TextAlign.center, // <-- Added for better looks
            ),
            const SizedBox(height: 24),
            if (image != null) ...[
              Image.file(image!, height: 200, fit: BoxFit.cover),
              const SizedBox(height: 24),
            ],
            Text(
              'Guest List',
              style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode
                  ? AppColors.darkPrimaryText
                  : AppColors.lightPrimaryText,),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  title: Text(contact.name),
                  subtitle: Text(contact.phone),
                );
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // This pop will return to the HomeScreen
                // because of the pushAndRemoveUntil used to get here
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 48), // <-- Make button bigger
              ),
              child: Text('Okay',
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.darkPrimaryText
                      : AppColors.lightPrimaryText,
                  fontSize: 16, // <-- Added font size
                ),),
            ),
          ],
        ),
      ),
    );
  }
}

