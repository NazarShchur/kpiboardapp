import 'dart:convert';
import 'dart:io';

import 'package:kpiboardapp/pages/default/date_ext.dart';
import 'package:http/http.dart' as http;
import 'package:kpiboardapp/api/post_api.dart';
import 'package:kpiboardapp/constants.dart';
import 'package:kpiboardapp/entity/psot.dart';
import 'package:kpiboardapp/api/request_builder.dart' as rb;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PostApiImpl implements PostApi{
  final String posts = "/posts";
  @override
  Future<List<Post>> allPosts({filters}) async{
    var req = rb.get(posts);
    var resp = await req;
    var list = jsonDecode(utf8.decode(resp.body.runes.toList()));
    List<Post> p = [];
    for(var e in list) {
      p.add(Post.fromJson(e as Map<String, dynamic>));
    }
    p.sort((a, b){
      if(a.date.isAfter(b.date)){
        return -1;
      } else {
        return 1;
      }
    });
    return filters == null || filters.isEmpty ? p : _filter(p, filters);
  }

  @override
  Future<void> delete(Post post) async{
    var req = rb.delete(posts + "/" + post.id.toString());
    await req;
  }

  @override
  Future<Post> findById(int id) async{
    var req = rb.get(posts + "/" + id.toString());
    var resp = await req;
    return Post.fromJson(jsonDecode(resp.body));
  }

  @override
  Future<Post> save(Post post, {image: File}) async{
    if(image != null) {
      post.image = await uploadImage(image);
    }
    var req = rb.post(posts, body: jsonEncode(post.toJson()));
    var resp = await req;
    return Post.fromJson(jsonDecode(resp.body));
  }

  @override
  Future<Post> update(Post post, {image: File}) async{
    if(image != null) {
      post.image = await uploadImage(image);
    }
    var req = rb.put(posts, body: jsonEncode(post.toJson()));
    var resp = await req;
    return Post.fromJson(jsonDecode(resp.body));
  }

  @override
  Future<String> uploadImage(File file) async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var formData = FormData.fromMap({
     "file" : await MultipartFile.fromFile(file.path)
    });
    var options = Options(
      responseType: ResponseType.plain,
        headers: {
      "Authorization": "Bearer_" + _prefs.get("token"),
      "Accept": "application/json",
      "content-type": "application/json"
    });
    var resp = await Dio().post("http://${Constants.HOST}/posts/image", data: formData, options: options);
    return resp.data;
  }

  List<Post> _filter(List<Post> posts, Map<String, dynamic> filters) {
    if(filters["user"] != null && filters["user"]!="" ) {
      posts = posts.where((Post element) => element.author.username.contains(filters["user"])).toList();
    }
    if(filters["text"]  != null && filters["text"]!="") {
      posts = posts.where((Post element) => element.text.contains(filters["text"]) || element.header.contains(filters["text"])).toList();
    }
    if(filters["start_date"]  != null ) {
      var sd = DateTime.parse(filters["start_date"]);
      posts = posts.where((Post element) => element.date.isSameDateOrAfter(sd)).toList();
    }
    if(filters["end_date"]  != null ) {
      var ed = DateTime.parse(filters["end_date"]);
      posts = posts.where((Post element) => element.date.isSameDateOrBefore(ed)).toList();
    }
    return posts;

  }

}