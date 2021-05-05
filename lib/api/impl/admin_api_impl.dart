import 'dart:convert';

import 'package:kpiboardapp/api/admin_api.dart';
import 'package:kpiboardapp/entity/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class AdminApiImpl implements AdminApi{
  final String allUsers = Constants.HOST + "admin/userlist/";
  @override
  Future<List<User>> findAllUsers() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var request = http.get(allUsers,
        headers: {"Authorization" : "Bearer_" + _prefs.get("token")});
    var response = await request;
    List<User> users = [];
    for(var e in jsonDecode(response.body)) {
      users.add(User.fromJson(e as Map<String, dynamic>));
    }
    return users;
  }

}