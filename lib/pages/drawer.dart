import 'package:flutter/material.dart';
import 'pod.dart';
import 'article.dart';

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
            title: new Text("Smart News"),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(
                  ctx,
                  new MaterialPageRoute(
                      builder: (ctx) => new ArticleListPage(
                            section: "Smart News",
                            appDrawer: SmithDrawer(),
                          )));
            },
          ),
          new ListTile(
            title: new Text("History"),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(
                  ctx,
                  new MaterialPageRoute(
                      builder: (ctx) => new ArticleListPage(
                            section: "History",
                            appDrawer: SmithDrawer(),
                          )));
            },
          ),
          new ListTile(
            title: new Text("Innovation"),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(
                  ctx,
                  new MaterialPageRoute(
                      builder: (ctx) => new ArticleListPage(
                            section: "Innovation",
                            appDrawer: SmithDrawer(),
                          )));
            },
          ),
          new ListTile(
            title: new Text("Science"),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(
                  ctx,
                  new MaterialPageRoute(
                      builder: (ctx) => new ArticleListPage(
                            section: "Science",
                            appDrawer: SmithDrawer(),
                          )));
            },
          ),
          new ListTile(
            title: new Text("Photos of the day"),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(ctx,
                  new MaterialPageRoute(builder: (ctx) => new PodListPage(appDrawer: SmithDrawer(),)));
            },
          ),
        ],
      ),
    );
  }
}
