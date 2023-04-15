class User {
  final String imgUrl;
  final String userId;
  final String description;
  final String name;
  final int followees;
  final int followers;
  User(
      {required this.imgUrl,
      required this.userId,
      required this.description,
      required this.name,
      required this.followees,
      required this.followers});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      imgUrl: json['profile_image_url'],
      userId: json['id'],
      description: json['description'] ?? '',
      name: json['name'] ?? '',
      followees: json['followees_count'] ?? 0,
      followers: json['followers_count'] ?? 0,
    );
  }
}
