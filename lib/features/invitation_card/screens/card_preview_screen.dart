import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/invetation_card.dart';
import 'my_cards_screen.dart';

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

      // Correct Navigation: Go to My Cards and clear the creation stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MyCardsScreen()),
            (route) => route.isFirst,
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
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Card')),
      body: Center(
        // Card preview UI remains the same
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => _saveCard(context),
          child: const Text('Save Card'),
        ),
      ),
    );
  }
}