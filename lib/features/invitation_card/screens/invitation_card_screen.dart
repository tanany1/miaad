import 'package:flutter/material.dart';
import '../models/invetation_card.dart';
import 'card_preview_screen.dart';
import 'my_cards_screen.dart';

class InvitationCardScreen extends StatefulWidget {
  const InvitationCardScreen({super.key});

  @override
  State<InvitationCardScreen> createState() => _InvitationCardScreenState();
}

class _InvitationCardScreenState extends State<InvitationCardScreen> {
  String? selectedCategory;
  int? selectedColorValue;
  final List<String> categories = ['Wedding', 'Graduation', 'Meeting' ,'Party', 'Other'];
  final List<Color> palettes = [
    const Color(0xFF4FA6A8),
    const Color(0xFF39D2C0),
    const Color(0xFF6D5FED),
    const Color(0xFFE0E3E7),
    const Color(0xFF37FFFF),
  ]; // Derived from AppColors for variety

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyCardsScreen()),
              );
            },
            child: const Text('My Cards', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Category', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: categories.map((cat) => ChoiceChip(
                label: Text(cat),
                selected: selectedCategory == cat,
                onSelected: (selected) {
                  setState(() {
                    selectedCategory = selected ? cat : null;
                  });
                },
              )).toList(),
            ),
            const SizedBox(height: 32),
            Text('Select Color Palette', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: palettes.map((color) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColorValue = color.value;
                  });
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(
                      color: selectedColorValue == color.value ? Colors.black : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: selectedColorValue == color.value
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                ),
              )).toList(),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: (selectedCategory != null && selectedColorValue != null)
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CardDetailsScreen(
                        category: selectedCategory!,
                        colorValue: selectedColorValue!,
                      ),
                    ),
                  );
                }
                    : null,
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardDetailsScreen extends StatefulWidget {
  final String category;
  final int colorValue;

  const CardDetailsScreen({
    required this.category,
    required this.colorValue,
    super.key,
  });

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Card Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _eventNameController,
              decoration: const InputDecoration(labelText: 'Event Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                _selectedDate == null ? 'Select Date' : _selectedDate!.toLocal().toString().split(' ')[0],
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: (_eventNameController.text.isNotEmpty &&
                  _locationController.text.isNotEmpty &&
                  _selectedDate != null)
                  ? () {
                final card = InvitationCard(
                  category: widget.category,
                  colorValue: widget.colorValue,
                  eventName: _eventNameController.text,
                  location: _locationController.text,
                  date: _selectedDate!,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CardPreviewScreen(card: card),
                  ),
                );
              }
                  : null,
              child: const Text('Create Card'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}