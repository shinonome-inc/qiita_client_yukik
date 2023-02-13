import 'package:flutter/material.dart';
import 'package:qiita_client_yukik/pages/feed_page.dart';
import 'package:qiita_client_yukik/pages/top_page.dart';

void main() {
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
        '/top': (context) => TopPage(),
        '/feed': (context) => FeedPage(),
      },
    );
  }
}
