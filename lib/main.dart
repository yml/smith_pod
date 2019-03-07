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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
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
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    if (podTitle != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            podTitle,
            style: Theme.of(context).textTheme.display1,
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
      );
    } else {
      return FloatingActionButton(
        onPressed: _getPhotoOfTheDay,
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: PodWidget(
              url:
                  'https://www.smithsonianmag.com/photocontest/photo-of-the-day/')),
    );
  }
}
