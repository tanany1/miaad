import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('My Profile Placeholder', style: Theme.of(context).textTheme.headlineLarge)),
    );
  }
}