import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpiboardapp/api/impl/post_api_impl.dart';
import 'package:kpiboardapp/api/impl/user_api_impl.dart';
import 'package:kpiboardapp/api/user_api.dart';
import 'package:kpiboardapp/entity/User.dart';
import 'package:kpiboardapp/entity/psot.dart';
import 'package:kpiboardapp/entity/role.dart';
import 'package:kpiboardapp/pages/admin/edit_post_page.dart';
import 'package:kpiboardapp/pages/change_notifier/GlobalNotifier.dart';
import 'package:kpiboardapp/pages/default/posts.dart';
import 'package:provider/provider.dart';
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
        return Scaffold(
                appBar: AppBar(
                  title:
                      Text(widget.post.header, overflow: TextOverflow.ellipsis),
                  actions: [
                    snap.hasData && [Role.ADMIN, Role.MODERATOR].contains(user.role)
                        ? EditPost(post: widget.post)
                        : Container()
                  ],
                ),
                body: snap.hasData
                    ? ListView(
                  children: [
                    widget.post.image == null
                        ? Container()
                        : Image.network(
                            widget.post.image,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                          ),
                    Container(
                      child: Center(
                        child: Text(widget.post.text),
                      ),
                    ),
                  ],
                ): Center(child: CircularProgressIndicator()));

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
    final notifier = Provider.of<GlobalNotifier>(context);
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
                postApi.delete(widget.post).then((value) {
                  notifier.update();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => Posts()));
                });
              }
            }),
      ),
    );
  }
}
