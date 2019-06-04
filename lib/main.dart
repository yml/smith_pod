import 'package:flutter/material.dart';

import 'pages/pod.dart';

void main() => runApp(SmithApp());

class SmithApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smithsonian Photocontest',
      theme: ThemeData.dark(),
      home: PodListPage(title: 'Smithsonian Photo of the day'),
    );
  }
}

