import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpiboardapp/api/admin_api.dart';
import 'package:kpiboardapp/api/impl/admin_api_impl.dart';
import 'package:kpiboardapp/entity/User.dart';
import 'package:kpiboardapp/entity/role.dart';

class AllUsersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AllUsersState();
}

class AllUsersState extends State<AllUsersPage> {
  final AdminApi api = AdminApiImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All users"),
      ),
      body: FutureBuilder(
        future: api.findAllUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data;
            return Table(
              children: [
                TableRow(children: [
                  Text("id"),
                  Text("username"),
                  Text("role"),
                  Text("action")
                ]),
                ...users.map((e) => TableRow(children: [
                      Text(e.id.toString()),
                      Text(e.username),
                      Text(e.role.toString()),
                      e.role == Role.USER
                          ? PromoteToModerator(
                              user: e,
                              callback: () {
                                setState(() {
                                  e.role = Role.MODERATOR;
                                });
                              })
                          : e.role == Role.MODERATOR
                              ? DemoteModerator(
                                  user: e,
                                  callback: () {
                                    setState(() {
                                      e.role = Role.USER;
                                    });
                                  })
                              : Container()
                    ]))
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class PromoteToModerator extends StatelessWidget {
  final User user;
  final Function callback;

  const PromoteToModerator({Key key, this.user, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = AdminApiImpl();
    return user.role == Role.USER
        ? RaisedButton(
            child: Text("Promote"),
            onPressed: () {
              api.setUserRole(Role.MODERATOR, user.id).then((value) {
                callback();
              });
            })
        : Container();
  }
}

class DemoteModerator extends StatelessWidget {
  final User user;
  final Function callback;

  const DemoteModerator({Key key, this.user, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = AdminApiImpl();
    return user.role == Role.MODERATOR
        ? RaisedButton(
            child: Text("Demote"),
            onPressed: () {
              api.setUserRole(Role.USER, user.id).then((value) {
                callback();
              });
            })
        : Container();
  }
}
