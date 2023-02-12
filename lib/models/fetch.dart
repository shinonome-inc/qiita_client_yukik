import 'dart:convert';

import 'package:http/http.dart' as http;

import 'article.dart';

class API {
  Future<List<Article>> fetchArticle(String string) async {
    final response = await http.get(Uri.parse(string));
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
