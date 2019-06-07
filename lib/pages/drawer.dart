import 'package:flutter/material.dart';
import 'pod.dart';
import 'article.dart';

class SmithDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Smithsonian Magazine"),
                Image.asset(
                  "assets/smith_sun_no_bg.png",
                  width: 100,
                  height: 100,
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.art_track),
            title: Text("Smart News"),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(
                  ctx,
                  MaterialPageRoute(
                      builder: (ctx) => ArticleListPage(
                            section: "Smart News",
                            appDrawer: SmithDrawer(),
                          )));
            },
          ),
          ListTile(
            leading: Icon(Icons.art_track),
            title: Text("History"),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(
                  ctx,
                  MaterialPageRoute(
                      builder: (ctx) => ArticleListPage(
                            section: "History",
                            appDrawer: SmithDrawer(),
                          )));
            },
          ),
          ListTile(
            leading: Icon(Icons.art_track),
            title: Text("Innovation"),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(
                  ctx,
                  MaterialPageRoute(
                      builder: (ctx) => ArticleListPage(
                            section: "Innovation",
                            appDrawer: SmithDrawer(),
                          )));
            },
          ),
          ListTile(
            leading: Icon(Icons.art_track),
            title: Text("Science"),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(
                  ctx,
                  MaterialPageRoute(
                      builder: (ctx) => ArticleListPage(
                            section: "Science",
                            appDrawer: SmithDrawer(),
                          )));
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_camera),
            title: Text("Photos of the day"),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(
                  ctx,
                  MaterialPageRoute(
                      builder: (ctx) => PodListPage(
                            appDrawer: SmithDrawer(),
                          )));
            },
          ),
        ],
      ),
    );
  }
}
