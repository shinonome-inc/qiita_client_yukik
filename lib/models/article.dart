import 'package:qiita_client_yukik/models/user.dart';

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
