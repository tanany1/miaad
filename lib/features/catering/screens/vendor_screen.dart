import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VendorScreen extends StatelessWidget {
  final String vendorName;

  const VendorScreen({super.key, required this.vendorName});

  @override
  Widget build(BuildContext context) {
    // REMOVED: The Scaffold no longer has an AppBar.
    // We use a Stack to place a custom back button over the main content.
    return Scaffold(
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top header image
                CachedNetworkImage(
                  imageUrl: 'https://picsum.photos/seed/photographer/600/400',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.error)),
                  ),
                ),

                // 2. Profile information section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vendorName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '@username',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Bio: Passionate photographer capturing life\'s best moments.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Floating chat icon
                      FloatingActionButton(
                        onPressed: () {
                          // TODO: Handle chat button press
                        },
                        elevation: 2,
                        backgroundColor: Colors.cyan.shade50,
                        child: Icon(
                          Icons.messenger_outline_rounded,
                          color: Colors.cyan.shade800,
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. "Services/Products" Divider Text
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: Text(
                      'Services/Products',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),

                // 4. Vertical list of services/products
                // REPLACED: The horizontal SingleChildScrollView is replaced with a Column.
                Column(
                  children: [
                    _buildServiceListItem(
                      context: context,
                      title: 'Product Name',
                      description: 'Product Discription',
                      imageUrl: 'https://picsum.photos/seed/waterfall/150/150',
                    ),
                    _buildServiceListItem(
                      context: context,
                      title: 'Adventure Photography',
                      description: 'With Kaylene Huchtins',
                      imageUrl: 'https://picsum.photos/seed/mountain/150/150',
                    ),
                    _buildServiceListItem(
                      context: context,
                      title: 'How to photograph people',
                      description: 'With Kaylene Huchtins',
                      imageUrl: 'https://picsum.photos/seed/people/150/150',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 5. Custom back button overlaid on top
          Positioned(
            top: 40.0, // Adjust this value based on the device's status bar
            left: 16.0,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NEW: Helper widget to build each item in the services list
  Widget _buildServiceListItem({
    required BuildContext context,
    required String title,
    required String description,
    required String imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          // Text section on the left
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Image on the right
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}