import 'package:flutter/material.dart';

import '../widgets/pod.dart';

class PodListPage extends StatefulWidget {
  PodListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PodPageState createState() => _PodPageState();
}

class _PodPageState extends State<PodListPage> {
  List podInfoList = new List();
  ScrollController _scrollController = new ScrollController();
  PodFetcher podFetcher = new PodFetcher();

  fetchMorePods() async {
    List pods = await podFetcher.fetch();
    setState(() {
      pods.forEach((podElm) {
        podInfoList.add(podElm);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("fetching another page ...");
        fetchMorePods();
      }
    });
    fetchMorePods();
  }

  @override
  void dispose() {
    super.dispose();
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
