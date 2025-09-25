import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';  // NEW: Import

class VendorScreen extends StatelessWidget {
  final String vendorName;

  const VendorScreen({super.key, required this.vendorName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vendorName),
      ),
      body: SingleChildScrollView(  // NEW: Add scroll to prevent overflow
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(  // CHANGED: Use CachedNetworkImage
                imageUrl: 'https://picsum.photos/seed/vendor/300/200',  // CHANGED: From Unsplash
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Center(child: Icon(Icons.error, color: Colors.red)),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              vendorName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Email: $vendorName@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Services/Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(  // NEW: Horizontal scroll for product rows to prevent overflow
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container( // CHANGED: Use Container with fixed width
                    width: 160,
                    margin: EdgeInsets.only(right: 8),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: 'https://picsum.photos/seed/waterfall/150/150',
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                            placeholder: (context, url) => Container(
                              width: 150,
                              height: 150,
                              color: Colors.grey[200],
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 150,
                              height: 150,
                              color: Colors.grey[200],
                              child: Center(child: Icon(Icons.error, color: Colors.red)),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Product Name',
                          style: TextStyle(fontSize: 14),
                          maxLines: 1, // CHANGED
                          overflow: TextOverflow.ellipsis, // CHANGED
                        ),
                        Text(
                          'Product Description',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          maxLines: 1, // CHANGED
                          overflow: TextOverflow.ellipsis, // CHANGED
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 160,
                    margin: EdgeInsets.only(left: 8),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: 'https://picsum.photos/seed/mountain/150/150',
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                            placeholder: (context, url) => Container(
                              width: 150,
                              height: 150,
                              color: Colors.grey[200],
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 150,
                              height: 150,
                              color: Colors.grey[200],
                              child: Center(child: Icon(Icons.error, color: Colors.red)),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Adventure Photography',
                          style: TextStyle(fontSize: 14),
                          maxLines: 1, // CHANGED
                          overflow: TextOverflow.ellipsis, // CHANGED
                        ),
                        Text(
                          'With Kaylene Hutchins',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          maxLines: 1, // CHANGED
                          overflow: TextOverflow.ellipsis, // CHANGED
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(  // NEW: Horizontal scroll for additional products
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    width: 160,
                    margin: EdgeInsets.only(right: 8),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: 'https://picsum.photos/seed/people/150/150',
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                            placeholder: (context, url) => Container(
                              width: 150,
                              height: 150,
                              color: Colors.grey[200],
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 150,
                              height: 150,
                              color: Colors.grey[200],
                              child: Center(child: Icon(Icons.error, color: Colors.red)),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'How to photograph people',
                          style: TextStyle(fontSize: 14),
                          maxLines: 1, // CHANGED
                          overflow: TextOverflow.ellipsis, // CHANGED
                        ),
                        Text(
                          'With Kaylene Hutchins',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          maxLines: 1, // CHANGED
                          overflow: TextOverflow.ellipsis, // CHANGED
                        ),
                      ],
                    ),
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