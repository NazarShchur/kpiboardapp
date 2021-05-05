import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:kpiboardapp/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Response> post(String url, {Map<String, String> body}) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  var request = http.post(Constants.HOST + url,
      headers: {"Authorization": "Bearer_" + _prefs.get("token")},
      body: body
      );
  return request;
}

Future<Response> get(String url) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  var request = http.get(Constants.HOST + url,
      headers: {"Authorization": "Bearer_" + _prefs.get("token")});
  return request;
}

Future<Response> put(String url, {Map<String, String> body}) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  var request = http.put(Constants.HOST + url,
      headers: {"Authorization": "Bearer_" + _prefs.get("token")},
      body: body
  );
  return request;
}

Future<Response> delete(String url) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  var request = http.delete(Constants.HOST + url,
      headers: {"Authorization": "Bearer_" + _prefs.get("token")},
  );
  return request;
}


