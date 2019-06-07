import 'package:flutter/material.dart';
import 'package:smith_pod/widgets/article.dart';

class ArticleListPage extends StatefulWidget {
  ArticleListPage({Key key, @required this.section, @required this.appDrawer}) : super(key: key);
  final Widget appDrawer;
  final String section;

  get title {
    return "$section articles";
  }

  @override
  _ArticlePageListState createState() => _ArticlePageListState();
}

class _ArticlePageListState extends State<ArticleListPage> {
  List articleList = new List();
  ScrollController _scrollController = new ScrollController();
  ArticleFetcherByCategory articlesFetcher;

  fetchMore() async {
    List articles = await articlesFetcher.fetch();
    if (this.mounted && articles.length > 0) {
      setState(() {
        articles.forEach((articleElm) {
          articleList.add(articleElm);
        });
      });
    }
  }

  @override
  initState() {
    super.initState();
    articlesFetcher = new ArticleFetcherByCategory(widget.section);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 500) {
        print("fetching another page ...");
        print ("maxScrollExtent : ${_scrollController.position.maxScrollExtent}" );
        fetchMore();
      }
    });
    fetchMore();
  }

  Widget _buildListView() {
    return ListView.separated(
      separatorBuilder: (context, position) {
        return Divider(color: Colors.white);
      },
      itemCount: articleList.length,
      cacheExtent: 5000,
      itemBuilder: (context, position) {
        return ArticleWidget(articleInfo: articleList[position]);
      },
      controller: _scrollController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.appDrawer,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildListView()),
        ],
      ),
    );
  }
}
