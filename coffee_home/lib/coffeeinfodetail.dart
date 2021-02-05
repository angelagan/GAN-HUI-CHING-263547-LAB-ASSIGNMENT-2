import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'coffeeinfo.dart';
import 'user.dart';

class CoffeeInfoDetail extends StatefulWidget {
  final CoffeeInfo coffeeInfo;
  final User user;

  CoffeeInfoDetail(this.coffeeInfo, this.user);

  @override
  _CoffeeInfoDetailState createState() =>
      _CoffeeInfoDetailState(coffeeInfo, user);
}

class _CoffeeInfoDetailState extends State<CoffeeInfoDetail> {
  CoffeeInfo coffeeInfo;
  User user;
  _CoffeeInfoDetailState(CoffeeInfo coffeeInfo, User user);
  List commentList;
  List coffeeInfoList;
  double screenHeight, screenWidth;
  final TextEditingController _commentcontroller = TextEditingController();
  String titlecenter = "Loading Coffee Info ...";
  String _comment = "";

  @override
  void initState() {
    super.initState();
    coffeeInfo = widget.coffeeInfo;
    user = widget.user;
    _loadCoffeeInfoDetails();
    _loadComment();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            title: Text(widget.coffeeInfo.title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  _loadComment();
                },
              )
            ]),
        body: Column(children: [
          Container(
              padding: EdgeInsets.all(3),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Container(
                      child: Column(
                    children: [
                      Container(
                          child: Column(children: [
                        Container(
                            height: 200,
                            width: 400,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://doubleksc.com/coffee_home/images/coffeeimages/${widget.coffeeInfo.image}.jpg",
                              fit: BoxFit.fill,
                              placeholder: (context, url) =>
                                  new CircularProgressIndicator(),
                              errorWidget: (context, url, error) => new Icon(
                                Icons.broken_image,
                                size: screenWidth / 2,
                              ),
                            )),
                        SizedBox(height: 5),
                        // Container(
                        //     child: SingleChildScrollView(
                        Row(children: [
                          Text("Title : " + widget.coffeeInfo.title,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown[900])),
                        ]),
                        Column(children: <Widget>[
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                    "Description : " +
                                        widget.coffeeInfo.description,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown[900])),
                                // Row(children: [
                                //   Text((DateFormat('yyyy-MM-dd hh:mm aaa').format(postList[index]['postdate'])),
                              ))
                        ]),
                      ]))
                    ],
                  )),
                ],
              ))),
          Expanded(
            child: SingleChildScrollView(
              child: commentList == null
                  ? Container(
                      child: Container(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text("No Comment"),
                          )))
                  : Container(
                      child: Container(
                          padding: EdgeInsets.all(20),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: commentList.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                // print(commentList.length);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(commentList[index]['username'],
                                            style: TextStyle(
                                                color: Colors.indigo[800],
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        Text(" [ " +
                                            commentList[index]['date'] +
                                            " ]"),
                                      ],
                                    ),
                                    Text(commentList[index]['comment'],
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                );
                              }))),
            ),
          ),
          TextField(
              controller: _commentcontroller,
              decoration: InputDecoration(
                  labelText: "Comment",
                  icon: Icon(Icons.comment),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _addComment();
                    },
                    icon: Icon(Icons.send),
                  ))),
        ]));
  }

  void _loadCoffeeInfoDetails() {
    print("Load Coffee Info");
    http.post("https://doubleksc.com/coffee_home/php/load_coffeeinfo.php",
        body: {
          widget.coffeeInfo.title,
        }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        coffeeInfoList = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body); //decode json data

          coffeeInfoList = jsondata["coffeeinfo"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadComment() {
    // print("Load " + widget.coffeeInfo.coffeeinfoid + "'s Data");
    http.post("http://doubleksc.com/coffee_home/php/load_comment.php", body: {
      "title": widget
          .coffeeInfo.title, //send the postid to load_comments.php to get data
    }).then((res) {
      print(res.body);

      if (res.body == "nodata") {
        print("commentList is null");
        commentList = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body); //decode json data

          commentList = jsondata["comment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _addComment() {
    final dateTime = DateTime.now();
    _comment = _commentcontroller.text;

    http.post("http://doubleksc.com/coffee_home/php/add_comment.php", body: {
      "title": widget.coffeeInfo.title,
      "comment": _comment,
      "email": widget.user.email,
      "username": widget.user.name,
      "date": "-${dateTime.microsecondsSinceEpoch}",
    }).then((res) {
      print(res.body);

      if (res.body == "success") {
        Toast.show(
          "Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        // Navigator.pop(context);
      } else {
        Toast.show(
          "Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }
}
