import 'dart:convert';

import 'package:kpiboardapp/main.dart';

import 'User.dart';

class Post {
  int id;
  String header;
  String text;
  User author;
  DateTime date;
  String image;

  Post({this.id, this.header, this.text, this.author, this.date, this.image});

  static List<Post> posts(List<dynamic> list) {
    List<Post> p = [];
    for(var e in list) {
      p.add(Post.fromJson(e as Map<String, dynamic>));
    }
    return p;
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json["id"],
        header: json["header"],
        text: json["text"],
        author: User.fromJson(json["author"] as Map<String, dynamic>),
        date: DateTime(json["date"][0], json["date"][1], json["date"][2]),
        image: json["image"]
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "text": text, "header": header, "image": image};
  }
}
