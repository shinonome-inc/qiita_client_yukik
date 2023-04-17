import 'package:http/http.dart' as http;

class HttpFunc {
  Future<http.Response?> httpFunc(String url, String? accessToken) async {
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );
    return response;
  }
}
