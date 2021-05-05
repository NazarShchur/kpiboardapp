import 'dart:convert';

import 'package:kpiboardapp/api/post_api.dart';
import 'package:kpiboardapp/entity/psot.dart';
import 'package:kpiboardapp/api/request_builder.dart' as rb;

class PostApiImpl implements PostApi{
  final String posts = "posts/";
  @override
  Future<List<Post>> allPosts() async{
    var req = rb.get(posts);
    var resp = await req;
    var list = jsonDecode(resp.body) as List<Map<String, dynamic>>;
    return list.map((e) => Post.fromJson(e));
  }

  @override
  Future<void> delete(Post post) async{
    var req = rb.delete(posts + post.id.toString());
    await req;
  }

  @override
  Future<Post> findById(int id) async{
    var req = rb.get(posts + id.toString());
    var resp = await req;
    return Post.fromJson(jsonDecode(resp.body));
  }

  @override
  Future<Post> save(Post post) async{
    var req = rb.post(posts, body: post.toJson());
    var resp = await req;
    return Post.fromJson(jsonDecode(resp.body));
  }

  @override
  Future<Post> update(Post post) async{
    var req = rb.put(posts, body: post.toJson());
    var resp = await req;
    return Post.fromJson(jsonDecode(resp.body));
  }

}