import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:qiita_client_yukik/models/user.dart';
import 'package:qiita_client_yukik/models/users_article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessToken {
  final String tokenUrl = 'https://qiita.com/api/v2/access_tokens';
  final String baseUrl = 'https://qiita.com/api/v2/authenticated_user';
  final String usersArticleUrl =
      'https://qiita.com/api/v2/authenticated_user/items';

  Future<String> createAccessToken(String code) async {
    final String clientId = dotenv.get('CLIENT_ID');
    final String clientSecret = dotenv.get('CLIENT_SECRET');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse(tokenUrl),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(
        <String, String>{
          'client_id': clientId,
          'client_secret': clientSecret,
          'code': code,
        },
      ),
    );
    if (response.statusCode == 201) {
      final String accessToken = jsonDecode(response.body)['token'];
      await prefs.setString('token', accessToken);
      return accessToken;
    } else {
      throw Exception(
        'Request failed with status: ${response.statusCode}',
      );
    }
  }

  Future<User> fetchAuthenticatedUser(String? accessToken) async {
    var url = baseUrl;
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to fetch authenticated user ${response.statusCode}');
    }
  }

  Future<List<UsersArticle>> fetchUsersArticle(
      {int? page, String? accessToken}) async {
    var url = usersArticleUrl;
    url = '$usersArticleUrl?page=$page&per_page=20';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
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
