import 'package:flutter/material.dart';
import 'web_view_screen.dart';

class BrowserScreen extends StatelessWidget {
  final TextEditingController urlController = TextEditingController();
  final Function(String, String) onDownloadWebsite;

  BrowserScreen({required this.onDownloadWebsite});

  void _openWebView(BuildContext context) {
    if (urlController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewScreen(
            url: urlController.text,
            onDownloadWebsite: onDownloadWebsite,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chrome'),
        actions: [
          IconButton(
            onPressed: () => _openWebView(context),
            icon: Icon(Icons.download_rounded),
            tooltip: 'Download Website',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                hintText: 'Enter URL',
                suffixIcon: IconButton(
                  onPressed: () => urlController.clear(),
                  icon: Icon(Icons.clear),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _openWebView(context),
              child: Text('Open'),
            ),
          ],
        ),
      ),
    );
  }
}
