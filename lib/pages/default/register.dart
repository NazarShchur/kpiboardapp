import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kpiboardapp/constants.dart';
import 'package:kpiboardapp/entity/User.dart';
import 'package:kpiboardapp/pages/user/user_page.dart';

import 'package:shared_preferences/shared_preferences.dart';



class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegistrationPageState();

}

class RegistrationPageState extends State<RegistrationPage> {
  var api = Constants.HOST + "/auth/register";
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var username;
  var password;
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Registration"),
     ),
     body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
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
             onTap: _register,
             child: Container(
               width: 200,
               height: 50,
               color: Colors.green,
               child: Center(
                 child: Text(
                   "Register"
                 ),
               ),
             ),
           )
         ],
       ),
     ),
   );
  }

  void _register() async{
    var response = await http.post(Uri.http(Constants.HOST, "/auth/register"), body: jsonEncode(User.us(username, password).toJson()),  headers: {
    "Accept": "application/json",
    "content-type": "application/json"});
    final SharedPreferences prefs = await _prefs;
    prefs.setString("token", jsonDecode(response.body)["token"]);
    prefs.setString("username", jsonDecode(response.body)["username"]);
    prefs.setString("role", jsonDecode(response.body)["role"]);

    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder:(context) => UserPage()));
  }

}