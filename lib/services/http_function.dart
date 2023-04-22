import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpFunc {
  Future<http.Response> httpGet(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final fetchedAccessToken = prefs.getString('token') ?? "";
    final response = await http.get(Uri.parse(url),
        headers: fetchedAccessToken != null
            ? {'Authorization': 'Bearer $fetchedAccessToken'}
            : {});
    return response;
  }
}
