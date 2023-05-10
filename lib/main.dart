import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qiita_client_yukik/pages/feed_page.dart';
import 'package:qiita_client_yukik/pages/my_page.dart';
import 'package:qiita_client_yukik/pages/tag_page.dart';
import 'package:qiita_client_yukik/pages/top_page.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/top',
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/top': (context) => const TopPage(),
        '/feed': (context) => const FeedPage(),
        '/tag': (context) => const TagPage(),
        '/my': (context) => const MyPage(),
      },
    );
  }
}
