import 'package:flutter/material.dart';
import 'package:kpiboardapp/api/impl/user_api_impl.dart';
import 'package:kpiboardapp/api/user_api.dart';
import 'package:kpiboardapp/entity/User.dart';
import 'package:kpiboardapp/entity/role.dart';
import 'package:kpiboardapp/pages/admin/admin_panel.dart';
import 'package:kpiboardapp/pages/default/login.dart';
import 'package:kpiboardapp/pages/default/posts.dart';
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
          if (snapshot.hasData) {
            final user = snapshot.data;
            return Scaffold(
                appBar: AppBar(
                  title: Text("User Page"),
                  actions: [
                    [Role.ADMIN, Role.MODERATOR].contains(user.role)
                        ? IconButton(
                            icon: Icon(Icons.verified_user_outlined),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminPage(user: user))))
                        : Container(),
                    IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.clear();
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        })
                  ],
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Username: " + user.username),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Posts()));
                      }, child: Text("Posts"))],
                  ),
                ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<User> principal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return api.findByUsername(prefs.getString("username"));
  }
}
