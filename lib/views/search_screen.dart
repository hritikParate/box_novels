import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
// import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'search_result_list.dart';
import 'home_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

List<String> title = [];
List<String> link = [];
List<String> imgLink = [];
String searchData = '';

class _SearchScreenState extends State<SearchScreen> {
  bool showSpinner = false;

  void _getSearchData(
      String url, String ext, Map<String, dynamic> params) async {
    var uri = Uri.https(url, ext, params);
    final response = await http.get(uri);
    dom.Document document = parser.parse(response.body);
    final elements = document.getElementsByClassName('tab-thumb c-image-hover');
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

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      color: Colors.blueGrey,
      inAsyncCall: showSpinner,
      child: Container(
        color: Colors.black38.withOpacity(1),
        child: Container(
          height: 200,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.white),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                  cursorHeight: 20,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    setState(() {
                      searchData = value;
                    });
                  },
                ),
              ),
              Flexible(
                child: SizedBox(
                  height: 100,
                ),
              ),
              Flexible(
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.teal,
                  child: TextButton(
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      print(searchData);
                      await _getSearchData('boxnovel.com', "/",
                          {"s": "$searchData", "post_type": "wp-manga"});
                      setState(() {
                        showSpinner = false;
                      });
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SearchResultList(
                          title: title,
                          imgLink: imgLink,
                          link: link,
                        );
                      }));
                    },
                    child: Container(
                      width: 200,
                      child: Text(
                        'Search',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
