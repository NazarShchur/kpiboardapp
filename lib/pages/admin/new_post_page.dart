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
  bool processing = false;

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLength: 250,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Header",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                    ),
                    onChanged: (tittle) {
                      setState(() {
                        this.tittle = tittle;
                      });
                    },
                  ),
                ),
                _image == null ? Container() : Image.file(_image),
                SizedBox(height: 15),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Theme.of(context).accentColor,
                        ),
                        width: 100,
                        child: TextButton(
                          onPressed: _getImage,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                color: Colors.white,
                              ),
                              Text(
                                "Image",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _image != null
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: Theme.of(context).accentColor,
                              ),
                              width: 100,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Remove",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLength: 8000,
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Text",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                    ),
                    onChanged: (text) {
                      setState(() {
                        this.text = text;
                      });
                    },
                  ),
                ),
                processing
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        width: double.infinity,
                        color: Theme.of(context).accentColor,
                        child: FlatButton(
                            onPressed: () {
                              setState(() {
                                processing = true;
                              });
                              postApi
                                  .save(Post(header: tittle, text: text),
                                      image: _image)
                                  .then((post) {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => PostPage(post: post)));
                                setState(() {
                                  processing = false;
                                });
                              });
                            },
                            child: Text(
                              "Publish",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )),
                      )
              ],
            ),
          ),
        ]));
  }
}
