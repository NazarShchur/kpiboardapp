import 'dart:convert';

import 'package:kpiboardapp/api/admin_api.dart';
import 'package:kpiboardapp/api/request_builder.dart' as rb;
import 'package:kpiboardapp/entity/User.dart';
import 'package:kpiboardapp/entity/role.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AdminApiImpl implements AdminApi{
  final String allUsers = "admin/userlist";
  final String setRole = "admin/setrole";
  @override
  Future<List<User>> findAllUsers() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var request = rb.get(allUsers);
    var response = await request;
    List<User> users = [];
    for(var e in jsonDecode(response.body)) {
      users.add(User.fromJson(e as Map<String, dynamic>));
    }
    return users;
  }

  @override
  Future<void> setUserRole(Role role, int id) async{
    var req = rb.post(setRole, body: {
      "id" : id.toString(),
      "role" : role.toStr()
    });
    await req;
  }

}