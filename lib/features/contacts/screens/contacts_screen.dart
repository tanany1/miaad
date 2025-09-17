import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/colors.dart';
import '../models/contacts.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getStringList('contacts') ?? [];
    setState(() {
      _contacts = contactsJson
          .map((json) => Contact.fromMap(jsonDecode(json)))
          .toList();
      _filteredContacts = List.from(_contacts);
    });
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = _contacts
        .map((contact) => jsonEncode(contact.toMap()))
        .toList();
    await prefs.setStringList('contacts', contactsJson);
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts
          .where(
            (contact) =>
        contact.name.toLowerCase().contains(query) ||
            contact.phone.contains(query),
      )
          .toList();
    });
  }

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add New Contact',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey[50]
                        : Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey[300]!
                          : Colors.grey[600]!,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _nameController,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Name',
                      hintStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5),
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey[50]
                        : Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey[300]!
                          : Colors.grey[600]!,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      hintStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5),
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red[400]!,
                            width: 1.5,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            _nameController.clear();
                            _phoneController.clear();
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.red[400],
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              Colors.teal[400]!,
                              Colors.teal[600]!,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (_nameController.text.trim().isNotEmpty &&
                                _phoneController.text.trim().isNotEmpty) {
                              setState(() {
                                _contacts.add(
                                  Contact(
                                    name: _nameController.text.trim(),
                                    phone: _phoneController.text.trim(),
                                  ),
                                );
                                _filteredContacts = List.from(_contacts);
                              });
                              _saveContacts();
                              _nameController.clear();
                              _phoneController.clear();
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please fill in all fields'),
                                  backgroundColor: Colors.red[400],
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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

  Future<void> _showDeleteConfirmationDialog(int index) async {
    return showDialog<void>(
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
                            Navigator.pop(context);
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
                            Navigator.pop(context);
                            setState(() {
                              _contacts.removeAt(index);
                              _filteredContacts = List.from(_contacts);
                            });
                            _saveContacts();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Contact deleted successfully'),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode
        ? AppColors.darkPrimaryText
        : AppColors.lightPrimaryText;
    final secondaryTextColor = isDarkMode
        ? AppColors.darkSecondaryText
        : AppColors.lightSecondaryText;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode
                ? AppColors.darkPrimaryText
                : AppColors.lightPrimaryText,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'My Contacts',
          style: TextStyle(
            color: isDarkMode
                ? AppColors.darkPrimaryText
                : AppColors.lightPrimaryText,
          ),
        ),
        backgroundColor: AppColors.lightPrimary,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: isDarkMode
                  ? AppColors.darkPrimaryText
                  : AppColors.lightPrimaryText,
            ),
            onPressed: _showAddContactDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                hintStyle: TextStyle(color: secondaryTextColor),
                prefixIcon: Icon(Icons.search, color: secondaryTextColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: AppColors.lightAlternate),
                ),
                filled: true,
                fillColor: isDarkMode
                    ? AppColors.darkPrimaryBackground
                    : AppColors.lightSecondaryBackground,
              ),
              style: TextStyle(color: textColor),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                return Dismissible(
                  key: Key(contact.name + contact.phone),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: AppColors.lightPrimary,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                  onDismissed: (direction) {
                    _showDeleteConfirmationDialog(index);
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isDarkMode
                          ? AppColors.darkSecondary
                          : AppColors.lightSecondary,
                      child: Text(
                        contact.name[0],
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.darkPrimaryText
                              : AppColors.lightPrimaryText,
                        ),
                      ),
                    ),
                    title: Text(
                      contact.name,
                      style: TextStyle(color: textColor),
                    ),
                    subtitle: Text(
                      contact.phone,
                      style: TextStyle(color: secondaryTextColor),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tapped on ${contact.name}')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}