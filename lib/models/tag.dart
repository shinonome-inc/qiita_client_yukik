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
        iconUrl: json['icon_url'] ??
            'https://cdn.qiita.com/assets/icons/medium/missing-2e17009a0b32a6423572b0e6dc56727e.png',
        followersCount: json['followers_count']);
  }
}
