import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Article {
  final String title;
  final DateTime updatedAt;
  final User users;
  Article({required this.title, required this.updatedAt, required this.users});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      updatedAt: DateTime.parse(json['updated_at']),
      users: User.fromJson(json['user']),
    );
  }
}

class User {
  final String imgUrl;
  User({required this.imgUrl});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      imgUrl: json['profile_image_url'],
    );
  }
}

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Future<List<Article>> fetchArticle() async {
    final response =
        await http.get(Uri.parse('https://qiita.com/api/v2/items'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonArray = json.decode(response.body);
      final items = jsonArray.map((item) {
        return Article.fromJson(item);
      }).toList();
      return items;
    } else {
      throw Exception('Failed to load album');
    }
  }

  late Future<List<Article>> futureArticle;

  @override
  void initState() {
    super.initState();
    futureArticle = fetchArticle();
  }

  Widget _listView(List<Article> items) {
    return Expanded(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Image.network(items[index].users.imgUrl),
              title: Text(items[index].title),
              subtitle: Text(
                  '投稿日：${DateFormat('yyyy/MM/dd').format(items[index].updatedAt)}'),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Pacifico-Regular',
              fontSize: 17,
            )),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Divider(),
          FutureBuilder<List<Article>>(
            future: fetchArticle(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _listView(snapshot.data!);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
