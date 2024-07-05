import 'dart:convert';
import 'package:flutter/material.dart';
import 'models/app_info.dart';

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
  TextEditingController _repoController = TextEditingController();
  TextEditingController _dartCodeController = TextEditingController();

  String _iosVersion = 'iOS 15.4.1';
  String _appVersion = 'App Version 1.0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            title: Text('Software Updates'),
            leading: Icon(Icons.system_update),
            onTap: () {
              // Handle software updates
            },
          ),
          Divider(),
          ListTile(
            title: Text('About'),
            leading: Icon(Icons.info),
            onTap: () {
              _showAboutDialog();
            },
          ),
          Divider(),
          ListTile(
            title: Text('Repositories'),
            leading: Icon(Icons.storage),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _showAddRepositoryDialog();
              },
            ),
          ),
          Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.repositories.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.repositories[index]),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _removeRepository(index);
                  },
                ),
              );
            },
          ),
          Divider(),
          ElevatedButton(
            onPressed: () {
              _showSideloadAppDialog();
            },
            child: Text('Sideload App'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(_iosVersion),
              SizedBox(height: 8),
              Text(_appVersion),
              SizedBox(height: 8),
              Text('Copyright © 2024 Your Company'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddRepositoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Repository'),
          content: TextField(
            controller: _repoController,
            decoration: InputDecoration(hintText: 'Enter repository URL'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                _addRepository(_repoController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addRepository(String repoUrl) {
    setState(() {
      widget.repositories.add(repoUrl);
      widget.onRepositoriesChanged(widget.repositories);
    });
  }

  void _removeRepository(int index) {
    setState(() {
      widget.repositories.removeAt(index);
      widget.onRepositoriesChanged(widget.repositories);
    });
  }

  void _showSideloadAppDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Paste Dart Code'),
          content: TextField(
            controller: _dartCodeController,
            onChanged: (value) {
              // Store Dart code in controller
            },
            decoration: InputDecoration(hintText: 'Enter Dart code'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Paste'),
              onPressed: () {
                _handleSideloadApp(_dartCodeController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleSideloadApp(String dartCode) {
    if (dartCode.isNotEmpty) {
      try {
        Map<String, dynamic> appData = jsonDecode(dartCode);
        AppInfo newApp = AppInfo(
          name: appData['appName'] ?? 'Unnamed App',
          author: 'Unknown Author',
          version: '1.0',
          icon: appData['appIconUrl'] ?? 'assets/icons/default.png',
        );
        widget.onSideloadApp(dartCode);
      } catch (e) {
        print('Error handling Dart code: $e');
      }
    }
  }

  @override
  void dispose() {
    _repoController.dispose();
    _dartCodeController.dispose();
    super.dispose();
  }
}
