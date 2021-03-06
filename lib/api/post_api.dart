import 'dart:io';

import 'package:kpiboardapp/entity/psot.dart';

abstract class PostApi {
  Future<Post> save(Post post);

  Future<Post> update(Post post);

  Future<List<Post>> allPosts({Map<String, dynamic> filters});

  Future<Post> findById(int id);

  Future<void> delete(Post post);

  Future<String> uploadImage(File file);
}