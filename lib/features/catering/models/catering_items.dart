class CateringItem {
  final String name;
  final double price;
  final String image;
  final double rating;
  final DateTime dateModified;
  final String location;
  final List<String> eventTypes;
  final String brand;
  final String description;

  CateringItem({
    required this.name,
    required this.price,
    required this.image,
    required this.rating,
    required this.dateModified,
    required this.location,
    required this.eventTypes,
    required this.brand,
    required this.description,
  });
}