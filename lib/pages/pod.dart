import 'package:flutter/material.dart';

import '../widgets/pod.dart';

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
    if (this.mounted) {
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
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("fetching another page ...");
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
