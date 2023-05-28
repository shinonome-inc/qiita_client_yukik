import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qiita_client_yukik/models/user.dart';
import 'package:qiita_client_yukik/root.dart';
import 'package:qiita_client_yukik/services/access_token.dart';
import 'package:qiita_client_yukik/ui_components/app_bar_component.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  late WebViewController controller;
  double? pageHeight;
  late User authenticatedUser;
  final String clientId = dotenv.get('CLIENT_ID');
  final String clientSecret = dotenv.get('CLIENT_SECRET');

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
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const Root(page_index: 0)),
              );
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://qiita.com/api/v2/oauth/authorize?client_id=$clientId&scope=read_qiita&state=bb17785d811bb1913ef54b0a7657de780defaa2d'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(title: 'Log Auth'),
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
