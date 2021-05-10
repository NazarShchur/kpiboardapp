import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpiboardapp/entity/User.dart';
import 'package:kpiboardapp/pages/admin/all_users.dart';
import 'package:kpiboardapp/pages/user/board_drawer.dart';

import '../AdminOnly.dart';
import 'new_post_page.dart';

class AdminPage extends StatelessWidget {
  final User user;

  const AdminPage({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
      ),
      drawer: BoardDrawer(),
      body: Container(
        color: Color(0xFFF2F2F2),
        child: Column(
          children: [
            Admin(
              user: user,
              child: Container(
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
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AllUsersPage()));
                  },
                  child: Text("All Users"),
                ),
              ),
            ),
            SizedBox(height: 10),
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
              child: FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewPostPage()));
                },
                child: Text("Create Post"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
