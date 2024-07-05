import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleDownload() async {
    try {
      if (_webViewController != null) {
        // Get page title
        final title = await _webViewController.getTitle();
        // Get favicon URL
        final faviconUrl = await _webViewController.evaluateJavascript(
          source: """
          (function() {
            var favicon = '';
            var nodeList = document.getElementsByTagName('link');
            for (var i = 0; i < nodeList.length; i++) {
              if ((nodeList[i].getAttribute('rel') === 'icon') || (nodeList[i].getAttribute('rel') === 'shortcut icon')) {
                favicon = nodeList[i].getAttribute('href');
              }
            }
            return favicon;
          })();
          """
        );

        // Pass title and favicon URL back to BrowserScreen to handle
        widget.onDownloadWebsite(title ?? 'Untitled', faviconUrl ?? '');
      }
    } catch (e) {
      print('Error downloading website: $e');
      // Handle error
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
