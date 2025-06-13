import 'package:flutter/material.dart';
import 'package:flutter_crm/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SettingsPage with all the features
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool areNotificationsEnabled = true;
  String userName = "User Name";
  String email = "user@example.com";

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', isDarkMode);
    prefs.setBool('notifications', areNotificationsEnabled);
  }

  // Load saved settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
      areNotificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Load saved settings when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2C3E50),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Profile Settings'),
          _buildListTile(
            'Change Profile Picture',
            Icons.camera_alt,
            onTap: () {
              // Implement image picker here
            },
          ),
          _buildListTile(
            'Edit Profile',
            Icons.edit,
            onTap: () {
              // Navigate to a page where user can edit profile details
            },
          ),
          const Divider(),
          _buildSectionHeader('App Preferences'),
          _buildSwitchTile(
            'Dark Mode',
            isDarkMode,
            onChanged: (bool value) {
              setState(() {
                isDarkMode = value;
              });
              _saveSettings(); // Save setting
            },
          ),
          _buildSwitchTile(
            'Enable Notifications',
            areNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                areNotificationsEnabled = value;
              });
              _saveSettings(); // Save setting
            },
          ),
          const Divider(),
          _buildSectionHeader('Account Settings'),
          _buildListTile(
            'Change Password',
            Icons.lock,
            onTap: () {
              // Navigate to a password change screen
            },
          ),
          _buildListTile(
            'Log Out',
            Icons.exit_to_app,
            onTap: () {
              // Implement logout functionality
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          const Divider(),
          _buildSectionHeader('Privacy Settings'),
          _buildSwitchTile(
            'Share Data with Third Parties',
            false,
            onChanged: (bool value) {
              // Implement functionality to manage data sharing preferences
            },
          ),
          const Divider(),
          _buildSectionHeader('Language Preferences'),
          _buildListTile(
            'Change Language',
            Icons.language,
            onTap: () {
              // Implement functionality to change the app language
            },
          ),
        ],
      ),
    );
  }

  // Helper function to build section headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // Helper function to build a standard ListTile
  Widget _buildListTile(String title, IconData icon,
      {required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16),
      ),
      onTap: onTap,
    );
  }

  // Helper function to build a SwitchTile for preferences like dark mode
  Widget _buildSwitchTile(String title, bool value,
      {required ValueChanged<bool> onChanged}) {
    return SwitchListTile(
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
