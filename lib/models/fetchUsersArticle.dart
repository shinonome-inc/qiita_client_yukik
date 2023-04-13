import 'dart:convert';

import 'package:http/http.dart' as http;

import 'article.dart';

class ApiUser {
  final baseUrl = 'https://qiita.com/api/v2/authenticated_user/items';

  Future<List<Article>> fetchUsersArticle(
      {String? searchText, int? page}) async {
    var url = baseUrl;
    if (searchText != null) {
      url = '$baseUrl?page=$page&per_page=20';
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
