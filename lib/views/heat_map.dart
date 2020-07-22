import 'dart:async';

import 'package:flutter/material.dart';
import 'package:coronamap/custom_widgets/theme_switch.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HeatMapScreen extends StatefulWidget {

  @override
  _HeatMapScreenState createState() => _HeatMapScreenState();
}

class _HeatMapScreenState extends State<HeatMapScreen> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        actions: <Widget>[ThemeSwitch()],
      ),
      body: WebView(
        initialUrl: "http://192.168.1.2:8080/",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
