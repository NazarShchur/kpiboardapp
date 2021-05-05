import 'package:kpiboardapp/entity/psot.dart';

abstract class PostApi {
  Future<Post> save(Post post);

  Future<Post> update(Post post);

  Future<List<Post>> allPosts();

  Future<Post> findById(int id);

  Future<void> delete(Post post);
}