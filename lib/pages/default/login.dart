import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kpiboardapp/api/impl/user_api_impl.dart';
import 'package:kpiboardapp/constants.dart';
import 'package:kpiboardapp/entity/User.dart';
import 'package:kpiboardapp/pages/default/register.dart';
import 'package:kpiboardapp/pages/user/user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passwordfield/passwordfield.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var api = Constants.HOST + "/auth/login";
  var username;
  var password = TextEditingController();
  var message = "";
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                child: Image.asset('assets/logo1.png'),
              ),
              Text(
                message,
                style: TextStyle(color: Colors.red),
              ),
              Container(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Username",
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                  onChanged: (text) {
                    setState(() {
                      username = text;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: PasswordField(
                  hasFloatingPlaceholder: true,
                  controller: password,
                ),
              ),
              SizedBox(height: 20),
              processing ? Center(child: CircularProgressIndicator()) :
              Column(
                children: [
                  FlatButton(
                    minWidth: 200,
                    height: 45,
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    onPressed: _login,
                    child: Text("LOGIN"),
                  ),
                  SizedBox(height: 15),
                  FlatButton(
                    minWidth: 200,
                    height: 45,
                    color: Colors.grey.withOpacity(0.5),
                    textColor: Colors.black,
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RegistrationPage())),
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

  void _login() async {
    setState(() {
      processing = true;
    });
    var response = await http.post(Uri.http(Constants.HOST, "auth/login"),
        body: jsonEncode(User.us(username, password.text).toJson()),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    final SharedPreferences prefs = await _prefs;
    prefs.setString("token", jsonDecode(response.body)["token"]);
    prefs.setString("username", jsonDecode(response.body)["username"]);
    prefs.setString("role", jsonDecode(response.body)["role"]);
    if (response.statusCode == 200) {
      var owner = await UserApiImpl().findByUsername(username);
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => UserPage(owner: owner)));
    } else {
      setState(() {
        message = "Incorrect Credentials";
      });
    }
    setState(() {
      processing = false;
    });
  }
}
