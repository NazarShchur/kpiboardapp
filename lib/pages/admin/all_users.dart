import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpiboardapp/api/admin_api.dart';
import 'package:kpiboardapp/api/impl/admin_api_impl.dart';
import 'package:kpiboardapp/entity/User.dart';

class AllUsersPage extends StatelessWidget {
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
        if(snapshot.hasData){
          final users = snapshot.data;
          return Table(
            children: [
              TableRow(
                children: [
                  Text("id"), Text("username")
                ]
              ),
              ...users.map((e) => TableRow(
                children: [Text(e.id.toString()), Text(e.username)]
              ))
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