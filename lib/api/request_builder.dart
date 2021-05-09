import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:kpiboardapp/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Response> post(String url, {body}) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  var request = http.post(Uri.http(Constants.HOST, url),
      headers: {
        "Authorization": "Bearer_" + _prefs.get("token"),
        "Accept": "application/json",
        "content-type": "application/json",
        "charset": "utf-8"
      },
      body: body);
  return request;
}

Future<Response> get(String url) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  var request = http.get(Uri.http(Constants.HOST, url), headers: {
    "Authorization": "Bearer_" + _prefs.get("token"),
    "Accept": "application/json",
    "content-type": "application/json",
    "charset": "utf-8"
  });
  return request;
}

Future<Response> put(String url, {body}) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  var request = http.put(Uri.http(Constants.HOST, url),
      headers: {
        "Authorization": "Bearer_" + _prefs.get("token"),
        "Accept": "application/json",
        "content-type": "application/json",
        "charset": "utf-8"
      },
      body: body);
  return request;
}

Future<Response> delete(String url) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  var request = http.delete(
    Uri.http(Constants.HOST, url),
    headers: {
      "Authorization": "Bearer_" + _prefs.get("token"),
      "Accept": "application/json",
      "content-type": "application/json",
      "charset": "utf-8"
    },
  );
  return request;
}
