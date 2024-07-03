import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final List<String> repositories;
  final ValueChanged<List<String>> onRepositoriesChanged;

  SettingsScreen({required this.repositories, required this.onRepositoriesChanged});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late List<String> repositories;
  bool isDarkModeEnabled = false;
  String? selectedSideloadOption;

  @override
  void initState() {
    super.initState();
    repositories = widget.repositories;
  }

  void _toggleDarkMode() {
    setState(() {
      isDarkModeEnabled = !isDarkModeEnabled;
      // Implement dark mode logic here
    });
  }

  void _selectSideloadOption(String option) {
    setState(() {
      selectedSideloadOption = option;
      // Handle sideload logic here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Wi-Fi'),
            subtitle: Text('Not connected'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            title: Text('Bluetooth'),
            subtitle: Text('Off'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            title: Text('Cellular'),
            subtitle: Text('AT&T'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            title: Text('Personal Hotspot'),
            subtitle: Text('Off'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            title: Text('Notifications'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          SwitchListTile(
            title: Text('Dark Mode'),
            value: isDarkModeEnabled,
            onChanged: (value) {
              _toggleDarkMode();
            },
          ),
          Divider(),
          ListTile(
            title: Text('Privacy'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            title: Text('General'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            title: Text('Software Update'),
            subtitle: Text('iOS 15.0'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          // Sideload Section
          ExpansionTile(
            title: Text('Sideload'),
            children: [
              ListTile(
                title: Text('Select .dart File'),
                onTap: () {
                  _selectSideloadOption('Select .dart File');
                },
              ),
              ListTile(
                title: Text('Upload .dart File'),
                onTap: () {
                  _selectSideloadOption('Upload .dart File');
                },
              ),
              ListTile(
                title: Text('Paste .dart Code'),
                onTap: () {
                  _selectSideloadOption('Paste .dart Code');
                },
              ),
              // Add more sideload options as needed
            ],
          ),
        ],
      ),
    );
  }
}
