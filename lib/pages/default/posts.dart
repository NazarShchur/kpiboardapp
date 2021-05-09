import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kpiboardapp/api/impl/post_api_impl.dart';
import 'package:kpiboardapp/entity/psot.dart';
import 'package:kpiboardapp/pages/default/post_page.dart';
import 'package:kpiboardapp/pages/default/date_ext.dart';

class Posts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PostsState();
}

class PostsState extends State<Posts> {
  var postsApi = new PostApiImpl();
  static const _pageSize = 20;

  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final posts = (await postsApi.allPosts());
      var newItems = posts.sublist(
          pageKey,
          pageKey + _pageSize > posts.length
              ? posts.length
              : pageKey + _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Posts")),
      body: Container(
        padding: EdgeInsets.only(left: 2, right: 2),
        color: Color(0xFFF2F2F2),
        child: PagedListView<int, Post>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Post>(
              itemBuilder: (context, item, index) => PostPreview(post: item)),
        ),
      ),
    );
  }
}

class PostPreview extends StatelessWidget {
  final Post post;

  const PostPreview({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PostPage(post: post)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.author.username, style: TextStyle(fontSize: 14)),
                  Text(post.date.date(),
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Text(post.header,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                overflow: TextOverflow.ellipsis),
            post.image == null ? Container() :
            Image.network(post.image, loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null ?
                  loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                      : null,
                ),
              );
            }),
            Text(post.text,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16))
          ],
        ),
      ),
    );
  }
}
