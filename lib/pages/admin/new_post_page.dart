import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpiboardapp/api/impl/post_api_impl.dart';
import 'package:kpiboardapp/entity/psot.dart';
import 'package:kpiboardapp/pages/default/post_page.dart';
import 'package:image_picker/image_picker.dart';

class NewPostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewPostState();
}

class NewPostState extends State<NewPostPage> {
  var tittle = "";
  var text = "";
  var postApi = new PostApiImpl();
  File _image;

  Future _getImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Post"),
        ),
        body: ListView(children: [
          Container(
            child: Column(
              children: [
                TextField(
                  onChanged: (tittle) {
                    setState(() {
                      this.tittle = tittle;
                    });
                  },
                ),
                _image == null
                    ? TextButton(
                        onPressed: _getImage,
                        child: Text("Image"),
                      )
                    : Image.file(_image),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      this.text = text;
                    });
                  },
                ),
                FlatButton(
                    onPressed: () {
                      postApi.save(Post(header: tittle, text: text), image: _image).then(
                          (post) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => PostPage(post: post))));
                    },
                    child: Text("Publish"))
              ],
            ),
          ),
        ]));
  }
}
