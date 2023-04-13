import 'package:flutter/material.dart';
import 'package:qiita_client_yukik/models/accessToken.dart';
import 'package:qiita_client_yukik/models/user.dart';
import 'package:qiita_client_yukik/pages/mypage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  late WebViewController controller;
  late User _user;
  double? pageHeight;

  Future<void> _login(String url) async {
    String code = url.split('https://qiita.com/settings/applications?code=').;
    print(code);
    final String accessToken = await AccessToken.createAccessToken(code);
    _user = await AccessToken.fetchUser(accessToken);
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
                MaterialPageRoute(builder: (context) => MyPage(userUrl: _user)),
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
        child: Container(
          height: pageHeight ?? MediaQuery.of(context).size.height * 0.9,
          child: WebViewWidget(
            controller: controller,
          ),
        ),
      ),
    );
  }
}
