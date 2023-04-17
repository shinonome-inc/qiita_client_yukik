import 'package:http/http.dart' as http;

class HttpFunc {
  Future<http.Response> httpGet(String url, String accessToken) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    return response;
  }
}
