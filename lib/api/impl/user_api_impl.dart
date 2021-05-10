import 'dart:convert';

import 'package:kpiboardapp/api/user_api.dart';
import 'package:kpiboardapp/constants.dart';
import 'package:kpiboardapp/entity/User.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserApiImpl implements UserApi {
  final String url = "/users/";
  @override
  Future<User> findByUsername(String username) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return User.fromJson(jsonDecode(utf8.decode((await http.get(Uri.http(Constants.HOST, url + username))).body.runes.toList())));
  }

}