import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kpiboardapp/api/impl/post_api_impl.dart';
import 'package:kpiboardapp/entity/psot.dart';
import 'package:kpiboardapp/pages/change_notifier/GlobalNotifier.dart';
import 'package:kpiboardapp/pages/default/filters_popup.dart';
import 'package:kpiboardapp/pages/default/post_page.dart';
import 'package:kpiboardapp/pages/default/date_ext.dart';
import 'package:kpiboardapp/pages/user/board_drawer.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Posts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PostsState();
}

class PostsState extends State<Posts> {
  var postsApi = new PostApiImpl();
  static const _pageSize = 20;

  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 0);
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, context);
    });
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _pagingController.refresh();
  }

  Future<void> _fetchPage(int pageKey, BuildContext context) async {
    final notifier = Provider.of<GlobalNotifier>(context, listen: false);
    try {
      final posts = (await postsApi.allPosts(filters: notifier.filters));
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

  void _onRefresh() async {
    _pagingController.refresh();
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<GlobalNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        actions: [
          notifier.filters.isEmpty ? IconButton(
            icon: Icon(Icons.filter_alt_sharp),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => FiltersPopup()));
            },
          ) : IconButton(
            onPressed: () {
              notifier.setFilter({});
              _pagingController.refresh();
            }
            , icon: Icon(Icons.close),

          )
        ],
      ),
      drawer: BoardDrawer(),
      body: Container(
        color: Color(0xFFF2F2F2),
        child: SmartRefresher(
          onRefresh: _onRefresh,
          enablePullDown: true,
          header: WaterDropMaterialHeader(),
          controller: refreshController,
          child: PagedListView<int, Post>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Post>(
                itemBuilder: (context, item, index) => PostPreview(post: item)),
          ),
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
        padding: EdgeInsets.only(top: 10, bottom: 10),
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
              padding: const EdgeInsets.only(left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.author.username, style: TextStyle(fontSize: 14)),
                  Text(post.date.date(),
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(post.header,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  overflow: TextOverflow.ellipsis),
            ),
            SizedBox(height: 5),
            post.image == null
                ? Container()
                : Image.network(post.image, loadingBuilder:
                    (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  }),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(post.text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}
