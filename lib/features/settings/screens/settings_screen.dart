import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeMode;

  const SettingsScreen({super.key, required this.themeMode});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'English';
  late bool _isLightMode;
  double _fontSize = 16.0;
  bool _invitationsResponded = false;
  bool _newMessage = false;
  bool _eventReminder = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadThemeMode();
    // Update _isLightMode based on the current theme mode when dependencies change
    _isLightMode =
        widget.themeMode.value == ThemeMode.light ||
        (widget.themeMode.value == ThemeMode.system &&
            Theme.of(context).brightness == Brightness.light);
  }

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _invitationsResponded = prefs.getBool('invitationsResponded') ?? false;
      _newMessage = prefs.getBool('newMessage') ?? false;
      _eventReminder = prefs.getBool('eventReminder') ?? false;
      _fontSize = prefs.getDouble('fontSize') ?? 16.0;
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('invitationsResponded', _invitationsResponded);
    await prefs.setBool('newMessage', _newMessage);
    await prefs.setBool('eventReminder', _eventReminder);
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setString('selectedLanguage', _selectedLanguage);
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('themeMode');
    if (themeModeString != null) {
      widget.themeMode.value = ThemeMode.values.firstWhere(
        (mode) => mode.toString().split('.').last == themeModeString,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> _saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'themeMode',
      widget.themeMode.value.toString().split('.').last,
    );
  }

  Future<void> _clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _invitationsResponded = false;
      _newMessage = false;
      _eventReminder = false;
      _fontSize = 16.0;
      _selectedLanguage = 'English';
      widget.themeMode.value = ThemeMode.system; // Reset to system theme
    });
    _saveSettings(); // Save default values
    _saveThemeMode(); // Save reset theme mode
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Shared Preferences cleared')));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode
        ? AppColors.darkPrimaryText
        : AppColors.lightPrimaryText;

    // Custom switch theme data for reverted colors
    final switchTheme = SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return isDarkMode
              ? AppColors.darkSecondaryBackground
              : AppColors.lightSecondaryBackground; // White button when on
        }
        return isDarkMode
            ? AppColors.darkSecondary
            : AppColors.lightSecondary; // Green button when off
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return isDarkMode
              ? AppColors.darkSecondary
              : AppColors.lightSecondary; // Green background when on
        }
        return isDarkMode
            ? AppColors.darkSecondaryBackground
            : AppColors.lightSecondaryBackground; // White background when off
      }),
    );

    return Theme(
      data: Theme.of(context).copyWith(switchTheme: switchTheme),
      child: Scaffold(
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
            'Settings',
            style: TextStyle(
              color: isDarkMode
                  ? AppColors.darkPrimaryText
                  : AppColors.lightPrimaryText,
            ),
          ),
          backgroundColor: AppColors.lightPrimary,
          centerTitle: true,
        ),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Language Selection
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Language',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[100]
                            : Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedLanguage = 'English';
                              });
                              _saveSettings();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _selectedLanguage == 'English'
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                'English',
                                style: TextStyle(
                                  color: _selectedLanguage == 'English'
                                      ? Colors.white
                                      : textColor.withOpacity(0.7),
                                  fontSize: 14,
                                  fontWeight: _selectedLanguage == 'English'
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedLanguage = 'العربية';
                              });
                              _saveSettings();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _selectedLanguage == 'العربية'
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                'عربي',
                                style: TextStyle(
                                  color: _selectedLanguage == 'العربية'
                                      ? Colors.white
                                      : textColor.withOpacity(0.7),
                                  fontSize: 14,
                                  fontWeight: _selectedLanguage == 'العربية'
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: Theme.of(context).brightness == Brightness.light
                    ? const Color(0xffe0e3e7)
                    : Colors.grey[700],
              ),

              // Mode Selection
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mode',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[100]
                            : Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLightMode = true;
                                widget.themeMode.value = ThemeMode.light;
                              });
                              _saveThemeMode();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _isLightMode
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.wb_sunny_outlined,
                                    size: 16,
                                    color: _isLightMode
                                        ? Colors.white
                                        : textColor.withOpacity(0.7),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Light Mode',
                                    style: TextStyle(
                                      color: _isLightMode
                                          ? Colors.white
                                          : textColor.withOpacity(0.7),
                                      fontSize: 14,
                                      fontWeight: _isLightMode
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLightMode = false;
                                widget.themeMode.value = ThemeMode.dark;
                              });
                              _saveThemeMode();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: !_isLightMode
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.nightlight_round,
                                    size: 16,
                                    color: !_isLightMode
                                        ? Colors.white
                                        : textColor.withOpacity(0.7),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Dark Mode',
                                    style: TextStyle(
                                      color: !_isLightMode
                                          ? Colors.white
                                          : textColor.withOpacity(0.7),
                                      fontSize: 14,
                                      fontWeight: !_isLightMode
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: Theme.of(context).brightness == Brightness.light
                    ? const Color(0xffe0e3e7)
                    : Colors.grey[700],
              ),
              // Font Size Slider
              ListTile(
                title: Text('Font Size', style: TextStyle(color: textColor)),
                subtitle: Slider(
                  value: _fontSize,
                  min: 12.0,
                  max: 24.0,
                  divisions: 12,
                  activeColor: AppColors.lightPrimary,
                  inactiveColor: AppColors.lightAlternate,
                  label: _fontSize.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _fontSize = value;
                    });
                    _saveSettings();
                  },
                ),
              ),
              const Divider(color: Color(0xffe0e3e7)),

              // Notification Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Notification',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              SwitchListTile(
                title: Text(
                  'Invitations Responded',
                  style: TextStyle(color: textColor),
                ),
                subtitle: Text(
                  'You will be notified when all guests have responded to your invitation.',
                  style: TextStyle(
                    color: isDarkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                ),
                value: _invitationsResponded,
                activeColor: AppColors.lightPrimary,
                onChanged: (bool value) {
                  setState(() {
                    _invitationsResponded = value;
                  });
                  _saveSettings();
                },
              ),
              SwitchListTile(
                title: Text('New Message', style: TextStyle(color: textColor)),
                subtitle: Text(
                  'You will be alerted when a service provider sends you a new message.',
                  style: TextStyle(
                    color: isDarkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                ),
                value: _newMessage,
                activeColor: AppColors.lightPrimary,
                onChanged: (bool value) {
                  setState(() {
                    _newMessage = value;
                  });
                  _saveSettings();
                },
              ),
              SwitchListTile(
                title: Text(
                  '24-Hour Event Reminder',
                  style: TextStyle(color: textColor),
                ),
                subtitle: Text(
                  'You will receive a reminder 24 hours before your event starts.',
                  style: TextStyle(
                    color: isDarkMode
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                ),
                value: _eventReminder,
                activeColor: AppColors.lightPrimary,
                onChanged: (bool value) {
                  setState(() {
                    _eventReminder = value;
                  });
                  _saveSettings();
                },
              ),

              // Clear Shared Preferences Button
              ListTile(
                title: Text(
                  'Clear All Data',
                  style: TextStyle(color: textColor),
                ),
                trailing: ElevatedButton(
                  onPressed: _clearSharedPreferences,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightPrimary,
                    foregroundColor: isDarkMode
                        ? AppColors.darkPrimaryText
                        : AppColors.lightPrimaryText,
                  ),
                  child: const Text('Clear'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
