import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Article {
  final String title;
  final DateTime createdAt;
  final User users;
  final int likes;
  Article(
      {required this.title,
      required this.createdAt,
      required this.users,
      required this.likes});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      createdAt: DateTime.parse(json['created_at']),
      users: User.fromJson(json['user']),
      likes: json['likes_count'],
    );
  }
}

class User {
  final String imgUrl;
  final String userId;
  User({required this.imgUrl, required this.userId});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      imgUrl: json['profile_image_url'],
      userId: json['id'],
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
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(items[index].users.imgUrl),
                  radius: 20,
                ),
                title: Text(
                  items[index].title,
                  style: const TextStyle(fontSize: 14),
                ),
                subtitle: Text(
                    '@${items[index].users.userId.toString()}'
                    '　投稿日：${DateFormat('yyyy/MM/dd').format(items[index].createdAt)}'
                    '　いいね：${items[index].likes.toString()}',
                    style: const TextStyle(
                      fontSize: 12,
                    ))),
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
