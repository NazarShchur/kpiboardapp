
import 'package:flutter/material.dart';
import 'package:kpiboardapp/pages/change_notifier/GlobalNotifier.dart';
import 'package:kpiboardapp/pages/default/login.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context)=>GlobalNotifier(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: LoginPage(),
      ),
    );
  }
}

