import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
// import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:web_scraper/web_scraper.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'display_novel.dart';

class ChapterList extends StatefulWidget {
  static const String id = 'chapter_list';

  final List<String> titleC;
  final List<String> linkC;
  ChapterList({this.titleC, this.linkC});
  @override
  _ChapterListState createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  bool showSpinner = false;

  var title;
  List<String> titleC;
  List<String> linkC;
  List<String> paragraph = [];
  List<String> paragraphData = [];
  var length;
  final titleList = <String>[];
  List<Map<String, dynamic>> elements;
  List<List<String>> chapData = [];

  TextEditingController editingController = TextEditingController();
  List duplicateItems = [];
  List items = [];
  var count = 0;

  void filterSearchResults(String query) {
    //items[index][0], title
    //items[index][1], link

    List dummySearchList = [];
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List dummyListData = [];
      dummySearchList.forEach((item) {
        if (item[0].toString().contains(query)) {
          dummyListData.add(item);
          setState(() {
            count = dummyListData.length;
          });
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  void _mergeChapterData(List<String> titleC, List<String> linkC) {
    for (var i = 0; i <= widget.titleC.length - 1; i++) {
      chapData.add(['${widget.titleC[i].trim()}', '${widget.linkC[i]}']);
    }
    duplicateItems = chapData;
    print(chapData);
    print(widget.titleC.last);
  }

  void _getChpData(String url, String ext) async {
    var uri = Uri.https(url, ext);
    final response = await http.get(uri);
    final document = parser.parse(response.body);

    final elements = document.getElementsByTagName('p');
    RegExp regExp = new RegExp(
      r"^[0-9]+$",
      caseSensitive: false,
      multiLine: false,
    );
    setState(() {
      var placement = 1;
      for (final element in elements) {
        if (element.innerHtml == '© 2018 BoxNovel. All rights reserved') {
          break;
        }
        print(regExp.hasMatch(element.text));
        setState(() {
          if (regExp.hasMatch(element.text) == false) {
            paragraphData.add(element.text);
          }
        });

        // print('#$placement: ${element.text}');
        placement++;
      }
    });
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _mergeChapterData(titleC, linkC);
    items.addAll(duplicateItems);
    setState(() {
      count = items.length;
    });
    super.initState();
  }

  var reverse = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      color: Colors.blueGrey,
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: chapData.length == 0
            ? Center(
                child: Text(
                "No Data",
                style: TextStyle(color: Colors.white),
              ))
            : SafeArea(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        cursorColor: Colors.white70,
                        style: TextStyle(color: Colors.white),
                        controller: editingController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(color: Colors.white),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white70, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                        ),
                        cursorHeight: 20,
                        onChanged: (value) {
                          filterSearchResults(value);
                          setState(() {
                            count = items.length;
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Total Chapters: ${count.toString()}',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    Flexible(
                      child: CupertinoScrollbar(
                        thickness: 15,
                        thicknessWhileDragging: 16,
                        isAlwaysShown: true,
                        radius: Radius.circular(20),
                        controller: _scrollController,
                        child: ListView.builder(
                            reverse: reverse,
                            controller: _scrollController,
                            itemCount: items.length,
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
                                  title: Text(
                                    items[index][0], //title
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      paragraphData.clear();
                                      showSpinner = true;
                                    });
                                    titleList.clear();
                                    await _getChpData(
                                        items[index][1].substring(8, 20), //link
                                        items[index][1].substring(20)); //link
                                    print(paragraphData);
                                    title = items[index][0]; //title
                                    setState(() {
                                      showSpinner = false;
                                    });

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DisplayNovel(
                                                  novelText: paragraphData,
                                                  title: items[index]
                                                      [0], //title
                                                )));
                                  },
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
