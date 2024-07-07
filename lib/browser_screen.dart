import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class BrowserScreen extends StatelessWidget {
  final urlController = TextEditingController();
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

class WebViewScreen extends StatefulWidget {
  final String url;
  final Function(String, String) onDownloadWebsite;

  const WebViewScreen({required this.url, required this.onDownloadWebsite});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late InAppWebViewController _webViewController;
  final GlobalKey webViewKey = GlobalKey();

  Future<String> _getFaviconUrl() async {
    final jsCode = """
      (function() {
        var nodeList = document.getElementsByTagName('link');
        for (var i = 0; i < nodeList.length; i++) {
          if (nodeList[i].rel == 'icon' || nodeList[i].rel == 'shortcut icon') {
            return nodeList[i].href;
          }
        }
        return '';
      })();
    """;

    return await _webViewController.evaluateJavascript(source: jsCode) ?? '';
  }

  void _handleDownload() async {
    try {
      if (_webViewController != null) {
        final title = await _webViewController.getTitle();
        final faviconUrl = await _getFaviconUrl();

        widget.onDownloadWebsite(title ?? 'Untitled', faviconUrl);
      }
    } catch (e) {
      print('Error downloading website: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web Browser'),
      ),
      body: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
          ),
          android: AndroidInAppWebViewOptions(
            useHybridComposition: true,
          ),
          ios: IOSInAppWebViewOptions(
            allowsInlineMediaPlayback: true,
          ),
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleDownload,
        tooltip: 'Download Website',
        child: Icon(Icons.download_rounded),
      ),
    );
  }
}
