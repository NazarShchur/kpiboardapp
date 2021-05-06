import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpiboardapp/api/impl/post_api_impl.dart';
import 'package:kpiboardapp/api/impl/user_api_impl.dart';
import 'package:kpiboardapp/api/user_api.dart';
import 'package:kpiboardapp/entity/User.dart';
import 'package:kpiboardapp/entity/psot.dart';
import 'package:kpiboardapp/entity/role.dart';
import 'package:kpiboardapp/pages/admin/edit_post_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage({Key key, @required this.post}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PostState();
}

class PostState extends State<PostPage> {
  UserApi api = new UserApiImpl();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: principal(),
      builder: (c, snap) {
        var user = snap.data;
        return snap.hasData ? Scaffold(
            appBar: AppBar(
              title: Text(widget.post.header, overflow: TextOverflow.ellipsis),
              actions: [[Role.ADMIN, Role.MODERATOR].contains(user.role) ? EditPost(post: widget.post) : Container()],
            ),
            body: Container(
              child: Center(
                child: Text(widget.post.text),
              ),
            )) : CircularProgressIndicator();
      },
    );
  }

  Future<User> principal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return api.findByUsername(prefs.getString("username"));
  }
}

class EditPost extends StatefulWidget {
  final Post post;

  const EditPost({Key key, @required this.post}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EditPostState();
}

class EditPostState extends State<EditPost> {
  var button = "Edit";
  var postApi = PostApiImpl();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            value: button,
            icon: Icon(Icons.settings),
            items: [
              DropdownMenuItem(
                value: "Edit",
                child: Container(
                  child: Text(
                    "Edit",
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ),
              ),
              DropdownMenuItem(
                  value: "Delete",
                  child: Text("Delete",
                      style: TextStyle(color: Theme.of(context).accentColor)))
            ],
            onChanged: (val) {
              if (val == "Edit") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => EditPostPage(post: widget.post)));
              } else if (val == "Delete") {
                postApi.delete(widget.post).then((value) => Navigator.pop(context));
              }
            }),
      ),
    );
  }
}
