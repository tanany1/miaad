import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/invetation_card.dart';
import 'card_detail_view_screen.dart';

class MyCardsScreen extends StatefulWidget {
  final bool isSelectionMode;

  const MyCardsScreen({
    super.key,
    this.isSelectionMode = false,
  });

  @override
  State<MyCardsScreen> createState() => _MyCardsScreenState();
}

class _MyCardsScreenState extends State<MyCardsScreen> {
  List<InvitationCard> _savedCards = [];

  @override
  void initState() {
    super.initState();
    _loadSavedCards();
  }

  Future<void> _loadSavedCards() async {
    final prefs = await SharedPreferences.getInstance();
    final List<InvitationCard> allCards = [];

    // Load old, color-based cards
    final oldCardsJson = prefs.getStringList('saved_cards') ?? [];
    for (var jsonStr in oldCardsJson) {
      allCards.add(InvitationCard.fromJson(jsonDecode(jsonStr)));
    }

    // Load new, image-based invitations
    final newInvitationsJson = prefs.getStringList('invitations') ?? [];
    for (var jsonStr in newInvitationsJson) {
      allCards.add(InvitationCard.fromJson(jsonDecode(jsonStr)));
    }

    setState(() {
      _savedCards = allCards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelectionMode ? 'Select a Card' : 'My Cards'),
      ),
      body: _savedCards.isEmpty
          ? const Center(child: Text('No cards saved yet.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _savedCards.length,
        itemBuilder: (context, index) {
          final card = _savedCards[index];

          // Check if image is Asset or File
          bool isAsset = card.imagePath != null &&
              card.imagePath!.contains('assets/');

          return GestureDetector(
            onTap: () {
              if (widget.isSelectionMode) {
                if (card.imagePath != null) {
                  Navigator.of(context).pop(card.imagePath);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                        Text('This card has no image to select.')),
                  );
                }
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CardDetailViewScreen(card: card),
                  ),
                );
              }
            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display image if it exists
                  if (card.imagePath != null)
                    isAsset
                        ? Image.asset(
                      card.imagePath!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                        : Image.file(
                      File(card.imagePath!),
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),

                  // Display text details
                  Container(
                    color: card.imagePath == null ? card.color : null,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.eventName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: card.imagePath == null
                                  ? Colors.white
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${card.category} - ${card.location}',
                            style: TextStyle(
                                color: card.imagePath == null
                                    ? Colors.white70
                                    : null),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            card.date.toLocal().toString().split(' ')[0],
                            style: TextStyle(
                                color: card.imagePath == null
                                    ? Colors.white70
                                    : null),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}