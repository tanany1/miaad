import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../new_event/models/invitation.dart';

class DetailsScreen extends StatefulWidget {
  final Invitation invitation;

  const DetailsScreen({super.key, required this.invitation});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  // Mock response states for demonstration
  final Map<String, String> _guestResponses = {};

  @override
  void initState() {
    super.initState();
    // Initialize all guest responses to 'Pending'
    for (var guest in widget.invitation.guests) {
      _guestResponses[guest.name] = 'Pending';
    }
  }

  IconData _getEventIcon(String eventType) {
    switch (eventType) {
      case 'Wedding':
        return Icons.cake;
      case 'Graduation':
        return Icons.school;
      case 'Meeting':
        return Icons.meeting_room;
      case 'Party':
        return Icons.celebration;
      default:
        return Icons.event;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Color _getStatusColor(String status, bool isDarkMode) {
    switch (status) {
      case 'Attending':
        return Colors.green;
      case 'Pending':
        return Colors.yellow;
      case 'Declined':
        return Colors.red;
      default:
        return isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText;
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
            size: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode
                        ? AppColors.darkPrimaryText
                        : AppColors.lightPrimaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestTable(bool isDarkMode) {
    return Card(
      color: isDarkMode ? AppColors.darkSecondaryBackground : AppColors.lightSecondaryBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guest List (${widget.invitation.guests.length})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
            ),
            const SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1.5),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDarkMode ? AppColors.darkAlternate : AppColors.lightAlternate,
                      ),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Phone',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                    ),
                  ],
                ),
                ...widget.invitation.guests.map((guest) {
                  final status = _guestResponses[guest.name] ?? 'Pending';
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          guest.name,
                          style: TextStyle(
                            color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          guest.phone,
                          style: TextStyle(
                            color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status, isDarkMode).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getStatusColor(status, isDarkMode),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: _getStatusColor(status, isDarkMode),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Event Details',
          style: TextStyle(
            color: isDarkMode ? AppColors.darkPrimaryText : Colors.white,
          ),
        ),
        backgroundColor: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
        iconTheme: IconThemeData(
          color: isDarkMode ? AppColors.darkPrimaryText : Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Header
            Card(
              color: isDarkMode ? AppColors.darkSecondaryBackground : AppColors.lightSecondaryBackground,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getEventIcon(widget.invitation.eventType),
                            color: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.invitation.eventName,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                                ),
                              ),
                              Text(
                                widget.invitation.eventType,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildInfoRow(Icons.calendar_today, 'Date', _formatDate(widget.invitation.date), isDarkMode),
                    _buildInfoRow(Icons.location_on, 'Location', widget.invitation.location, isDarkMode),
                    _buildInfoRow(Icons.people, 'Guests', '${widget.invitation.guests.length} invited', isDarkMode),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Invitation Image
            if (widget.invitation.imagePath != null) ...[
              Card(
                color: isDarkMode ? AppColors.darkSecondaryBackground : AppColors.lightSecondaryBackground,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invitation Card',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: GestureDetector(
                          onTap: () => _showImageDialog(context, widget.invitation.imagePath!),
                          child: Hero(
                            tag: 'invitation_image_${widget.invitation.imagePath}',
                            child: Image.file(
                              File(widget.invitation.imagePath!),
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            // Guest List Table
            _buildGuestTable(isDarkMode),
          ],
        ),
      ),
    );
  }

  Future<void> _showImageDialog(BuildContext context, String imagePath) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: double.infinity,
            height: 400,
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}