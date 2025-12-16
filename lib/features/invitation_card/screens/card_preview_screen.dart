import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/screens/home_screen.dart';
import '../models/invetation_card.dart';

class CardPreviewScreen extends StatelessWidget {
  final InvitationCard card;

  const CardPreviewScreen({required this.card, super.key});

  Future<void> _saveCard(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardsJson = prefs.getStringList('saved_cards') ?? [];
      cardsJson.add(jsonEncode(card.toJson()));
      await prefs.setStringList('saved_cards', cardsJson);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card saved successfully!')),
      );

      // --- UPDATED NAVIGATION: Go to Home Screen ---
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false, // Clears the back stack completely
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving card: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Helper to determine if image is Asset or File
    bool isAsset = card.imagePath != null && card.imagePath!.contains('assets/');

    return Scaffold(
      appBar: AppBar(title: const Text('Preview Card')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Image Display Logic ---
            if (card.imagePath != null)
              Container(
                height: 300,
                width: double.infinity,
                child: isAsset
                    ? Image.asset(
                  card.imagePath!,
                  fit: BoxFit.cover,
                )
                    : Image.file(
                  File(card.imagePath!),
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 200,
                color: card.color,
                child: const Center(
                  child: Icon(Icons.image_not_supported,
                      size: 50, color: Colors.white),
                ),
              ),

            // --- Details Section ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.eventName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                      context, Icons.category, 'Category', card.category),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                      context, Icons.location_on, 'Location', card.location),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    context,
                    Icons.calendar_today,
                    'Date',
                    card.date.toLocal().toString().split(' ')[0],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => _saveCard(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'Save Card',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}