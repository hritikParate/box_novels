import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
// import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:box_novels/components/list_view_novel.dart';
import 'search_screen.dart';
import 'chapter_list.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

//Latest
List<String> title = [];
List<String> link = [];
List<String> imgLink = [];
List<String> titleC = [];
List<String> linkC = [];

//popular

List<String> ptitle = [];
List<String> plink = [];
List<String> pimgLink = [];
List<String> ptitleC = [];
List<String> plinkC = [];

class _HomeScreenState extends State<HomeScreen> {
  bool showSpinner = false;

  void _getData(String url, String ext) async {
    var uri = Uri.https(url, ext);
    final response = await http.get(uri);
    dom.Document document = parser.parse(response.body);
    final elements =
        document.getElementsByClassName('item-thumb c-image-hover');
    setState(() {
      title = elements
          .map((element) =>
              element.getElementsByTagName('a')[0].attributes['title'])
          .toList();
      link = elements
          .map((element) =>
              element.getElementsByTagName('a')[0].attributes['href'])
          .toList();
      imgLink = elements
          .map((element) =>
              element.getElementsByTagName('img')[0].attributes['src'])
          .toList();
    });

    print(title);
    print(link);
    print(imgLink);
  }

  void _getPopularData(String url, String ext) async {
    setState(() {
      showSpinner = true;
    });
    var uri = Uri.https(url, ext);
    final response = await http.get(uri);
    dom.Document document = parser.parse(response.body);
    final elements = document
        .getElementsByClassName('popular-img widget-thumbnail c-image-hover');
    setState(() {
      ptitle = elements
          .map((element) =>
              element.getElementsByTagName('a')[0].attributes['title'])
          .toList();
      plink = elements
          .map((element) =>
              element.getElementsByTagName('a')[0].attributes['href'])
          .toList();
      pimgLink = elements
          .map((element) =>
              element.getElementsByTagName('img')[0].attributes['src'])
          .toList();
    });

    print(ptitle);
    print(plink);
    print(pimgLink);
    setState(() {
      showSpinner = false;
    });
  }

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

  void _getPChpData(String url, String ext) async {
    var uri = Uri.https(url, ext);
    final response = await http.get(uri);
    dom.Document document = parser.parse(response.body);
    final elements = document.getElementsByClassName('wp-manga-chapter');
    setState(() {
      ptitleC = elements
          .map((element) => element.getElementsByTagName('a')[0].innerHtml)
          .toList();
      plinkC = elements
          .map((element) =>
              element.getElementsByTagName('a')[0].attributes['href'])
          .toList();
    });

    print(ptitleC);
    print(plinkC);
  }

  @override
  void initState() {
    _getData('boxnovel.com', '');
    _getPopularData('boxnovel.com', '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Box Novel',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.search_rounded),
        onPressed: () {
          showModalBottomSheet(
              context: context, builder: (context) => SearchScreen());
        },
      ),
      backgroundColor: Colors.white24,
      body: ModalProgressHUD(
        color: Colors.blueGrey,
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                padding: EdgeInsets.only(left: 10),
                alignment: AlignmentDirectional.topStart,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Latest',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: ListView.builder(
                      itemCount: title.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 13),
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black45,
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
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                padding: EdgeInsets.only(left: 10),
                alignment: AlignmentDirectional.topStart,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Popular',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: ListView.builder(
                      itemCount: ptitle.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 13),
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black45,
                          ),
                          child: ListTile(
                            onTap: () async {
                              setState(() {
                                showSpinner = true;
                              });
                              print(plink[index].substring(8, 20));
                              print(plink[index].substring(20));
                              await _getPChpData(plink[index].substring(8, 20),
                                  plink[index].substring(20));
                              setState(() {
                                showSpinner = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChapterList(
                                            titleC: ptitleC.reversed.toList(),
                                            linkC: plinkC.reversed.toList(),
                                          )));
                            },
                            title: Text(
                              ptitle[index],
                              style: TextStyle(color: Colors.white),
                            ),
                            leading: CircleAvatar(
                              foregroundImage: NetworkImage(pimgLink[index]),
                              child: CircleAvatar(
                                backgroundColor: Colors.teal,
                                backgroundImage: NetworkImage(pimgLink[index] ??
                                    "https://img.icons8.com/plasticine/2x/no-image.png"),
                                radius: 68.0,
                              ),
                            ),
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
