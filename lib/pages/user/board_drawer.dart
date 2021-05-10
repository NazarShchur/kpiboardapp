import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpiboardapp/entity/User.dart';
import 'package:kpiboardapp/entity/role.dart';
import 'package:kpiboardapp/pages/admin/admin_panel.dart';
import 'package:kpiboardapp/pages/default/login.dart';
import 'package:kpiboardapp/pages/default/posts.dart';
import 'package:kpiboardapp/pages/default/principal.dart';
import 'package:kpiboardapp/pages/user/user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height - 24;
    return FutureBuilder<User>(
        future: principal(),
        builder: (context, snap) {
          final user = snap.data;
          return Drawer(
            child: ListView(
              children: [
                Container(
                  height: height,
                  color: Color(0xFFF2F2F2),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          color: Theme.of(context).accentColor,
                          width: double.infinity,
                          height: 125,
                          child: snap.hasData
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 30),
                                    Icon(Icons.account_circle_outlined,
                                        color: Colors.white, size: 60),
                                    SizedBox(width: 30),
                                    Text(
                                      "${user.name} ${user.surname}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                )
                              : Container()),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ]),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  UserPage(owner: user)));
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Icon(Icons.account_circle_outlined),
                                        SizedBox(width: 30),
                                        Text("User page")
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ]),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Posts()));
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Icon(Icons.view_list),
                                        SizedBox(width: 30),
                                        Text("Posts")
                                      ],
                                    ),
                                  ),
                                ),
                                snap.hasData &&
                                    [Role.ADMIN, Role.MODERATOR].contains(user.role)
                                    ? Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ]),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  AdminPage(user: user)));
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Icon(Icons.verified_user_outlined),
                                        SizedBox(width: 30),
                                        Text("Administration")
                                      ],
                                    ),
                                  ),
                                ) : Container(),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ]),
                              child: TextButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.clear();
                                  while(Navigator.canPop(context)){
                                    try{
                                      Navigator.pop(context);
                                    } catch(e) {
                                      break;
                                    }
                                  }
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: Row(children: [SizedBox(width: 10), Icon(Icons.logout), SizedBox(width: 30), Text("Logout")],),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
