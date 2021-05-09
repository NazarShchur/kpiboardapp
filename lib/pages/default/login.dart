import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kpiboardapp/constants.dart';
import 'package:kpiboardapp/entity/User.dart';
import 'package:kpiboardapp/pages/default/register.dart';
import 'package:kpiboardapp/pages/user/user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';





class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();

}

class LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var api = Constants.HOST + "/auth/login";
  var username;
  var password;
  var message = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                message, style: TextStyle(
              color: Colors.red
            ),
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: "Username"
              ),
              onChanged: (text) {
                setState(() {
                  username = text;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Password",
              ),
              onChanged: (text) {
                setState(() {
                  password = text;
                });
              },
            ),
            GestureDetector(
              onTap: _login,
              child: Container(
                width: 200,
                height: 50,
                color: Colors.green,
                child: Center(
                  child: Text(
                      "Login"
                  ),
                ),
              ),
            ),
            FlatButton(
              onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder:(context) => RegistrationPage())),
              child: Text("Register"),

            )
          ],
        ),
      ),
    );
  }

  void _login() async{
    var response = await http.post(Uri.http(Constants.HOST, "auth/login"), body: jsonEncode(User.us(username, password).toJson()),  headers: {
      "Accept": "application/json",
      "content-type": "application/json"});
    final SharedPreferences prefs = await _prefs;
    prefs.setString("token", jsonDecode(response.body)["token"]);
    prefs.setString("username", jsonDecode(response.body)["username"]);
    prefs.setString("role", jsonDecode(response.body)["role"]);
    if(response.statusCode == 200){
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder:(context) => UserPage()));
    } else {
      setState(() {
        message = "Incorrect Credentials";
      });
    }

  }

}