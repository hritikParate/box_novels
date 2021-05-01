import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
// import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'chapter_list.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SearchResultList extends StatefulWidget {
  static const String id = 'search_result_list';
  final List<String> title;
  final List<String> link;
  final List<String> imgLink;

  SearchResultList({this.imgLink, this.link, this.title});
  @override
  _SearchResultListState createState() => _SearchResultListState();
}

class _SearchResultListState extends State<SearchResultList> {
  bool showSpinner = false;

  List<String> title;
  List<String> link;
  List<String> imgLink;

  List<String> titleC = [];
  List<String> linkC = [];

  void _getChpData(String url, String ext) async {
    var uri = Uri.https(url, ext);
    final response = await http.get(uri);
    dom.Document document = parser.parse(response.body);
    final elements = document.getElementsByClassName('wp-manga-chapter');
    setState(() {
      titleC = elements
          .map((element) => element.getElementsByTagName('a')[0].innerHtml)
          .toList();
      linkC = elements
          .map((element) =>
              element.getElementsByTagName('a')[0].attributes['href'])
          .toList();
    });

    print(titleC);
    print(linkC);
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    title = widget.title;
    link = widget.link;
    imgLink = widget.imgLink;
    return ModalProgressHUD(
      color: Colors.blueGrey,
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: widget.title.length == 0
            ? Center(
                child: Text(
                "No data",
                style: TextStyle(color: Colors.white),
              ))
            : CupertinoScrollbar(
                thickness: 18,
                thicknessWhileDragging: 15,
                isAlwaysShown: true,
                radius: Radius.circular(20),
                controller: _scrollController,
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: title.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(
                            left: 10, top: 4, bottom: 4, right: 20),
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.black54,
                        ),
                        child: ListTile(
                          onTap: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            print(link[index].substring(8, 20));
                            print(link[index].substring(20));
                            await _getChpData(link[index].substring(8, 20),
                                link[index].substring(20));

                            setState(() {
                              showSpinner = false;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChapterList(
                                          titleC: titleC.reversed.toList(),
                                          linkC: linkC.reversed.toList(),
                                        )));
                          },
                          title: Text(
                            title[index],
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: CircleAvatar(
                            foregroundImage: NetworkImage(imgLink[index]),
                            child: CircleAvatar(
                              backgroundColor: Colors.teal,
                              backgroundImage: NetworkImage(imgLink[index] ??
                                  "https://img.icons8.com/plasticine/2x/no-image.png"),
                              radius: 68.0,
                            ),
                          ),
                        ),
                      );
                    }),
              ),
      ),
    );
  }
}
