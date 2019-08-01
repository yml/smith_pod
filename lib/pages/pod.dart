import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../widgets/pod.dart';

import "dart:async";

class PodDetailPage extends StatefulWidget {
  PodDetailPage({Key key, @required this.url}): super(key: key);
  final String url;

  @override
  _PodDetailPageState createState() => _PodDetailPageState();
}

class _PodDetailPageState extends State<PodDetailPage> {
   Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photocontest Detail Page ${widget.url}"),
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

class PodListPage extends StatefulWidget {
  PodListPage({Key key, @required this.appDrawer}): super(key: key);
  final Widget appDrawer;
  final String title = "Smithsonian Photo of the day";

  @override
  _PodListPageState createState() => _PodListPageState();
}

class _PodListPageState extends State<PodListPage> {
  List podInfoList = new List();
  ScrollController _scrollController = new ScrollController();
  PodFetcher podFetcher = new PodFetcher();

  fetchMore() async {
    List pods = await podFetcher.fetch();
    if (this.mounted && pods.length > 0) {
      setState(() {
        pods.forEach((podElm) {
          podInfoList.add(podElm);
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 1000) {
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
      itemCount: podInfoList.length,
      cacheExtent: 5000,
      itemBuilder: (context, position) {
        return PodWidget(podInfo: podInfoList[position]);
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
