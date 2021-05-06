import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpiboardapp/entity/psot.dart';

class EditPostPage extends StatelessWidget {
  final Post post;

  const EditPostPage({Key key, @required this.post}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Post"),
      ),
      body: Container(),
    );
  }

}