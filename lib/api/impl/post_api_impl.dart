import 'dart:convert';
import 'dart:io';

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
  Future<List<Post>> allPosts() async{
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
    return p;
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

}