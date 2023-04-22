import 'package:flutter/material.dart';
import 'package:qiita_client_yukik/models/user.dart';
import 'package:qiita_client_yukik/root.dart';
import 'package:qiita_client_yukik/services/access_token.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LogInPage extends StatefulWidget {
  LogInPage({Key? key, required this.url}) : super(key: key);
  final String url;
  late String token;

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  late WebViewController controller;
  double? pageHeight;
  late User authenticatedUser;

  Future<void> _login(String url) async {
    String? code = Uri.parse(url).queryParameters['code'];
    final String accessToken = await AccessToken().createAccessToken(code!);
    authenticatedUser = await AccessToken().fetchAuthenticatedUser(accessToken);
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setBackgroundColor(const Color(0x00000000))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            final bool hasCode =
                url.contains('https://qiita.com/settings/applications');
            if (hasCode) {
              await _login(url);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Root()),
              );
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Auth',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Pacifico-Regular',
              fontSize: 17,
            )),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
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