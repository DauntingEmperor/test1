import 'package:flutter/material.dart';

class SideloadingScreen extends StatelessWidget {
  final TextEditingController _dartCodeController = TextEditingController();

  void _handleSideloadApp(String dartCode, BuildContext context) {
    if (dartCode.isNotEmpty) {
      try {
        Navigator.pop(context); // Close SideloadingScreen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dart code pasted successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        print('Error handling Dart code: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to handle Dart code'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please paste Dart code'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sideloading'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _dartCodeController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Paste Dart code here',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String dartCode = _dartCodeController.text;
                _handleSideloadApp(dartCode, context);
              },
              child: Text('Paste Dart Code'),
            ),
          ],
        ),
      ),
    );
  }
}
