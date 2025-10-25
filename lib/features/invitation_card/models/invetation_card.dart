import 'dart:ui';

class InvitationCard {
  final String category;
  final int colorValue;
  final String eventName;
  final String location;
  final DateTime date;
  final String? imagePath; // ADDED: Optional image path

  InvitationCard({
    required this.category,
    required this.colorValue,
    required this.eventName,
    required this.location,
    required this.date,
    this.imagePath, // ADDED: To constructor
  });

  Color get color => Color(colorValue);

  Map<String, dynamic> toJson() => {
    'category': category,
    'colorValue': colorValue,
    'eventName': eventName,
    'location': location,
    'date': date.toIso8601String(),
    'imagePath': imagePath, // ADDED: To JSON methods
  };

  factory InvitationCard.fromJson(Map<String, dynamic> json) => InvitationCard(
    category: json['category'] ?? json['eventType'] ?? 'General', // Handles both models
    colorValue: json['colorValue'] ?? 0xFF4FA6A8, // Provide default color
    eventName: json['eventName'],
    location: json['location'],
    date: DateTime.parse(json['date']),
    imagePath: json['imagePath'], // ADDED: From JSON methods
  );
}