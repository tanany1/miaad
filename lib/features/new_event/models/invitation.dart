import 'dart:convert';
import '../../contacts/models/contacts.dart';

class Invitation {
  final String eventType;
  final String eventName;
  final DateTime date;
  final String location;
  final bool trackResponses;
  final bool sendReminder;
  final String? imagePath;
  final List<Contact> guests;
  final bool isSent; // <-- ADDED

  Invitation({
    required this.eventType,
    required this.eventName,
    required this.date,
    required this.location,
    required this.trackResponses,
    required this.sendReminder,
    this.imagePath,
    required this.guests,
    required this.isSent, // <-- ADDED
  });

  Map<String, dynamic> toMap() {
    return {
      'eventType': eventType,
      'eventName': eventName,
      'date': date.toIso8601String(),
      'location': location,
      'trackResponses': trackResponses,
      'sendReminder': sendReminder,
      'imagePath': imagePath,
      'guests': guests.map((g) => g.toMap()).toList(),
      'isSent': isSent, // <-- ADDED
    };
  }

  factory Invitation.fromMap(Map<String, dynamic> map) {
    return Invitation(
      eventType: map['eventType'] as String,
      eventName: map['eventName'] as String,
      date: DateTime.parse(map['date'] as String),
      location: map['location'] as String,
      trackResponses: map['trackResponses'] as bool,
      sendReminder: map['sendReminder'] as bool,
      imagePath: map['imagePath'] as String?,
      guests: (map['guests'] as List<dynamic>).map((m) => Contact.fromMap(m as Map<String, dynamic>)).toList(),
      // Handle potential null 'isSent' for older data
      isSent: map['isSent'] as bool? ?? false, // <-- MODIFIED to be safe
    );
  }
}

