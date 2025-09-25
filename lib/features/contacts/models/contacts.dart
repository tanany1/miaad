// Contact model
class Contact {
  final String name;
  final String phone;

  Contact({required this.name, required this.phone});

  // Convert Contact to Map for storage
  Map<String, String> toMap() {
    return {
      'name': name,
      'phone': phone,
    };
  }

  // Create Contact from Map
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'] as String,
      phone: map['phone'] as String,
    );
  }
}