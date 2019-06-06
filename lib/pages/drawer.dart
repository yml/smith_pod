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
                      builder: (ctx) =>
                          new ArticleListPage(section: "Smart News")));
            },
          ),
          new ListTile(
            title: new Text("History"),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(
                  ctx,
                  new MaterialPageRoute(
                      builder: (ctx) =>
                          new ArticleListPage(section: "History")));
            },
          ),
          new ListTile(
            title: new Text("Innovation"),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(
                  ctx,
                  new MaterialPageRoute(
                      builder: (ctx) =>
                          new ArticleListPage(section: "Innovation")));
            },
          ),
          new ListTile(
            title: new Text("Science"),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(
                  ctx,
                  new MaterialPageRoute(
                      builder: (ctx) =>
                          new ArticleListPage(section: "Science")));
            },
          ),
          new ListTile(
            title: new Text("Photos of the day"),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(ctx,
                  new MaterialPageRoute(builder: (ctx) => new PodListPage()));
            },
          ),
        ],
      ),
    );
  }
}
