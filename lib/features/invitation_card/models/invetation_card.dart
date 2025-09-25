import 'dart:ui';

class InvitationCard {
  final String category;
  final int colorValue; // Store as int for JSON
  final String eventName;
  final String location;
  final DateTime date;

  InvitationCard({
    required this.category,
    required this.colorValue,
    required this.eventName,
    required this.location,
    required this.date,
  });

  Color get color => Color(colorValue);

  Map<String, dynamic> toJson() => {
    'category': category,
    'colorValue': colorValue,
    'eventName': eventName,
    'location': location,
    'date': date.toIso8601String(),
  };

  factory InvitationCard.fromJson(Map<String, dynamic> json) => InvitationCard(
    category: json['category'],
    colorValue: json['colorValue'],
    eventName: json['eventName'],
    location: json['location'],
    date: DateTime.parse(json['date']),
  );
}