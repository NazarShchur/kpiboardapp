import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kpiboardapp/api/impl/user_api_impl.dart';
import 'package:kpiboardapp/constants.dart';
import 'package:kpiboardapp/entity/User.dart';
import 'package:kpiboardapp/pages/user/user_page.dart';
import 'package:passwordfield/passwordfield.dart';

import 'package:shared_preferences/shared_preferences.dart';



class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegistrationPageState();

}

class RegistrationPageState extends State<RegistrationPage> {
  var api = Constants.HOST + "/auth/register";
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var username = "";
  var password = TextEditingController();
  var first = TextEditingController();
  var last = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();

  var emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  var phoneRegex = RegExp("[0-9]{12}");
  bool processing = false;
  Map <String, String> err = {};
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Registration"),
     ),
     body: ListView(
       children: [
         Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Container(
               width: 150,
               height: 150,
               child: Image.asset('assets/logo1.png'),
             ),
             Container(
               padding: EdgeInsets.only(left: 25, right: 25),
               child: TextField(
                 decoration: InputDecoration(
                   labelStyle: err["username"] == null ? null : TextStyle(color: Colors.red),
                   labelText: "Username ${err["username"]??""}",
                   floatingLabelBehavior: FloatingLabelBehavior.auto,
                 ),
                 onChanged: (text) {
                   setState(() {
                     username = text;
                   });
                 },
               ),
             ),
             Container(
               padding: EdgeInsets.only(left: 25, right: 25),
               child: TextField(
                 controller: first,
                 decoration: InputDecoration(
                   labelStyle: err["first"] == null ? null : TextStyle(color: Colors.red),
                   labelText: "First Name ${err["first"]??""}",
                   floatingLabelBehavior: FloatingLabelBehavior.auto,
                 ),
               ),
             ),
             Container(
               padding: EdgeInsets.only(left: 25, right: 25),
               child: TextField(
                 controller: last,
                 decoration: InputDecoration(
                   labelStyle: err["last"] == null ? null : TextStyle(color: Colors.red),
                   labelText: "Last Name ${err["last"]??""}",
                   floatingLabelBehavior: FloatingLabelBehavior.auto,
                 ),
               ),
             ),
             Container(
               padding: EdgeInsets.only(left: 25, right: 25),
               child: TextField(
                 controller: email,
                 decoration: InputDecoration(
                   labelStyle: err["email"] == null ? null : TextStyle(color: Colors.red),
                   labelText: "Email ${err["email"]??""}",
                   floatingLabelBehavior: FloatingLabelBehavior.auto,
                 ),
               ),
             ),
             Container(
               padding: EdgeInsets.only(left: 25, right: 25),
               child: TextField(
                 controller: phone,
                 decoration: InputDecoration(
                   labelStyle: err["phone"] == null ? null : TextStyle(color: Colors.red),
                   labelText: "Phone ${err["phone"]??""}",
                   floatingLabelBehavior: FloatingLabelBehavior.auto,
                 ),
               ),
             ),
             SizedBox(height: 20),
             Padding(
               padding: const EdgeInsets.only(left: 25, right: 25),
               child: PasswordField(
                 hintStyle: err["password"] == null ? null : TextStyle(color: Colors.red),
                 floatingText: "Password ${err["password"]??""}",
                 hasFloatingPlaceholder: true,
                 controller: password,
               ),
             ),
             SizedBox(height: 20),
             processing ? Center(child: CircularProgressIndicator()) :
             Column(
               children: [
                 SizedBox(height: 15),
                 FlatButton(
                   minWidth: 200,
                   height: 45,
                   color: Theme.of(context).accentColor,
                   textColor: Colors.white,
                   onPressed: _register,
                   child: Text("REGISTER"),
                 )
               ],
             ),
           ],
         ),
       ],
     ),
   );
  }

  void _register() async{
    setState(() {
      processing = true;
    });
    bool valid = await _validate();
    if(valid) {
      var response = await http.post(Uri.http(Constants.HOST, "/auth/register"),
          body: jsonEncode({
              "username": username,
              "password": password.text,
              "name": first.text,
              "surname": last.text,
              "email": email.text,
              "phone" : phone.text
          }),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"});
      final SharedPreferences prefs = await _prefs;
      prefs.setString("token", jsonDecode(response.body)["token"]);
      prefs.setString("username", jsonDecode(response.body)["username"]);
      prefs.setString("role", jsonDecode(response.body)["role"]);
      var owner = await UserApiImpl().findByUsername(username);
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => UserPage(owner: owner)));
    }
    setState(() {
      processing = false;
    });
  }

  Future<bool> _validate() async {
    err = {};
    if(username.trim() == ""){
      err["username"] = "should be specified";
    } else {
      try {
        await UserApiImpl().findByUsername(username);
        err["username"] = "is occupied";
      } catch(e){

      }
    }
    if(email.text.trim() == ""){
      err["email"] = "should be specified";
    } else if(!emailRegex.hasMatch(email.text)) {
      err["email"] = "is incorrect";
    }
    if(first.text.trim() == ""){
      err["first"] = "should be specified";
    }
    if(last.text.trim() == ""){
      err["last"] = "should be specified";
    }
    if(phone.text.trim() != "" && !phoneRegex.hasMatch(phone.text.trim())) {
      err["phone"] = "is incorrect";
    }

    if(password.text == null || password.text.trim() == "") {
      err["password"] = "should be specified";
    }
    return err.isEmpty;
  }

}