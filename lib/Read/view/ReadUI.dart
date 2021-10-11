import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:newstastic/Read/models/Articles.dart';
import 'package:newstastic/Read/models/News.dart';
import 'package:newstastic/Read/view/NewsTile.dart';

class ThemeNow {
  static bool themelight = false;
}

class Read extends StatefulWidget {
  @override
  _ReadState createState() => _ReadState();
}

class _ReadState extends State<Read> {
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  List newslist = [];
  bool _loading = true;

  void getCategoryNews(String category) async {
    setState(() {
      _loading = true;
    });
    String apiKey = '1a9616fc3e924cc4a37841ea758e062f';
    String? url =
        'http://newsapi.org/v2/top-headlines?country=in&excludeDomains=stackoverflow.com&pageSize=100&category=$category&sortBy=publishedAt&language=en&apiKey=$apiKey';
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    setState(() {
      newslist = [];
    });

    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          Article article = Article(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            urlToImage: element['urlToImage'],
            publishedAt: DateTime.parse(element['publishedAt']),
            content: element["content"],
            articleUrl: element["url"],
          );
          newslist.add(article);
        }
      });
    }

    setState(() {
      _loading = false;
    });
  }

  void getNews() async {
    setState(() {
      _loading = true;
    });
    News news = News();
    await news.getNews();

    setState(() {
      newslist = news.news;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    chipSelect();
    setState(() {
      chipSelected[0] = true;
    });

    //categories = getCategories();
    getNews();
  }

  List<String> chipLabel = [
    'All',
    'Business',
    'Technology',
    'Entertainment',
    'Science',
    'Health',
    'Sports'
  ];

  List<bool> chipSelected = [];

  void chipSelect() {
    for (int i = 0; i < chipLabel.length; i++) {
      setState(() {
        chipSelected.add(false);
      });
    }
  }

  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
            itemCount: ((newslist.length >= 0 || newslist.isNotEmpty))
                ? ((newslist.length + 1))
                : 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return categoryContainer(index);
              } else if (_loading == false) {
                return NewsTile(
                  imgUrl: newslist[index - 1].urlToImage ?? "",
                  title: newslist[index - 1].title ?? "",
                  desc: newslist[index - 1].description ?? "",
                  content: newslist[index - 1].content ?? "",
                  author: newslist[index - 1].author ?? "",
                  publishedAt: newslist[index - 1].publishedAt ?? "",
                  posturl: newslist[index - 1].articleUrl ?? "",
                );
              } else if (_loading ||
                  _loading == true ||
                  newslist.isEmpty ||
                  newslist.length == 0) {
                return Container(
                    height: MediaQuery.of(context).size.height - 110.0,
                    child: Center(
                        child: CircularProgressIndicator(
                            color: Colors.cyanAccent)));
              } else {
                return Center(
                    child: Text(
                  'Some error occured',
                  style: TextStyle(color: Colors.cyanAccent),
                ));
              }
            }));
  }

  Container categoryContainer(int index) {
    return Container(
      height: 54.0,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: chipLabel.length,
          itemBuilder: (context, indexI) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: categoryChip(chipLabel[indexI], indexI),
            );
          },
        ),
      ),
    );
  }

  ChoiceChip categoryChip(String label, int index) {
    return ChoiceChip(
        selected: chipSelected[index],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        label: Text(label),
        labelStyle: TextStyle(
            color: chipSelected[index] ? Colors.black : Colors.grey.shade400,
            fontSize: 16.0),
        backgroundColor:
            chipSelected[index] ? Colors.white : Colors.grey.shade900,
        elevation: 20,
        pressElevation: 20,
        selectedColor: Colors.white,
        selectedShadowColor: Colors.black,
        onSelected: (bool selected) {
          print('Fluter is pressed $selected');
          if (chipLabel[index] == 'All' || index == 0) {
            getCategoryNews('general');
          } else if (chipLabel[index] == 'Business' || index == 1) {
            getCategoryNews(chipLabel[index].toLowerCase());
          } else if (chipLabel[index] == 'Technology' || index == 2) {
            getCategoryNews(chipLabel[index].toLowerCase());
          } else if (chipLabel[index] == 'Entertainment' || index == 3) {
            getCategoryNews(chipLabel[index].toLowerCase());
          } else if (chipLabel[index] == 'Science' || index == 4) {
            getCategoryNews(chipLabel[index].toLowerCase());
          } else if (chipLabel[index] == 'Health' || index == 5) {
            getCategoryNews(chipLabel[index].toLowerCase());
          } else if (chipLabel[index] == 'Sports' || index == 6) {
            getCategoryNews(chipLabel[index].toLowerCase());
          }

          setState(() {
            chipSelected[index] = selected;
            for (int i = 0; i < chipSelected.length; i++) {
              if (index != i) {
                chipSelected[i] = false;
              }
            }
          });
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
