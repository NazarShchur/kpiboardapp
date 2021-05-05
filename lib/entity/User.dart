import 'package:kpiboardapp/entity/role.dart';

class User {
  String username;
  int id;
  String password;
  Role role;
  User(this.username, this.id, this.role);

  User.us(this.username, this.password);



  factory User.fromJson(Map<String, dynamic> json) {
    return User(json["username"], json["id"], RoleExt.fromString(json["role"]));
  }

  Map<String, dynamic> toJson(){
    return {
      "username" : username,
      "password" : password
    };
  }
}