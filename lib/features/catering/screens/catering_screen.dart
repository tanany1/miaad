import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      name: 'Coffee',
      price: 12,
      image: 'https://picsum.photos/seed/coffee/300/200', // CHANGED
      rating: 4.8,
      dateModified: DateTime.now().subtract(Duration(days: 2)),
      location: 'Riyadh',
      eventTypes: ['Wedding', 'Baby Shower', 'Graduation'],
      brand: 'Mahaseel Albon',
      description: 'A smooth, rich coffee with bold flavor and a hint of chocolate. Freshly roasted for the perfect cup, every time.',
    ),
    CateringItem(
      name: 'Tea Service',
      price: 10,
      image: 'https://picsum.photos/seed/tea/300/200', // CHANGED
      rating: 4.5,
      dateModified: DateTime.now().subtract(Duration(days: 1)),
      location: 'Jeddah',
      eventTypes: ['Corporate', 'Baby Shower'],
      brand: 'Mahaseel Albon',
      description: 'Premium tea selection with herbal and black varieties for any event.',
    ),
    CateringItem(
      name: 'Deluxe Wedding Package',
      price: 899.99,
      image: 'https://picsum.photos/seed/weddingfood/300/200', // CHANGED
      rating: 4.8,
      dateModified: DateTime.now().subtract(Duration(days: 2)),
      location: 'Riyadh',
      eventTypes: ['Wedding'],
      brand: 'Elite Catering',
      description: 'Luxurious catering for weddings with multi-course meals and desserts.',
    ),
    CateringItem(
      name: 'Basic Wedding Catering',
      price: 500,
      image: 'https://picsum.photos/seed/weddingdinner/300/200', // CHANGED
      rating: 4.3,
      dateModified: DateTime.now().subtract(Duration(days: 4)),
      location: 'Dammam',
      eventTypes: ['Wedding'],
      brand: 'Elite Catering',
      description: 'Affordable yet elegant catering options for your special day.',
    ),
    CateringItem(
      name: 'Premium Wedding Feast',
      price: 1200,
      image: 'https://picsum.photos/seed/feast/300/200', // CHANGED
      rating: 4.9,
      dateModified: DateTime.now().subtract(Duration(days: 3)),
      location: 'Jeddah',
      eventTypes: ['Wedding'],
      brand: 'Elite Catering',
      description: 'Exquisite dishes for large wedding celebrations.',
    ),
    CateringItem(
      name: 'Corporate Event Menu',
      price: 450.00,
      image: 'https://picsum.photos/seed/corporateevent/300/200', // CHANGED
      rating: 4.5,
      dateModified: DateTime.now().subtract(Duration(days: 1)),
      location: 'Jeddah',
      eventTypes: ['Corporate'],
      brand: 'Business Bites',
      description: 'Professional catering for business meetings and events.',
    ),
    CateringItem(
      name: 'Executive Lunch Box',
      price: 300,
      image: 'https://picsum.photos/seed/lunch/300/200', // CHANGED
      rating: 4.4,
      dateModified: DateTime.now().subtract(Duration(days: 5)),
      location: 'Riyadh',
      eventTypes: ['Corporate'],
      brand: 'Business Bites',
      description: 'Convenient lunch boxes for corporate teams.',
    ),
    CateringItem(
      name: 'Birthday Party Special',
      price: 299.99,
      image: 'https://picsum.photos/seed/birthdayparty/300/200', // CHANGED
      rating: 4.2,
      dateModified: DateTime.now().subtract(Duration(hours: 5)),
      location: 'Riyadh',
      eventTypes: ['Birthday'],
      brand: 'Party Perfect',
      description: 'Fun and festive catering for birthday celebrations.',
    ),
    CateringItem(
      name: 'Kids Birthday Menu',
      price: 200,
      image: 'https://picsum.photos/seed/kidsparty/300/200', // CHANGED
      rating: 4.6,
      dateModified: DateTime.now().subtract(Duration(days: 6)),
      location: 'Dammam',
      eventTypes: ['Birthday'],
      brand: 'Party Perfect',
      description: 'Child-friendly meals and snacks for kids parties.',
    ),
    CateringItem(
      name: 'Traditional Arabic Feast',
      price: 750.00,
      image: 'https://picsum.photos/seed/arabicfood/300/200', // CHANGED
      rating: 4.9,
      dateModified: DateTime.now().subtract(Duration(days: 3)),
      location: 'Dammam',
      eventTypes: ['Traditional'],
      brand: 'Heritage Kitchen',
      description: 'Authentic Arabic dishes for traditional gatherings.',
    ),
    CateringItem(
      name: 'Family Gathering Meal',
      price: 600,
      image: 'https://picsum.photos/seed/familydinner/300/200', // CHANGED
      rating: 4.7,
      dateModified: DateTime.now().subtract(Duration(days: 7)),
      location: 'Jeddah',
      eventTypes: ['Traditional'],
      brand: 'Heritage Kitchen',
      description: 'Hearty meals for family and traditional events.',
    ),
    CateringItem(
      name: 'Cultural Dinner',
      price: 800,
      image: 'https://picsum.photos/seed/dinner/300/200', // CHANGED
      rating: 4.8,
      dateModified: DateTime.now().subtract(Duration(days: 8)),
      location: 'Riyadh',
      eventTypes: ['Traditional'],
      brand: 'Heritage Kitchen',
      description: 'Cultural cuisine with a traditional twist.',
    ),
  ];

  late List<CateringItem> filteredItems;

  @override
  void initState() {
    super.initState();
    filteredItems = cateringItems;
    applyFilters();
  }

  void applyFilters() {
    setState(() {
      filteredItems = cateringItems.where((item) {
        final matchesLocation = selectedLocation == 'All' || item.location == selectedLocation;
        final matchesEventType = selectedEventType == 'All' || item.eventTypes.contains(selectedEventType);
        final matchesBrand = selectedBrand == 'All' || item.brand == selectedBrand;
        final matchesBudget = item.price >= budgetMin && item.price <= budgetMax;
        return matchesLocation && matchesEventType && matchesBrand && matchesBudget;
      }).toList();
    });
  }

  Color? _getChipColor(String eventType) {
    switch (eventType) {
      case 'Wedding':
        return Colors.lightBlue[100];
      case 'Baby Shower':
        return Colors.purple[100];
      case 'Graduation':
        return Colors.pink[100];
      case 'Corporate':
        return Colors.green[100];
      case 'Birthday':
        return Colors.orange[100];
      case 'Traditional':
        return Colors.brown[100];
      default:
        return Colors.grey[100];
    }
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.6, // Adjusted for more content
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        return _buildGridCard(filteredItems[index]);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        return _buildListCard(filteredItems[index]);
      },
    );
  }

  Widget _buildGridCard(CateringItem item) {
    String username = item.brand.toLowerCase().replaceAll(' ', '');
    String website = 'https://$username.com/';
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
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: CachedNetworkImage(
                        imageUrl: item.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 150,
                        placeholder: (context, url) => Container(
                          width: double.infinity,
                          height: 150,
                          color: Colors.grey[200],
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: double.infinity,
                          height: 150,
                          color: Colors.grey[200],
                          child: Center(child: Icon(Icons.error, color: Colors.red)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Flexible( // CHANGED: Make content take remaining space
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '@$username',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible( // CHANGED: Prevent overflow in name
                            child: Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.teal[300],
                            radius: 16,
                            child: Icon(
                              Icons.more,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${item.price.toStringAsFixed(0)} SAR at ${item.location}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                        maxLines: 1, // CHANGED
                        overflow: TextOverflow.ellipsis, // CHANGED
                      ),
                      SizedBox(height: 8),
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListCard(CateringItem item) {
    String username = item.brand.toLowerCase().replaceAll(' ', '');
    String website = 'https://$username.com/';
    return GestureDetector(
      onTap: () => _navigateToDetails(item),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                  child: SizedBox(
                    width: 120, // CHANGED: Reduce width to prevent overflow
                    height: 180, // CHANGED: Reduce height to prevent overflow
                    child: CachedNetworkImage(
                      imageUrl: item.image,
                      fit: BoxFit.cover,
                      width: 120,
                      height: 120,
                      placeholder: (context, url) => Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey[200],
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey[200],
                        child: Center(child: Icon(Icons.error, color: Colors.red)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@$username',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.teal[300],
                          radius: 16,
                          child: Icon(
                            Icons.more,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${item.price.toStringAsFixed(0)} SAR at ${item.location}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 2, // CHANGED: Reduce maxLines to prevent overflow
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Suitable For',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: item.eventTypes.map((e) => Chip(
                        label: Text('#$e'),
                        backgroundColor: _getChipColor(e),
                        labelStyle: TextStyle(fontSize: 12),
                      )).toList(),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Find more $website',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFilterSection('Location', selectedLocation, [
                        'All',
                        'Riyadh',
                        'Jeddah',
                        'Dammam'
                      ], (value) {
                        setState(() {
                          selectedLocation = value;
                          applyFilters();
                        });
                      }),
                      SizedBox(height: 24),
                      _buildFilterSection('Event Type', selectedEventType, [
                        'All',
                        'Wedding',
                        'Corporate',
                        'Birthday',
                        'Traditional',
                        'Baby Shower',
                        'Graduation'
                      ], (value) {
                        setState(() {
                          selectedEventType = value;
                          applyFilters();
                        });
                      }),
                      SizedBox(height: 24),
                      _buildFilterSection('Brand', selectedBrand, [
                        'All',
                        'Mahaseel Albon',
                        'Elite Catering',
                        'Business Bites',
                        'Party Perfect',
                        'Heritage Kitchen'
                      ], (value) {
                        setState(() {
                          selectedBrand = value;
                          applyFilters();
                        });
                      }),
                      SizedBox(height: 24),
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
                        max: 1200,
                        divisions: 24,
                        labels: RangeLabels(
                          '${budgetMin.round()} SAR',
                          '${budgetMax.round()} SAR',
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            budgetMin = values.start;
                            budgetMax = values.end;
                            applyFilters();
                          });
                        },
                      ),
                      Text(
                        '${budgetMin.round()} - ${budgetMax.round()} SAR',
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
        _sortList(title);
      },
    );
  }

  void _sortList(String type) {
    setState(() {
      if (type == 'Name (A-Z)') {
        filteredItems.sort((a, b) => a.name.compareTo(b.name));
      } else if (type == 'Name (Z-A)') {
        filteredItems.sort((a, b) => b.name.compareTo(a.name));
      } else if (type == 'Date Modified (Newest)') {
        filteredItems.sort((a, b) => b.dateModified.compareTo(a.dateModified));
      } else if (type == 'Date Modified (Oldest)') {
        filteredItems.sort((a, b) => a.dateModified.compareTo(b.dateModified));
      } else if (type == 'Price (Low to High)') {
        filteredItems.sort((a, b) => a.price.compareTo(b.price));
      } else if (type == 'Price (High to Low)') {
        filteredItems.sort((a, b) => b.price.compareTo(a.price));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sorted by: $type')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                isFilterOpen = !isFilterOpen;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: isGridView ? _buildGridView() : _buildListView(),
          ),
          if (isFilterOpen) _buildFilterSidebar(),
        ],
      ),
    );
  }
}