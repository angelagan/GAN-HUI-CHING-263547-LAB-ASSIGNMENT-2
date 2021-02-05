import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'package:intl/intl.dart';

class LoadReviewScreen extends StatefulWidget {
  final User user;

  const LoadReviewScreen({Key key, this.user}) : super(key: key);

  @override
  _LoadReviewScreenState createState() => _LoadReviewScreenState();
}

class _LoadReviewScreenState extends State<LoadReviewScreen> {
  List reviewlist;

  String titlecenter = "Loading Review ...";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadReview();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          title: Text(
            'Review History',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _loadReview();
              },
            ),
          ]),
      body: Column(
        children: [
          reviewlist == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[900]),
                ))))
              : Flexible(
                  child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: (screenWidth / screenHeight) / 0.28,
                  children: List.generate(reviewlist.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(5),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: new BorderSide(
                                    color: Colors.black, width: 2.0)),
                            child: InkWell(
                                // onTap: () => _loadCoffeeDetails(index),
                                child: SingleChildScrollView(
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                  Container(
                                      height: screenHeight / 4.2,
                                      width: screenWidth / 3,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "http://doubleksc.com/coffee_home/images/coffeeimages/${reviewlist[index]['image']}.jpg",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 100.0,
                                          height: 80.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            new CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            new Icon(
                                          Icons.broken_image,
                                          size: screenWidth / 2,
                                        ),
                                      )),
                                  // Text(
                                  //   "ID : " + reviewlist[index]['id'],
                                  //   style: TextStyle(
                                  //       fontSize: 14,
                                  //       fontWeight: FontWeight.bold,
                                  //       color: Colors.black),
                                  // ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Coffee : " +
                                            reviewlist[index]['coffeename'],
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.brown[900]),
                                      ),
                                      // Text(
                                      //   "Email : " + reviewlist[index]['email'],
                                      //   style: TextStyle(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.bold,
                                      //       color: Colors.black),
                                      // ),
                                      Text(
                                        "Name : " + reviewlist[index]['name'],
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.brown[900]),
                                      ),
                                      Text(
                                        "Review : " +
                                            reviewlist[index]['review'],
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.brown[900]),
                                      ),
                                      Text(
                                        "Rating : " +
                                            reviewlist[index]['rating'],
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.brown[900]),
                                      ),
                                      Text(
                                        "Date : " + reviewlist[index]['date'],
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.brown[900]),
                                      ),
                                    ],
                                  )
                                ])))));
                  }),
                ))
        ],
      ),
    ));
  }

  void _loadReview() {
    http.post("http://doubleksc.com/coffee_home/php/load_review.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "no data") {
        reviewlist = null;
        setState(() {
          titlecenter = "No Review Found";
        });
      } else {
        {
          var jsondata = json.decode(res.body);
          reviewlist = jsondata["review"];
        }
      }
    }).catchError((err) {
      print(err);
    });
  }
}
