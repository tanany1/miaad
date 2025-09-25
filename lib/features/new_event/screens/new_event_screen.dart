import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miaad/features/new_event/screens/success_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/colors.dart';
import '../../contacts/models/contacts.dart';
import '../models/invitation.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({super.key});

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
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _locationController.dispose();
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
      initialDate: DateTime.now(),
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
    if (result != null) {
      setState(() {
        _locationController.text = result;
      });
    }
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
    );

    final prefs = await SharedPreferences.getInstance();
    var invitationsJson = prefs.getStringList('invitations') ?? [];
    invitationsJson.add(jsonEncode(invitation.toMap()));
    await prefs.setStringList('invitations', invitationsJson);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(
          image: _invitationImage,
          contacts: _selectedContacts.toList(),
          isSent: isSent,
        ),
      ),
    );
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
                        child: TextField(
                          controller: _locationController,
                          readOnly: true,
                          onTap: _selectLocation,
                          decoration: const InputDecoration(
                            labelText: 'Location',
                            border: OutlineInputBorder(),
                          ),
                        ),
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
                        onPressed: _pickImage,
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
                            'Save Only',
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
                            'Send Invitation',
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
