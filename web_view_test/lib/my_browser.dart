import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyBrowser extends StatefulWidget {
  @override
  _MyBrowserState createState() => _MyBrowserState();
}

class _MyBrowserState extends State<MyBrowser> {
  final TextEditingController _urlController = TextEditingController();
  late WebViewController _webViewController;
  bool _isLoading = false;
@override
  void dispose() {
    // TODO: implement dispose
  _urlController.dispose();

  super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          }
      ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _urlController,
            decoration: InputDecoration(
              hintText: 'Enter URL',
            ),
            onSubmitted: (url) {
              _loadUrl(url);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(_isLoading ? Icons.stop : Icons.refresh),
              onPressed: () {
                _isLoading ? _stopLoading() : _reload();
              },
            ),
            FutureBuilder(
                future: _canGoBack(),
                builder: (context, snap) {
                  var isEnable = snap.data?? false;
                  return IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: isEnable? _goBack : null ,
                  );
                }
            ),
            FutureBuilder(
              future: _canGoForward(),
              builder: (context,snap) {
                var isEnable = snap.data?? false;
                return IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: isEnable ? _goForward : null,
                );
              }
            ),
          ],
        ),
        body: WebViewWidget(controller: _webViewController,)

    );
  }

  void _loadUrl(String url) {
    _webViewController.loadRequest(Uri.parse(url));
  }

  void _reload() {
    _webViewController.reload();
  }

  void _stopLoading() {
    _webViewController.runJavaScript('window.stop();');
  }

  Future<bool> _canGoBack() async {
    return await _webViewController.canGoBack();
  }

  void _goBack() {
    _webViewController.goBack();
  }

  Future<bool> _canGoForward() async {
    return await _webViewController.canGoForward();
  }

  void _goForward() {
    _webViewController.goForward();
  }
}