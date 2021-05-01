import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayNovel extends StatefulWidget {
  final List novelText;
  final String title;
  DisplayNovel({this.novelText, this.title});

  @override
  _DisplayNovelState createState() => _DisplayNovelState();
}

class _DisplayNovelState extends State<DisplayNovel> {
  Color text = Colors.black;
  Color bg = Colors.white;
  Color appBartext = Colors.white;
  Color appBarbg = Colors.teal;
  Color fabbg = Colors.teal;

  Color scafoldColor = Colors.grey;

  Color fabborder = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border(
              top: BorderSide(color: fabborder.withOpacity(0.5)),
              left: BorderSide(color: fabborder.withOpacity(0.5)),
              right: BorderSide(color: fabborder.withOpacity(0.5)),
              bottom: BorderSide(color: fabborder.withOpacity(0.5))),
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: fabbg.withOpacity(0.5),
          child: Icon(
            Icons.format_color_fill,
            color: fabborder.withOpacity(0.5),
          ),
          onPressed: () {
            if (text == Colors.black) {
              setState(() {
                text = Colors.white70;
                bg = Colors.black45;
                appBarbg = Colors.blueGrey;
                fabbg = Colors.blueGrey;
                fabborder = Colors.white;
              });
            } else {
              setState(() {
                text = Colors.black;
                bg = Colors.white;
                appBarbg = Colors.teal;
                fabbg = Colors.teal;
                fabborder = Colors.black;
              });
            }
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: appBarbg,
        title: Text(
          "${widget.title}",
          style: TextStyle(color: appBartext),
        ),
      ),
      backgroundColor: scafoldColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          decoration:
              BoxDecoration(color: bg, borderRadius: BorderRadius.circular(15)),
          child: ListView.builder(
              itemCount: widget.novelText.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.novelText[index],
                    style: TextStyle(color: text, fontSize: 20),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
