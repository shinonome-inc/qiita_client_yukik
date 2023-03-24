import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:qiita_client_yukik/models/tag.dart';

class ApiTag {
  final baseUrl = 'https://qiita.com/api/v2/tags';

  Future<List<Tag>> fetchTag({required int page}) async {
    var url = baseUrl;
    print('通信中');
    url = '$baseUrl?page=$page&per_page=20&sort=count';
    print(url);
    final response = await http.get(Uri.parse(url));
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
