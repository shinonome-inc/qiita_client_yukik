import 'dart:convert';

import 'package:qiita_client_yukik/models/tag.dart';
import 'package:qiita_client_yukik/services/http_function.dart';

class ApiTag {
  Future<List<Tag>> fetchTag({required int page}) async {
    var url = 'https://qiita.com/api/v2/tags?page=$page&per_page=20&sort=count';
    final response = await HttpFunc().httpGet(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonArray = json.decode(response.body);
      final tags = jsonArray.map((tag) {
        return Tag.fromJson(tag);
      }).toList();
      return tags;
    } else {
      throw Exception('Failed to fetch tag ${response.statusCode}');
    }
  }
}
