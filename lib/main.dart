import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
//import 'package:html/dom.dart' as dom;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smithsonian Photocontest',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Smithsonian Photo of the day'),
    );
  }
}

class PodWidget extends StatefulWidget {
  PodWidget({Key key, this.url}) : super(key: key);
  final String url;

  @override
  _PodWidgetState createState() => _PodWidgetState();
}

class _PodWidgetState extends State<PodWidget> {
  String podTitle;
  String podDescription;
  String podImageURL;

  _getPhotoOfTheDay() {
    String title;
    String description;
    String imageURL;
    var response = http.get(this.widget.url);
    response.then((resp) {
      var document = parse(resp.body);
      const titleSelector =
          'body > div.container > div.photo-contest-content.photo-contest-detail-content.photo-contest-detail-wrapper > div.photo-contest-detail-title';
      var elm = document.querySelector(titleSelector);
      title = elm.text;
      const descriptionSelector =
          'body > div.container > div.photo-contest-content.photo-contest-detail-content.photo-contest-detail-wrapper > p.photo-contest-detail-caption';
      elm = document.querySelector(descriptionSelector);
      description = elm.text;
      const imageUrlSelector =
          '#hero > div.photo-contest-detail-image > div > div.slideshow-slides > div > img';
      elm = document.querySelector(imageUrlSelector);
      imageURL = elm.attributes['src'];
    }).catchError((e) {
      throw "Could not fetch photo of the day info from smithsonianmag.com";
    }).whenComplete(() {
      setState(() {
        podTitle = title;
        podDescription = description;
        podImageURL = imageURL;
      });
    });
  }

  _launchUrl(String url) async {
    final source = "smith_pod";
    final target = "$url?utm_source=$source";
    if (await canLaunch(target)) {
      await launch(target);
    } else {
      throw 'Could not launch $target';
    }
  }

  @override
  void initState() {
    super.initState();
    _getPhotoOfTheDay();
  }

  @override
  Widget build(BuildContext context) {
    if (podTitle != null) {
      return Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                podTitle,
                style: Theme.of(context).textTheme.display1,
                textAlign: TextAlign.left,
              ),
            ),
            Text(
              podDescription,
            ),
            GestureDetector(
              onTap: () => _launchUrl(this.widget.url),
              child: RichText(
                text: new TextSpan(
                  text: 'view on smithsonianmag.com',
                  style: new TextStyle(color: Colors.blue),
                ),
              ),
            ),
            Image.network(podImageURL)
          ],
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[CircularProgressIndicator()],
      );
    }
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List podInfoList = new List();

  _fetchPodInfoList() {
    setState(() {
      podInfoList.add({
        'url': 'https://www.smithsonianmag.com/photocontest/photo-of-the-day/'
      });
    });
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: podInfoList.length,
      itemBuilder: (context, position) {
        print('position: $position');
        return PodWidget(url: podInfoList[position]['url']);
      },
    );
  }

  List<Widget> _loadActions() {
    return <Widget>[
      IconButton(
        onPressed: _fetchPodInfoList,
        tooltip: "fetch photos",
        icon: Icon(Icons.refresh),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: _loadActions(),
      ),
      body: _buildListView(),
    );
  }
}
