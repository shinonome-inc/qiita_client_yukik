class User {
  final String id;
  final String profileImageUrl;

  const User({
    required this.id,
    required this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      profileImageUrl: json['profile_image_url'],
    );
  }
}
