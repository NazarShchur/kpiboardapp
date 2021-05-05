import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpiboardapp/entity/User.dart';
import 'package:kpiboardapp/pages/admin/all_users.dart';

import '../AdminOnly.dart';
import 'new_post_page.dart';

class AdminPage extends StatelessWidget {
  final User user;

  const AdminPage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
      ),
      body: Center(
        child: Column(
          children: [
            Admin(
              user: user,
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AllUsersPage()));
                },
                child: Text("All Users"),
              ),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewPostPage()));
              },
              child: Text("Create Post"),
            ),
          ],
        ),
      ),
    );
  }
}
