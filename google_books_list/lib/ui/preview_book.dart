import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PreviewBook extends StatelessWidget {
  final String? url;

  const PreviewBook({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebView(
        initialUrl: url,
      ),
    );
  }
}
