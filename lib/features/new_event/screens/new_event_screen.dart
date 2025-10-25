import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miaad/features/new_event/screens/success_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/colors.dart';
import '../../contacts/models/contacts.dart';
import '../../invitation_card/screens/my_cards_screen.dart';
import '../models/invitation.dart';

class NewEventScreen extends StatefulWidget {
  final Invitation? invitationToEdit; // <-- To allow editing

  // Updated constructor to accept optional invitation
  const NewEventScreen({super.key, this.invitationToEdit});

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  bool _showForm = false;
  String? _selectedEventType;
  final TextEditingController _eventNameController = TextEditingController();
  DateTime? _selectedDate;
  final TextEditingController _locationController = TextEditingController();
  bool _trackResponses = false;
  bool _sendReminder = false;
  File? _invitationImage;
  List<Contact> _contacts = [];
  final Set<Contact> _selectedContacts = {};
  bool _showGuestList = false;
  bool _isEditMode = false; // <-- To track edit state

  // --- NEW: For location logic ---
  bool _isLocationReadOnly = true;
  final FocusNode _locationFocusNode = FocusNode();
  // ---

  final List<String> _eventTypes = [
    'Wedding',
    'Graduation',
    'Meeting',
    'Party',
    'Other',
  ];
  final List<String> _locations = [
    'Venue A',
    'Venue B',
    'Venue C',
    'Venue D',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadContacts();

    // --- Pre-fill form if in edit mode ---
    if (widget.invitationToEdit != null) {
      final invitation = widget.invitationToEdit!;
      setState(() {
        _isEditMode = true;
        _showForm = true; // Skip event type selection
        _selectedEventType = invitation.eventType;
        _eventNameController.text = invitation.eventName;
        _selectedDate = invitation.date;
        _locationController.text = invitation.location;
        _trackResponses = invitation.trackResponses;
        _sendReminder = invitation.sendReminder;
        if (invitation.imagePath != null) {
          _invitationImage = File(invitation.imagePath!);
        }
        _selectedContacts.addAll(invitation.guests);

        // --- NEW: Check if location is custom ---
        if (!_locations.contains(invitation.location)) {
          _isLocationReadOnly = false;
        }
        // --- End of new code ---
      });
    }
    // --- End of pre-fill ---
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _locationController.dispose();
    _locationFocusNode.dispose(); // --- NEW: Dispose FocusNode ---
    super.dispose();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getStringList('contacts') ?? [];
    setState(() {
      _contacts = contactsJson
          .map((json) => Contact.fromMap(jsonDecode(json)))
          .toList();
    });
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'Wedding':
        return Icons.cake;
      case 'Graduation':
        return Icons.school;
      case 'Meeting':
        return Icons.meeting_room;
      case 'Party':
        return Icons.celebration;
      case 'Other':
        return Icons.event;
      default:
        return Icons.event;
    }
  }

  Future<void> _showAddCardChoice() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Invitation Card'),
          content: const Text('Choose an option to add your card.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Upload Image'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _pickImage(); // Call the original image picker
              },
            ),
            TextButton(
              child: const Text('Choose From My Cards'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog

                // Navigate to MyCardsScreen in selection mode
                final String? selectedImagePath = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyCardsScreen(isSelectionMode: true)),
                );

                // If a path was returned, update the image
                if (selectedImagePath != null && mounted) {
                  setState(() {
                    _invitationImage = File(selectedImagePath);
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _invitationImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _selectLocation() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Location'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _locations.length,
              itemBuilder: (context, index) {
                final location = _locations[index];
                return ListTile(
                  title: Text(location),
                  onTap: () => Navigator.pop(context, location),
                );
              },
            ),
          ),
        );
      },
    );

    // --- MODIFIED: Handle "Other" selection ---
    if (result != null) {
      if (result == 'Other') {
        setState(() {
          _isLocationReadOnly = false; // Make field writable
          _locationController.clear(); // Clear the word "Other"
        });
        _locationFocusNode.requestFocus(); // Focus the text field
      } else {
        setState(() {
          _isLocationReadOnly = true; // Keep field read-only
          _locationController.text = result; // Set selected location
        });
      }
    }
    // --- End of modification ---
  }

  Future<void> _saveInvitation(bool isSent) async {
    if (_selectedEventType == null ||
        _eventNameController.text.trim().isEmpty ||
        _selectedDate == null ||
        _locationController.text.trim().isEmpty ||
        _selectedContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields and select guests'),
        ),
      );
      return;
    }

    final invitation = Invitation(
      eventType: _selectedEventType!,
      eventName: _eventNameController.text.trim(),
      date: _selectedDate!,
      location: _locationController.text.trim(),
      trackResponses: _trackResponses,
      sendReminder: _sendReminder,
      imagePath: _invitationImage?.path,
      guests: _selectedContacts.toList(),
      isSent: isSent, // <-- Pass isSent status
    );

    final prefs = await SharedPreferences.getInstance();
    var invitationsJson = prefs.getStringList('invitations') ?? [];

    // --- Logic to update or add invitation ---
    if (_isEditMode) {
      // Try to find and replace the old invitation
      // A unique ID (like a timestamp or UUID) would be much safer here
      try {
        final oldInvitationMap = widget.invitationToEdit!.toMap();
        final oldInvitationJson = jsonEncode(oldInvitationMap);
        int indexToUpdate = invitationsJson.indexOf(oldInvitationJson);

        if (indexToUpdate != -1) {
          // Found it, replace it
          invitationsJson[indexToUpdate] = jsonEncode(invitation.toMap());
        } else {
          // Didn't find it (maybe it changed?), just add as new and hope for the best
          // This is a fallback. A robust solution needs a stable ID.
          invitationsJson.add(jsonEncode(invitation.toMap()));
        }
      } catch (e) {
        // Handle potential encoding errors
        invitationsJson.add(jsonEncode(invitation.toMap()));
      }
    } else {
      // Original logic: just add new invitation
      invitationsJson.add(jsonEncode(invitation.toMap()));
    }
    // --- End of new logic ---

    await prefs.setStringList('invitations', invitationsJson);

    if (mounted) {
      // --- Navigate to SuccessScreen and clear stack ---
      // This pops all routes *except* the first one (HomeScreen).
      // So when SuccessScreen pops, it will return to HomeScreen.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => SuccessScreen(
            image: _invitationImage,
            contacts: _selectedContacts.toList(),
            isSent: isSent,
          ),
        ),
            (route) => route.isFirst,
      );
    }
  }

  Widget _buildGuestList() {
    if (_contacts.isEmpty) {
      return const Center(child: Text('There is no contacts yet'));
    }
    return ListView.builder(
      itemCount: _contacts.length,
      itemBuilder: (context, index) {
        final contact = _contacts[index];
        return CheckboxListTile(
          title: Text(contact.name),
          subtitle: Text(contact.phone),
          value: _selectedContacts.contains(contact),
          onChanged: (value) {
            setState(() {
              if (value!) {
                _selectedContacts.add(contact);
              } else {
                _selectedContacts.remove(contact);
              }
            });
          },
          activeColor: Theme.of(context).primaryColor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;

    return Scaffold(
      // --- Add AppBar in edit mode ---
      appBar: _isEditMode
          ? AppBar(
        title: Text(
          'Edit Event',
          style: TextStyle(
            color: isDarkMode
                ? AppColors.darkPrimaryText
                : AppColors.lightPrimaryText,
          ),
        ),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(
          color: isDarkMode
              ? AppColors.darkPrimaryText
              : AppColors.lightPrimaryText,
        ),
      )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: !_showForm
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose Event Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.5,
              ),
              itemCount: _eventTypes.length,
              itemBuilder: (context, index) {
                final type = _eventTypes[index];
                return Card(
                  elevation: 4,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedEventType = type;
                        _showForm = true;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_getIcon(type), color: primaryColor),
                          const SizedBox(width: 16),
                          Text(
                            type,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Hide back button/title row in edit mode ---
            if (!_isEditMode)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        _showForm = false;
                      });
                    },
                  ),
                  Text(
                    _selectedEventType!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            // --- Show simple text title in edit mode ---
            if (_isEditMode)
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                child: Text(
                  'Event Type: $_selectedEventType!',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            // --- End of logic ---
            const SizedBox(height: 16),
            TextField(
              controller: _eventNameController,
              decoration: const InputDecoration(
                labelText: 'Event Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    onTap: _selectDate,
                    controller: TextEditingController(
                      text: _selectedDate == null
                          ? 'Select Date'
                          : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  // --- MODIFIED: Location TextField ---
                  child: TextField(
                    controller: _locationController,
                    readOnly: _isLocationReadOnly, // Use state variable
                    focusNode: _locationFocusNode, // Assign focus node
                    // Only trigger dialog if read-only
                    onTap: _isLocationReadOnly ? _selectLocation : null,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  // --- End of modification ---
                ),
              ],
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: Text(
                'Track Responses',
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.darkPrimaryText
                      : AppColors.lightPrimaryText,
                ),
              ),
              value: _trackResponses,
              onChanged: (value) {
                setState(() {
                  _trackResponses = value!;
                });
              },
              activeColor: primaryColor,
            ),
            CheckboxListTile(
              title: Text(
                'Send Reminder For Guest',
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.darkPrimaryText
                      : AppColors.lightPrimaryText,
                ),
              ),
              value: _sendReminder,
              onChanged: (value) {
                setState(() {
                  _sendReminder = value!;
                });
              },
              activeColor: primaryColor,
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                ElevatedButton(
                  onPressed: _showAddCardChoice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(
                    'Add Invitation Card',
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.darkPrimaryText
                          : AppColors.lightPrimaryText,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showGuestList = !_showGuestList;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(
                    'Choose Guest List',
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.darkPrimaryText
                          : AppColors.lightPrimaryText,
                    ),
                  ),
                ),
              ],
            ),
            if (_invitationImage != null) ...[
              const SizedBox(height: 16),
              Image.file(
                _invitationImage!,
                height: 200,
                fit: BoxFit.cover,
              ),
            ],
            const SizedBox(height: 8),
            Text('Selected ${_selectedContacts.length} guests'),
            if (_showGuestList) ...[
              const SizedBox(height: 16),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _buildGuestList(),
              ),
            ],
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _saveInvitation(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightAlternate,
                      foregroundColor: AppColors.lightPrimaryText,
                    ),
                    child: Text(
                      _isEditMode ? 'Save Changes' : 'Save Only', // <-- Dynamic text
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkPrimaryText
                            : AppColors.lightPrimaryText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _saveInvitation(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    child: Text(
                      _isEditMode ? 'Save and Send' : 'Send Invitation', // <-- Dynamic text
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkPrimaryText
                            : AppColors.lightPrimaryText,
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
  }
}

