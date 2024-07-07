import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class SettingsScreen extends StatefulWidget {
  final List<String> repositories;
  final Function(List<String>) onRepositoriesChanged;
  final Function(String) onSideloadApp;

  SettingsScreen({
    required this.repositories,
    required this.onRepositoriesChanged,
    required this.onSideloadApp,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController _repositoryController = TextEditingController();
  late TextEditingController _dartCodeController;

  @override
  void initState() {
    super.initState();
    _dartCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _repositoryController.dispose();
    _dartCodeController.dispose();
    super.dispose();
  }

  void _addRepository() {
    setState(() {
      widget.repositories.add(_repositoryController.text);
      widget.onRepositoriesChanged(widget.repositories);
      _repositoryController.clear();
    });
  }

  void _removeRepository(int index) {
    setState(() {
      widget.repositories.removeAt(index);
      widget.onRepositoriesChanged(widget.repositories);
    });
  }

  Future<void> _sideloadApp() async {
    String dartCode = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sideload App"),
        content: TextField(
          controller: _dartCodeController,
          maxLines: 10,
          decoration: InputDecoration(hintText: "Paste Dart code here"),
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(""),
          ),
          TextButton(
            child: Text("Sideload"),
            onPressed: () {
              Navigator.of(context).pop(_dartCodeController.text);
            },
          ),
        ],
      ),
    );

    if (dartCode.isNotEmpty) {
      widget.onSideloadApp(dartCode);
    }
  }

  void _changeThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            title: Text("Repositories"),
            subtitle: Column(
              children: [
                ...widget.repositories.map((repo) {
                  int index = widget.repositories.indexOf(repo);
                  return ListTile(
                    title: Text(repo),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeRepository(index),
                    ),
                  );
                }).toList(),
                TextField(
                  controller: _repositoryController,
                  decoration: InputDecoration(
                    labelText: "Add Repository",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _addRepository,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SwitchListTile(
            title: Text("Dark Mode"),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: _changeThemeMode,
          ),
          ListTile(
            title: Text("Sideload App"),
            trailing: Icon(Icons.download),
            onTap: _sideloadApp,
          ),
          ListTile(
            title: Text("Change Background"),
            trailing: Icon(Icons.image),
            onTap: () {
              // Implement background changing functionality
            },
          ),
          ListTile(
            title: Text("Wi-Fi"),
            onTap: () {
              // Implement Wi-Fi settings
            },
          ),
          ListTile(
            title: Text("Bluetooth"),
            onTap: () {
              // Implement Bluetooth settings
            },
          ),
          ListTile(
            title: Text("Sound"),
            onTap: () {
              // Implement Sound settings
            },
          ),
          ListTile(
            title: Text("Notifications"),
            onTap: () {
              // Implement Notifications settings
            },
          ),
        ],
      ),
    );
  }
}
