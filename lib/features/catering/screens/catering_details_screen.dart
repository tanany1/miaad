import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';  // NEW: Import
import '../../messages/screens/message_screen.dart';
import '../models/catering_items.dart';
import 'vendor_screen.dart';

class CateringDetailsScreen extends StatelessWidget {
  final CateringItem item;

  const CateringDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: SingleChildScrollView(  // NEW: Add scroll to prevent overflow
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(  // CHANGED: Use CachedNetworkImage
                imageUrl: 'https://picsum.photos/seed/details/300/200', // CHANGED
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                placeholder: (context, url) => Container(  // NEW: Loading
                  height: 200,
                  color: Colors.grey[200],
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(  // NEW: Error
                  height: 200,
                  color: Colors.grey[200],
                  child: Center(child: Icon(Icons.error, color: Colors.red)),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              item.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '${item.price.toStringAsFixed(2)} SAR',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey),
                SizedBox(width: 5),
                Expanded(  // NEW: Prevent text overflow
                  child: Text(item.location, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              item.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Suitable For',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ConstrainedBox(  // NEW: Constrain to prevent overflow
              constraints: BoxConstraints(maxHeight: 100),
              child: Wrap(
                spacing: 8,
                children: item.eventTypes.map((event) => Chip(label: Text('#$event'))).toList(),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VendorScreen(vendorName: item.brand),
                ),
              ),
              child: Text(
                'Find more at ${item.brand}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 60),  // NEW: Space for bottom button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.message, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageScreen(vendorName: item.brand),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}