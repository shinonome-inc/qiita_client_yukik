import 'dart:convert';

import 'package:http/http.dart' as http;

import 'article.dart';

class API {
  final baseUrl = 'https://qiita.com/api/v2/items';
  Future<List<Article>> fetchArticle({String? searchText, int? page}) async {
    var url = baseUrl;
    if (searchText != null) {
      url =
          '$baseUrl?page=$page&per_page=20&query=body%3A$searchText+title%3A$searchText';
    }
    final response = await http.get(Uri.parse(url));
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
