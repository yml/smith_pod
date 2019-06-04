import 'package:flutter/material.dart';

import 'pages/pod.dart';
import 'pages/drawer.dart';

void main() => runApp(SmithApp());

class SmithApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smithsonian Photocontest',
      theme: ThemeData.dark(),
      home: SmithDrawerApp(),
    );
  }
}

class SmithDrawerApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return new Scaffold(
      drawer: new SmithDrawer(),
      appBar: new AppBar(
        title: new Text("Smithsonian Magazine"),
      ),
      body: PodListPage(),
    );
  }
}

