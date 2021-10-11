import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'ArticleView.dart';

class NewsTile extends StatefulWidget {
  final String? imgUrl, title, desc, content, author, posturl;
  final DateTime? publishedAt;

  NewsTile(
      {this.imgUrl,
      this.desc,
      this.title,
      this.content,
      this.author,
      this.publishedAt,
      @required this.posturl});

  @override
  _NewsTileState createState() => _NewsTileState();
}

class _NewsTileState extends State<NewsTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      child: GestureDetector(
        onTap: () {
          print('news tile pressed');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleView(
                        imgUrl: widget.imgUrl,
                        title: widget.title,
                        desc: widget.desc,
                        content: widget.content,
                        author: widget.author,
                        posturl: widget.posturl,
                      )));
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white70,
              border: Border.all(
                width: 2.0,
                color: Colors.grey.shade700,
              ),
              borderRadius: BorderRadius.circular(12.0)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            articleImage(),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  articleTitle(),
                  articleDescription(),
                  Divider(
                    height: 6.0,
                    thickness: 1.2,
                  ),
                  authorSource(),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Wrap articleDescription() {
    return Wrap(children: [
      Text(widget.desc.toString(),
          style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800)),
    ]);
  }

  Text articleTitle() {
    return Text(widget.title.toString(),
        style: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black));
  }

  Widget articleImage() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
      child: Container(
        height: 250.0,
        color: Colors.grey.shade900,
        width: MediaQuery.of(context).size.width,
        child: Image.network(
          widget.imgUrl.toString(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Padding authorSource() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.author != null
                  ? GestureDetector(
                      onTap: () {
                        print('author is ${widget.author}');
                      },
                      child: Text(widget.author.toString(),
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                    )
                  : Text(''),
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.black,
                ),
                onPressed: () {
                  Share.share(
                    'I found this on NewsTastic app.  \n \n \n ${widget.posturl}',
                    subject: 'I found this on NewsTastic app.',
                  );
                  print(
                      'I found this on NewsTastic app.  \n ${widget.posturl}');
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
