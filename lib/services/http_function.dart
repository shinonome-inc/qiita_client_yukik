import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpFunc {
  late http.Response response;
  Future<http.Response> httpGet(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final fetchedAccessToken = prefs.getString('token') ?? "";
    if (fetchedAccessToken != "") {
      response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer $fetchedAccessToken'});
    } else {
      response = await http.get(Uri.parse(url));
    }
    return response;
  }
}
