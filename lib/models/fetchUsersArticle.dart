import 'dart:convert';

import 'package:http/http.dart' as http;

import 'usersArticle.dart';

class ApiUsersArticle {
  final baseUrl = 'https://qiita.com/api/v2/authenticated_user/items';

  Future<List<UsersArticle>> fetchUsersArticle({int? page}) async {
    var url = baseUrl;
    url = '$baseUrl?page=$page&per_page=20';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer f7cbc007e8b546e5169c6aaf4a5f41df1a950668'
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonArray = json.decode(response.body);
      final usersItems = jsonArray.map((item) {
        return UsersArticle.fromJson(item);
      }).toList();
      return usersItems;
    } else {
      throw Exception('Failed to fetch Article');
    }
  }
}
