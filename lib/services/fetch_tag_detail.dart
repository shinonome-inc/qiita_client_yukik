import 'dart:convert';

import 'package:qiita_client_yukik/services/http_function.dart';

import '../models/article.dart';

class ApiTagDetail {
  final baseUrl = 'https://qiita.com/api/v2/items';

  Future<List<Article>> fetchTagDetail({int? page, String? tag}) async {
    var url = baseUrl;
    url = '$baseUrl?page=$page&per_page=20&query=tag%3A$tag';

    final response = await HttpFunc().httpGet(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonArray = json.decode(response.body);
      final items = jsonArray.map((item) {
        return Article.fromJson(item);
      }).toList();
      return items;
    } else {
      throw Exception('Failed to fetch article');
    }
  }
}
