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
