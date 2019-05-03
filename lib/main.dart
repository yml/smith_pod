import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:html/dom.dart' as dom;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smithsonian Photocontest',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Smithsonian Photo of the day'),
    );
  }
}

class PodWidget extends StatefulWidget {
  PodWidget({Key key, this.podInfo}) : super(key: key);
  final PodInfo podInfo;

  @override
  _PodWidgetState createState() => _PodWidgetState();
}

class _PodWidgetState extends State<PodWidget> {
  _launchUrl(String url) async {
    final source = "smith_pod";
    final target = "$url?utm_source=$source";
    if (await canLaunch(target)) {
      await launch(target);
    } else {
      throw 'Could not launch $target';
    }
  }

  _fetchPod() async {
    if (this.widget.podInfo.isFeched == false) {
      (await this.widget.podInfo.fetchPodDetail());
      setState(() {
        print("Updating the widget after fetching pod details");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPod();
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.podInfo.isFeched == true) {
      return Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  this.widget.podInfo.title,
                  style: Theme.of(context).textTheme.display1,
                  // textAlign: TextAlign.left,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  this.widget.podInfo.description,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("by: ${this.widget.podInfo.author}"),
                )),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                bottom: 8.0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => _launchUrl(this.widget.podInfo.absoluteUrl),
                  child: RichText(
                    text: new TextSpan(
                      text: 'view on smithsonianmag.com',
                      style: new TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
            CachedNetworkImage(
              placeholder: (context, url) => new Padding(
                    padding: const EdgeInsets.all(100),
                    child: CircularProgressIndicator(),
                  ),
              errorWidget: (context, url, error) => new Icon(Icons.error),
              imageUrl: this.widget.podInfo.imageSrc,
            )
          ],
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 400,
          )
        ],
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

class PodInfo {
  String url;
  bool _isFetched;
  String title;
  String description;
  String author;
  String imageSrc;

  PodInfo(this.url, this.title, this.description, this.author, this.imageSrc) {
    this._isFetched = false;
  }
  PodInfo.fromUrl(this.url) {
    this._isFetched = false;
    this.title = null;
    this.description = null;
    this.author = null;
    this.imageSrc = null;
  }

  final String baseURL = "https://smithsonianmag.com";
  bool get isFeched => _isFetched;
  String get absoluteUrl => "$baseURL$url";

  fetchPodDetail() async {
    const String heroSelector = '#hero';
    const String authorSelector =
        "body > div.photo-contest-photographer-detail-section > div > div.photo-contest-photographer-name-location > div.photo-contest-detail-photographer-name > a";
    const String imageSrcSelector =
        "#hero > div.photo-contest-detail-image > div > div.slideshow-slides > div > img";
    try {
      final response = await http.get(absoluteUrl);
      final document = parse(response.body);
      var elm = document.querySelector(heroSelector);
      final titleElm = elm.nextElementSibling.nextElementSibling;
      title = titleElm.text;
      description = titleElm.nextElementSibling.text;
      elm = document.querySelector(authorSelector);
      author = elm.text;
      elm = document.querySelector(imageSrcSelector);
      imageSrc = elm.attributes["src"];
      _isFetched = true;
    } catch (e) {
      print("an error occured while getting $e");
    }
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List podInfoList = new List();
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  String podListURL =
      "https://www.smithsonianmag.com/photocontest/photo-of-the-day/";
  int currentPodPage = 1;

  String _buildCurrentPodURL() {
    return "$podListURL?page=$currentPodPage";
  }

  _fetchPodInfoList() async {
    if (!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
      });
      const String podListSelector =
          "#Page-Content > div > div.photo-contest-photos > div > div.photo-contest-photo > a";
      var response = await http.get(_buildCurrentPodURL());
      final document = parse(response.body);
      final elm = document.querySelectorAll(podListSelector);

      currentPodPage++;
      setState(() {
        elm.forEach((podElm) {
          podInfoList.add(PodInfo.fromUrl(podElm.attributes['href']));
        });
        isPerformingRequest = false;
        print('signaling the state change');
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
        _fetchPodInfoList();
      }
    });
    _fetchPodInfoList();
  }

  @override
  void dispose() {
    super.dispose();
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildListView(),
    );
  }
}
