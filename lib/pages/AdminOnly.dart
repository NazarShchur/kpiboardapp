import 'package:flutter/cupertino.dart';
import 'package:kpiboardapp/entity/User.dart';
import 'package:kpiboardapp/entity/role.dart';

class Admin extends StatelessWidget {
  final Widget child;
  final User user;

  const Admin({Key key, @required this.child, @required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return user.role == Role.ADMIN ? child : Container();
  }
}