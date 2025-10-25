import 'package:flutter/material.dart';
import '../models/invetation_card.dart'; // Make sure this path is correct
import 'card_preview_screen.dart'; // Make sure this path is correct
import 'my_cards_screen.dart'; // Make sure this path is correct

// A class to hold your card template data
class CardTemplate {
  final String imageAssetPath;
  final String category;

  const CardTemplate({required this.imageAssetPath, required this.category});
}

class InvitationCardScreen extends StatefulWidget {
  const InvitationCardScreen({super.key});

  @override
  State<InvitationCardScreen> createState() => _InvitationCardScreenState();
}

class _InvitationCardScreenState extends State<InvitationCardScreen> {
  // --- STATE MANAGEMENT ---
  String selectedCategory = 'All';
  CardTemplate? selectedCardTemplate;
  // REMOVED: selectedColorValue state variable is no longer needed.

  // --- DATA ---
  final List<String> categories = ['All', 'Wedding', 'Graduation', 'Meeting', 'Baby Shower'];
  // REMOVED: The list of color palettes has been removed.

  // Your list of card templates remains the same.
  final List<CardTemplate> allCardTemplates = [
    // 5 Wedding Cards
    const CardTemplate(imageAssetPath: 'assets/Wedding/1.jpeg', category: 'Wedding'),
    const CardTemplate(imageAssetPath: 'assets/Wedding/2.jpeg', category: 'Wedding'),
    const CardTemplate(imageAssetPath: 'assets/Wedding/3.jpeg', category: 'Wedding'),
    const CardTemplate(imageAssetPath: 'assets/Wedding/4.jpeg', category: 'Wedding'),
    const CardTemplate(imageAssetPath: 'assets/Wedding/5.jpeg', category: 'Wedding'),
    const CardTemplate(imageAssetPath: 'assets/Wedding/6.jpeg', category: 'Wedding'),
    // 5 Graduation Cards
    const CardTemplate(imageAssetPath: 'assets/Graduation/1.jpeg', category: 'Graduation'),
    const CardTemplate(imageAssetPath: 'assets/Graduation/2.jpeg', category: 'Graduation'),
    const CardTemplate(imageAssetPath: 'assets/Graduation/3.jpeg', category: 'Graduation'),
    const CardTemplate(imageAssetPath: 'assets/Graduation/4.jpeg', category: 'Graduation'),
    const CardTemplate(imageAssetPath: 'assets/Graduation/5.jpeg', category: 'Graduation'),
    const CardTemplate(imageAssetPath: 'assets/Graduation/6.jpeg', category: 'Graduation'),
    // 5 Meeting Cards
    const CardTemplate(imageAssetPath: 'assets/Meeting/1.jpeg', category: 'Meeting'),
    const CardTemplate(imageAssetPath: 'assets/Meeting/2.jpeg', category: 'Meeting'),
    const CardTemplate(imageAssetPath: 'assets/Meeting/3.jpeg', category: 'Meeting'),
    const CardTemplate(imageAssetPath: 'assets/Meeting/4.jpeg', category: 'Meeting'),
    const CardTemplate(imageAssetPath: 'assets/Meeting/5.jpeg', category: 'Meeting'),
    const CardTemplate(imageAssetPath: 'assets/Meeting/6.jpeg', category: 'Meeting'),
    // 5 Baby Shower Cards
    const CardTemplate(imageAssetPath: 'assets/Baby_Shower/1.jpeg', category: 'Baby Shower'),
    const CardTemplate(imageAssetPath: 'assets/Baby_Shower/2.jpeg', category: 'Baby Shower'),
    const CardTemplate(imageAssetPath: 'assets/Baby_Shower/3.jpeg', category: 'Baby Shower'),
    const CardTemplate(imageAssetPath: 'assets/Baby_Shower/4.jpeg', category: 'Baby Shower'),
    const CardTemplate(imageAssetPath: 'assets/Baby_Shower/5.jpeg', category: 'Baby Shower'),
    const CardTemplate(imageAssetPath: 'assets/Baby_Shower/6.jpeg', category: 'Baby Shower'),
  ];

  List<CardTemplate> get filteredTemplates {
    if (selectedCategory == 'All') {
      return allCardTemplates;
    }
    return allCardTemplates.where((card) => card.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Create Invitation'),
        actions: [
          TextButton(
            onPressed: () {
              // This navigation correctly pushes the MyCardsScreen.
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
            Text('1. Select Category', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: categories.map((cat) {
                return ChoiceChip(
                  label: Text(cat),
                  selected: selectedCategory == cat,
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = cat;
                      selectedCardTemplate = null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text('2. Select a Template', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: filteredTemplates.length,
              itemBuilder: (context, index) {
                final card = filteredTemplates[index];
                final isSelected = selectedCardTemplate == card;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCardTemplate = card;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(card.imageAssetPath, fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ),

            // REMOVED: The entire section for "3. Select Color Palette" has been deleted.

            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12)),
                // CHANGED: The condition now only checks if a template is selected.
                onPressed: (selectedCardTemplate != null)
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CardDetailsScreen(
                        category: selectedCardTemplate!.category,
                        // CHANGED: A default color value is now passed directly.
                        colorValue: 0xFF4FA6A8,
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

// No changes are needed for the CardDetailsScreen.
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