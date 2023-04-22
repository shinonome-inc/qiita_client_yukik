import 'package:flutter/material.dart';
import 'package:qiita_client_yukik/ui_components/app_bar_component.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FeedDetail extends StatefulWidget {
  const FeedDetail({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  State<FeedDetail> createState() => _FeedDetailState();
}

class _FeedDetailState extends State<FeedDetail> {
  late WebViewController controller;
  double? pageHeight;

  Future<void> calculateWebViewHeight(String url) async {
    const String javaScript = 'document.documentElement.scrollHeight;';
    final result = await controller.runJavaScriptReturningResult(javaScript);
    setState(() {
      print('UPDATE WebView contents height: $result');
      pageHeight = double.parse(result.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setBackgroundColor(const Color(0x00000000))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) => calculateWebViewHeight(url),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(title: 'Article'),
      body: SingleChildScrollView(
        child: SizedBox(
          height: pageHeight ?? MediaQuery.of(context).size.height * 0.9,
          child: WebViewWidget(
            controller: controller,
          ),
        ),
      ),
    );
  }
}
