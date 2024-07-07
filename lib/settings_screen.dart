import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final List<String> repositories;
  final Function(List<String>) onRepositoriesChanged;
  final Function(String) onSideloadApp;

  SettingsScreen({required this.repositories, required this.onRepositoriesChanged, required this.onSideloadApp});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedBackgroundImage = 'assets/backgrounds/default.png';
  List<String> _repositories = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _repositories = widget.repositories;
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedBackgroundImage = prefs.getString('background_image') ?? 'assets/backgrounds/default.png';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('background_image', _selectedBackgroundImage);
    widget.onRepositoriesChanged(_repositories);
  }

  Future<void> _selectBackgroundImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _selectedBackgroundImage = result.files.single.path!;
      });
      await _saveSettings();
    }
  }

  void _manageRepositories() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController _repoController = TextEditingController();
        return AlertDialog(
          title: Text('Manage Repositories'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _repoController,
                decoration: InputDecoration(hintText: 'Add new repository URL'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _repositories.add(_repoController.text);
                  });
                  _repoController.clear();
                  Navigator.of(context).pop();
                  _saveSettings();
                },
                child: Text('Add'),
              ),
              ..._repositories.map((repo) => ListTile(
                    title: Text(repo),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _repositories.remove(repo);
                        });
                        _saveSettings();
                      },
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }

  void _sideloadApp() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['dart'],
    );
    if (result != null) {
      String dartCode = await File(result.files.single.path!).readAsString();
      widget.onSideloadApp(dartCode);
    }
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
            title: Text('Change Background Image'),
            trailing: Icon(Icons.image),
            onTap: () async {
              await _selectBackgroundImage();
            },
          ),
          ListTile(
            title: Text('Manage Repositories'),
            trailing: Icon(Icons.folder),
            onTap: () {
              _manageRepositories();
            },
          ),
          ListTile(
            title: Text('Sideload App'),
            trailing: Icon(Icons.file_download),
            onTap: () {
              _sideloadApp();
            },
          ),
        ],
      ),
    );
  }
}
