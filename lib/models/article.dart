import 'package:qiita_client_yukik/models/user.dart';

class Article {
  final String createdAt;
  final int likesCount;
  final String title;
  final String url;
  final User user;

  const Article({
    required this.createdAt,
    required this.likesCount,
    required this.title,
    required this.url,
    required this.user,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      createdAt: json['created_at'],
      likesCount: json['likes_count'],
      title: json['title'],
      url: json['url'],
      user: json['user'],
    );
  }
}
