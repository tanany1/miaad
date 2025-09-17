import 'package:flutter/material.dart';
import 'package:miaad/core/constants/colors.dart';

import '../models/catering_items.dart';
import 'catering_details_screen.dart';

class CateringScreen extends StatefulWidget {
  const CateringScreen({super.key});

  @override
  State<CateringScreen> createState() => _CateringScreenState();
}

class _CateringScreenState extends State<CateringScreen> {
  bool isGridView = true;
  bool isFilterOpen = false;
  String selectedLocation = 'All';
  String selectedEventType = 'All';
  String selectedBrand = 'All';
  double budgetMin = 0;
  double budgetMax = 1000;

  // Sample data
  final List<CateringItem> cateringItems = [
    CateringItem(
      name: 'Deluxe Wedding Package',
      price: 899.99,
      image: 'https://via.placeholder.com/300x200/B39C9C/FFFFFF?text=Wedding+Package',
      rating: 4.8,
      dateModified: DateTime.now().subtract(Duration(days: 2)),
      location: 'Riyadh',
      eventType: 'Wedding',
      brand: 'Elite Catering',
    ),
    CateringItem(
      name: 'Corporate Event Menu',
      price: 450.00,
      image: 'https://via.placeholder.com/300x200/B39C9C/FFFFFF?text=Corporate+Menu',
      rating: 4.5,
      dateModified: DateTime.now().subtract(Duration(days: 1)),
      location: 'Jeddah',
      eventType: 'Corporate',
      brand: 'Business Bites',
    ),
    CateringItem(
      name: 'Birthday Party Special',
      price: 299.99,
      image: 'https://via.placeholder.com/300x200/B39C9C/FFFFFF?text=Birthday+Special',
      rating: 4.2,
      dateModified: DateTime.now().subtract(Duration(hours: 5)),
      location: 'Riyadh',
      eventType: 'Birthday',
      brand: 'Party Perfect',
    ),
    CateringItem(
      name: 'Traditional Arabic Feast',
      price: 750.00,
      image: 'https://via.placeholder.com/300x200/B39C9C/FFFFFF?text=Arabic+Feast',
      rating: 4.9,
      dateModified: DateTime.now().subtract(Duration(days: 3)),
      location: 'Dammam',
      eventType: 'Traditional',
      brand: 'Heritage Kitchen',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              // Top Controls
              Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Sort and Filter buttons
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: _showSortOptions,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Sort',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.grey.shade300,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isFilterOpen = !isFilterOpen;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Filter',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: 16),

                    // Grid/List View Toggle
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          isGridView ? Icons.list : Icons.grid_view,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            isGridView = !isGridView;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Items Grid/List
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: isGridView ? _buildGridView() : _buildListView(),
                ),
              ),
            ],
          ),

          // Filter Sidebar
          if (isFilterOpen) _buildFilterSidebar(),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: cateringItems.length,
      itemBuilder: (context, index) {
        return _buildGridCard(cateringItems[index]);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: cateringItems.length,
      itemBuilder: (context, index) {
        return _buildListCard(cateringItems[index]);
      },
    );
  }

  Widget _buildGridCard(CateringItem item) {
    return GestureDetector(
      onTap: () => _navigateToDetails(item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFB39C9C),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                width: double.infinity,
                child: Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Content
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 12),
                        SizedBox(width: 2),
                        Text(
                          item.rating.toString(),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard(CateringItem item) {
    return GestureDetector(
      onTap: () => _navigateToDetails(item),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFFB39C9C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  Icons.restaurant,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        item.rating.toString(),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.location_on, color: Colors.grey, size: 14),
                      SizedBox(width: 2),
                      Text(
                        item.location,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSidebar() {
    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(-2, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        isFilterOpen = false;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Filter Options
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location Filter
                      _buildFilterSection('Location', selectedLocation, [
                        'All', 'Riyadh', 'Jeddah', 'Dammam'
                      ], (value) {
                        setState(() {
                          selectedLocation = value;
                        });
                      }),
                  
                      SizedBox(height: 24),
                  
                      // Event Type Filter
                      _buildFilterSection('Event Type', selectedEventType, [
                        'All', 'Wedding', 'Corporate', 'Birthday', 'Traditional'
                      ], (value) {
                        setState(() {
                          selectedEventType = value;
                        });
                      }),
                  
                      SizedBox(height: 24),
                  
                      // Brand Filter
                      _buildFilterSection('Brand', selectedBrand, [
                        'All', 'Elite Catering', 'Business Bites', 'Party Perfect', 'Heritage Kitchen'
                      ], (value) {
                        setState(() {
                          selectedBrand = value;
                        });
                      }),
                  
                      SizedBox(height: 24),
                  
                      // Budget Range
                      Text(
                        'Budget Range',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12),
                      RangeSlider(
                        values: RangeValues(budgetMin, budgetMax),
                        min: 0,
                        max: 1000,
                        divisions: 20,
                        labels: RangeLabels(
                          '\$${budgetMin.round()}',
                          '\$${budgetMax.round()}',
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            budgetMin = values.start;
                            budgetMax = values.end;
                          });
                        },
                      ),
                      Text(
                        '\$${budgetMin.round()} - \$${budgetMax.round()}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Apply Button
            Container(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isFilterOpen = false;
                    });
                    // Apply filters logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, String selectedValue, List<String> options, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        ...options.map((option) => RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: selectedValue,
          onChanged: (value) => onChanged(value!),
          contentPadding: EdgeInsets.zero,
        )),
      ],
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort by',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
          
              _buildSortOption('Name (A-Z)', Icons.sort_by_alpha),
              _buildSortOption('Name (Z-A)', Icons.sort_by_alpha),
              _buildSortOption('Date Modified (Newest)', Icons.access_time),
              _buildSortOption('Date Modified (Oldest)', Icons.access_time),
              _buildSortOption('Price (Low to High)', Icons.attach_money),
              _buildSortOption('Price (High to Low)', Icons.attach_money),
              _buildSortOption('Rating (High to Low)', Icons.star),
              _buildSortOption('Rating (Low to High)', Icons.star),
          
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        // Implement sorting logic here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sorted by: $title')),
        );
      },
    );
  }

  void _navigateToDetails(CateringItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CateringDetailsScreen(item: item),
      ),
    );
  }
}