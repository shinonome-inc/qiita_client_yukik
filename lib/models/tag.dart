class Tag {
  final int itemsCount;
  final String tagId;
  final String iconUrl;
  final int followersCount;
  Tag(
      {required this.itemsCount,
      required this.tagId,
      required this.iconUrl,
      required this.followersCount});
  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
        itemsCount: json['items_count'],
        tagId: json['id'],
        iconUrl: json['icon_url'],
        followersCount: json['followers_count']);
  }
}
