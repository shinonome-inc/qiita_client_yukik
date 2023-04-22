import 'dart:convert';

import 'package:qiita_client_yukik/services/http_function.dart';

import '../models/article.dart';

class ApiArticle {
  Future<List<Article>> fetchArticle({String? searchText, int? page}) async {
    var url = '';
    if (searchText != null) {
      url =
          'https://qiita.com/api/v2/items?page=$page&per_page=20&query=body%3A$searchText+title%3A$searchText';
    }
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
