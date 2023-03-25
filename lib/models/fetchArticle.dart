import 'dart:convert';

import 'package:http/http.dart' as http;

import 'article.dart';

class ApiArticle {
  final baseUrl = 'https://qiita.com/api/v2/items';

  Future<List<Article>> fetchArticle({String? searchText, int? page}) async {
    var url = baseUrl;
    print('通信中');

    if (searchText != null) {
      url =
          '$baseUrl?page=$page&per_page=20&query=body%3A$searchText+title%3A$searchText';
    }
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer f7cbc007e8b546e5169c6aaf4a5f41df1a950668'
      },
    );
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
