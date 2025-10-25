import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/colors.dart';
import '../../new_event/models/invitation.dart';
import 'details_screen.dart';
import '../../new_event/screens/new_event_screen.dart'; // <-- IMPORT for editing

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Invitation> _invitations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInvitations();
  }

  Future<void> _loadInvitations() async {
    final prefs = await SharedPreferences.getInstance();
    final invitationsJson = prefs.getStringList('invitations') ?? [];
    setState(() {
      _invitations = invitationsJson
          .map((json) => Invitation.fromMap(jsonDecode(json)))
          .toList();
      _isLoading = false;
    });
  }

  Future<void> _saveInvitations() async {
    final prefs = await SharedPreferences.getInstance();
    final invitationsJson = _invitations
        .map((invitation) => jsonEncode(invitation.toMap()))
        .toList();
    await prefs.setStringList('invitations', invitationsJson);
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
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildEventCard(Invitation invitation) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode
        ? AppColors.darkSecondaryBackground
        : AppColors.lightSecondaryBackground;

    return Dismissible(
      key: Key(invitation.eventName + invitation.date.toIso8601String()), // More unique key
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) async {
        // Find index safely
        int index = _invitations.indexOf(invitation);
        if (index != -1) {
          final shouldDelete = await _showDeleteConfirmationDialog(index);
          return shouldDelete ?? false;
        }
        return false;
      },
      onDismissed: (direction) {
        // This is now handled inside _showDeleteConfirmationDialog to avoid state errors
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: cardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // --- MODIFIED: Navigate based on isSent status ---
            if (invitation.isSent) {
              // If sent, go to details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(invitation: invitation),
                ),
              );
            } else {
              // If saved, go to edit screen (NewEventScreen)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewEventScreen(invitationToEdit: invitation),
                ),
              ).then((_) {
                // Refresh the list when returning from edit screen
                _loadInvitations();
              });
            }
            // --- End of modification ---
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getEventIcon(invitation.eventType),
                      color: isDarkMode
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        invitation.eventName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? AppColors.darkPrimaryText
                              : AppColors.lightPrimaryText,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10, // More padding
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        // --- MODIFIED: Change color based on isSent status ---
                        color: invitation.isSent
                            ? (isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary).withOpacity(0.8)
                            : (isDarkMode ? Colors.grey[700] : Colors.grey[400]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        // --- MODIFIED: Show 'Sent' or 'Saved' ---
                        invitation.isSent ? 'Sent' : 'Saved',
                        style: TextStyle(
                          color: invitation.isSent
                              ? (isDarkMode ? AppColors.darkPrimaryText : Colors.white)
                              : (isDarkMode ? Colors.white70 : Colors.black87),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(invitation.date),
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        invitation.location,
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.darkSecondaryText
                              : AppColors.lightSecondaryText,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 16,
                      color: isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${invitation.guests.length} participants invited',
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      // --- MODIFIED: Show correct prompt ---
                      invitation.isSent ? 'Tap for details' : 'Tap to edit',
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note,
            size: 80,
            color: isDarkMode
                ? AppColors.darkSecondaryText
                : AppColors.lightSecondaryText,
          ),
          const SizedBox(height: 16),
          Text(
            'No events scheduled',
            style: TextStyle(
              fontSize: 18,
              color: isDarkMode
                  ? AppColors.darkSecondaryText
                  : AppColors.lightSecondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first invitation to get started',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode
                  ? AppColors.darkSecondaryText
                  : AppColors.lightSecondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(int index) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you Sure?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red[400]!,
                            width: 1.5,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              false,
                            ); // Return false on cancel
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.red[400],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.teal[500],
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _invitations.removeAt(index);
                              _saveInvitations();
                            });
                            Navigator.pop(
                              context,
                              true,
                            ); // Return true on delete
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Invitation deleted successfully',
                                ),
                                backgroundColor: Colors.teal[500],
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: _invitations.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
        onRefresh: _loadInvitations,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: _invitations.length,
          itemBuilder: (context, index) {
            return _buildEventCard(_invitations[index]);
          },
        ),
      ),
    );
  }
}

