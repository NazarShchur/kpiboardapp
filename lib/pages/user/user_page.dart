import 'package:flutter/material.dart';
import 'package:kpiboardapp/api/impl/user_api_impl.dart';
import 'package:kpiboardapp/api/user_api.dart';
import 'package:kpiboardapp/entity/User.dart';
import 'package:kpiboardapp/entity/role.dart';
import 'package:kpiboardapp/pages/admin/admin_panel.dart';
import 'package:kpiboardapp/pages/default/login.dart';
import 'package:kpiboardapp/pages/default/posts.dart';
import 'package:kpiboardapp/pages/user/board_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  UserApi api = new UserApiImpl();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: principal(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          final user = snapshot.data;
          return Scaffold(
              appBar: AppBar(
                shadowColor: Colors.transparent,
                title: Text("User Page"),
              ),
              drawer: BoardDrawer(),
              body: snapshot.hasData
                  ? Container(
                      color: Color(0xFFF2F2F2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              color: Theme.of(context).accentColor,
                              height: 200,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.account_circle_outlined,
                                      color: Colors.white, size: 130),
                                  Text(
                                    "${user.name} ${user.surname}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  )
                                ],
                              )),
                          SizedBox(height: 5),
                          Container(
                            padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
                            decoration: BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(0, 1), // changes position of shadow
                              ),
                            ]),
                            child: Row(
                              children: [
                                Text("Email:", style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(width: 40),
                                Text(user.email??"-"),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
                            decoration: BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(0, 1), // changes position of shadow
                              ),
                            ]),
                            child: Row(
                              children: [
                                Text("Phone:", style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(width: 40),
                                Text(user.phone??"-"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(child: CircularProgressIndicator()));
        });
  }

  Future<User> principal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return api.findByUsername(prefs.getString("username"));
  }
}
