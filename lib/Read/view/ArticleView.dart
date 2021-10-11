import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class ArticleView extends StatefulWidget {
  final String? imgUrl, title, desc, content, author, posturl;

  ArticleView(
      {this.imgUrl,
      this.desc,
      this.title,
      this.content,
      this.author,
      @required this.posturl});

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool? _loading;

  @override
  void initState() {
    super.initState();
    _loading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              WebView(
                initialUrl: widget.posturl,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                onPageFinished: (finish) {
                  setState(() {
                    _loading = false;
                  });
                },
              ),
              Positioned(
                left: -8.0,
                top: 50.0,
                child: MaterialButton(
                    elevation: 40.0,
                    minWidth: 10.0,
                    color: Colors.cyanAccent,
                    shape: CircleBorder(),
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_back, color: Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ),
              if (_loading == true)
                Center(
                  child: CircularProgressIndicator(),
                )
              else
                Stack()
            ],
          ),
        ),
      ),
    );
  }
}
