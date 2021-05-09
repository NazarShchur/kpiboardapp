import 'dart:convert';

import 'package:kpiboardapp/entity/psot.dart';
import 'package:kpiboardapp/entity/role.dart';

class User {
  String username;
  int id;
  String password;
  Role role;
  List<Post> posts;
  User(this.username, this.id, this.role, this.posts);

  User.us(this.username, this.password);



  factory User.fromJson(Map<String, dynamic> json) {
    return User(json["username"], json["id"], RoleExt.fromString(json["role"]), Post.posts(json["posts"]));

  }

  Map<String, dynamic> toJson(){
    return {
      "username" : username,
      "password" : password
    };
  }
}