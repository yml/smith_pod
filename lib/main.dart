import 'package:flutter/material.dart';
import 'package:smith_pod/pages/drawer.dart';

import 'pages/pod.dart';

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
    return PodListPage(appDrawer: SmithDrawer(),);
  }
}

