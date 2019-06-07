import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

class ArticleInfo {
  String url;
  String title;
  String description;
  String byLine;
  String imageSrc;
  bool _isFetched = false;

  ArticleInfo(
      this.url, this.title, this.description, this.byLine, this.imageSrc);

  ArticleInfo.fromUrl(this.url) {
    this.title = null;
    this.description = null;
    this.byLine = null;
    this.imageSrc = null;
    this._isFetched = false;
  }

  final String searchURL = "https://smithsonianmag.com/search/?categories=";
  final String baseURL = "https://smithsonianmag.com";

  String get absoluteUrl => "$baseURL$url";
  bool get isFeched => _isFetched;
}

class ArticleFetcherByCategory {
  bool isPerformingRequest = false;
  final String searchURL = "https://www.smithsonianmag.com/search/";
  final String searchResultSelector = "#resultsList .search-result";
  int currentPodPage = 1;
  String category;

  ArticleFetcherByCategory(String category) {
    this.category = category;
  }

  String currentSearchURL() {
    return "$searchURL?categories=$category&page=$currentPodPage";
  }

  Future<List<ArticleInfo>> fetch() async {
    List articles = new List<ArticleInfo>();
    if (!isPerformingRequest) {
      isPerformingRequest = true;
    } else {
      return List();
    };

    var response = await http.get(currentSearchURL());
    final document = parse(response.body);
    final elms = document.querySelectorAll(searchResultSelector);

    currentPodPage++;
    elms.forEach((articleElm) {
      String $title;
      String $byLine;
      if (articleElm.children.length > 0) {
        $title = articleElm.children[0].attributes['href'];
      }
      if (articleElm.children.length > 3 &&
          articleElm.children[4].children.length > 0) {
        $byLine = articleElm.children[4].children[0].text.trim();
      } else {
        $byLine = "";
      }
      articles.add(ArticleInfo(
        $title,
        articleElm.children[2].firstChild.firstChild.text,
        "",
        $byLine,
        articleElm.children[0].children[0].children[0].attributes["data-src"],
      ));
    });
    isPerformingRequest = false;
    print('signaling the state change');

    return articles;
  }
}

class ArticleWidget extends StatelessWidget {
  final ArticleInfo articleInfo;

  ArticleWidget({Key key, this.articleInfo}) : super(key: key);

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
  Widget build(BuildContext ctx) {
    return Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                articleInfo.title,
                softWrap: true,
                style:
                    DefaultTextStyle.of(ctx).style.apply(fontSizeFactor: 1.4),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                width: 200,
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => new Padding(
                          padding: const EdgeInsets.all(100),
                          child: CircularProgressIndicator(),
                        ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    imageUrl: articleInfo.imageSrc,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        articleInfo.byLine,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _launchUrl(articleInfo.absoluteUrl),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          softWrap: true,
                          text: new TextSpan(
                            text: 'view on smithsonianmag.com',
                            style: new TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
