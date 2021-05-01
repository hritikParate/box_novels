import 'package:flutter/material.dart';

class ListViewNovel extends StatelessWidget {
  List<String> title;
  List<String> link;
  List<String> imgLink;
  Function onTap;
  ListViewNovel({this.onTap, this.link, this.imgLink, this.title});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: title.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 13),
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.black38,
            ),
            child: ListTile(
              onTap: onTap,
              title: Text(
                title[index],
                style: TextStyle(color: Colors.white),
              ),
              leading: CircleAvatar(
                foregroundImage: NetworkImage(imgLink[index]),
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  backgroundImage: NetworkImage(imgLink[index] ??
                      "https://img.icons8.com/plasticine/2x/no-image.png"),
                  radius: 68.0,
                ),
              ),
            ),
          );
        });
  }
}
