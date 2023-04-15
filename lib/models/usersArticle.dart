class UsersArticle {
  final String title;
  final DateTime createdAt;
  final int likes;
  final String webUrl;
  UsersArticle(
      {required this.title,
      required this.createdAt,
      required this.likes,
      required this.webUrl});

  factory UsersArticle.fromJson(Map<String, dynamic> json) {
    return UsersArticle(
      title: json['title'],
      createdAt: DateTime.parse(json['created_at']),
      likes: json['likes_count'],
      webUrl: json['url'],
    );
  }
}
