import 'dart:io';
import 'package:flutter/material.dart';
import '../models/invetation_card.dart';

class CardDetailViewScreen extends StatelessWidget {
  final InvitationCard card;

  const CardDetailViewScreen({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(card.eventName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (card.imagePath != null)
              Image.file(
                File(card.imagePath!),
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 200,
                color: card.color,
                child: Center(
                  child: Text(
                    card.eventName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Details',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Divider(height: 24),
                  ListTile(
                    leading: const Icon(Icons.category),
                    title: const Text('Category'),
                    subtitle: Text(card.category),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: const Text('Location'),
                    subtitle: Text(card.location),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Date'),
                    subtitle: Text(card.date.toLocal().toString().split(' ')[0]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}