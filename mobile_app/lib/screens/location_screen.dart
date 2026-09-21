import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late final WebViewController _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    print('LocationScreen: initState called');
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                print('LocationScreen: Page started loading: $url');
                if (mounted) {
                  setState(() {
                    _hasError = false;
                  });
                }
              },
              onPageFinished: (String url) {
                print('LocationScreen: Page finished loading: $url');
              },
              onWebResourceError: (WebResourceError error) {
                print(
                  'LocationScreen: Web resource error: ${error.description}',
                );
                if (mounted) {
                  setState(() {
                    _hasError = true;
                  });
                }
              },
            ),
          )
          ..loadRequest(Uri.parse('https://maps.app.goo.gl/ZNfF5Lm7umh1sPUX7'));
  }

  @override
  void dispose() {
    print('LocationScreen: dispose called');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
        backgroundColor: const Color.fromARGB(249, 17, 97, 183),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFF0A1622),
        child:
            _hasError
                ? const Center(
                  child: Text(
                    'Failed to load location. Please check your internet connection.',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
                : WebViewWidget(controller: _controller),
      ),
    );
  }
}
