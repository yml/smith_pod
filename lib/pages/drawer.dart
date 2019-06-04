import 'package:flutter/material.dart';
import 'pod.dart';

class SmithDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new DrawerHeader(
            child: new Text("Smithsonian Magazine"),
          ),
          new ListTile(
            title: new Text("Smartnews"),
            onTap: () {
              Navigator.push(ctx,
                  new MaterialPageRoute(builder: (ctx) => new PodListPage()));
            },
          ),
          new ListTile(
            title: new Text("Photos of the day"),
            onTap: () {
              Navigator.push(ctx,
                  new MaterialPageRoute(builder: (ctx) => new PodListPage()));
            },
          ),
        ],
      ),
    );
  }
}

