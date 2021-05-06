import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpiboardapp/api/impl/post_api_impl.dart';
import 'package:kpiboardapp/entity/psot.dart';
import 'package:kpiboardapp/pages/default/post_page.dart';

class NewPostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewPostState();
}

class NewPostState extends State<NewPostPage> {
  var tittle = "";
  var text = "";
  var postApi = new PostApiImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Post"),
        ),
        body: Container(
          child: Column(
            children: [
              TextField(
                onChanged: (tittle) {
                  setState(() {
                    this.tittle = tittle;
                  });
                },
              ),
              TextField(
                onChanged: (text) {
                  setState(() {
                    this.text = text;
                  });
                },
              ),
              FlatButton(
                  onPressed: () {
                    postApi.save(Post(header: tittle, text: text)).then(
                        (post) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => PostPage(post: post))));
                  },
                  child: Text("Publish"))
            ],
          ),
        ));
  }
}
