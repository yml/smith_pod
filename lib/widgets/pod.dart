import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

import 'package:smith_pod/pages/pod.dart';

class PodInfo {
  String url;
  bool _isFetched;
  String title;
  String description;
  String author;
  String imageSrc;

  PodInfo.fromUrl(this.url) {
    this._isFetched = false;
    this.title = null;
    this.description = null;
    this.author = null;
    this.imageSrc = null;
  }

  final String baseURL = "https://smithsonianmag.com";
  bool get isFeched => _isFetched;
  String get absoluteUrl => "$baseURL$url?utm=mobileApp";

  fetchDetail() async {
    const String heroSelector = '#hero';
    const String authorSelector =
        "body > div.photo-contest-photographer-detail-section > div > div.photo-contest-photographer-name-location > div.photo-contest-detail-photographer-name > a";
    const String imageSrcSelector =
        "#hero > div.photo-contest-detail-image > div > div.slideshow-slides > div > img";
    if (!_isFetched) {
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
}

class PodFetcher {
  bool isPerformingRequest = false;
  final String podListURL =
      "https://www.smithsonianmag.com/photocontest/photo-of-the-day/";
  final String podListSelector =
      "#Page-Content > div > div.photo-contest-photos > div > div.photo-contest-photo > a";
  int currentPodPage = 1;

  String _buildCurrentPodURL() {
    return "$podListURL?page=$currentPodPage";
  }

  Future<List<PodInfo>> fetch() async {
    List pods = List<PodInfo>();
    if (!isPerformingRequest) {
      isPerformingRequest = true;
    } else {
      return List();
    }
    var response = await http.get(_buildCurrentPodURL());
    final document = parse(response.body);
    final elm = document.querySelectorAll(podListSelector);

    currentPodPage++;
    elm.forEach((podElm) {
      pods.add(PodInfo.fromUrl(podElm.attributes['href']));
    });
    isPerformingRequest = false;
    print('signaling the state change');

    return pods;
  }
}

class PodWidget extends StatefulWidget {
  PodWidget({Key key, this.podInfo}) : super(key: key);
  final PodInfo podInfo;

  @override
  _PodWidgetState createState() => _PodWidgetState();
}

class _PodWidgetState extends State<PodWidget> {
  _fetchPod() async {
    if (widget.podInfo.isFeched == false) {
      await widget.podInfo.fetchDetail();
      if (this.mounted) {
        setState(() {
          print("Updating the widget after fetching pod details");
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPod();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.podInfo.isFeched == true) {
      return Card(
        child: GestureDetector(
          onTap: () {
            Widget podDetailPage =
                PodDetailPage(url: widget.podInfo.absoluteUrl);
            print("this is a tap in the card");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => podDetailPage),
            );
          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.podInfo.title,
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
                    widget.podInfo.description,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    top: 8.0,
                    bottom: 8.0
                    ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("by: ${widget.podInfo.author}"),
                  )),
              CachedNetworkImage(
                placeholder: (context, url) => Padding(
                  padding: EdgeInsets.only(top:8.0),
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                imageUrl: widget.podInfo.imageSrc,
              ),
              RaisedButton(
                color: Colors.blueGrey,
                onPressed: () async {
                  await Wallpaper.homeScreen(widget.podInfo.imageSrc);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.wallpaper),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Set Wallpaper"),
                    ),
                  ],
                ),
              )
            ],
          ),
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
