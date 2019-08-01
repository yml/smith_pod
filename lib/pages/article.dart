import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:smith_pod/widgets/article.dart';

import 'dart:async';


class ArticleDetailPage extends StatefulWidget {
  ArticleDetailPage({Key key, @required this.url}): super(key: key);
  final String url;

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
   Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Article Detail Page ${widget.url}"),
      ),
      body: WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
        ),
      );
  }
}


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
