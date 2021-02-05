import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:like_button/like_button.dart';
// import 'package:toast/toast.dart';
import 'addcoffeeinfo.dart';
import 'coffeeinfo.dart';
import 'coffeeinfodetail.dart';
import 'user.dart';

class LoadCoffeeInfo extends StatefulWidget {
  final User user;

  const LoadCoffeeInfo({Key key, this.user}) : super(key: key);
  @override
  _LoadCoffeeInfoState createState() => _LoadCoffeeInfoState();
}

class _LoadCoffeeInfoState extends State<LoadCoffeeInfo> {
  bool liked = false;
  List coffeeinfolist;
  double screenWidth, screenHeight;
  String titlecenter = "Loading Coffee Info...";
  @override
  void initState() {
    super.initState();
    _loadCoffeeInfo();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Coffee Info',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                _addCoffeeInfo();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _loadCoffeeInfo();
              },
            ),
          ]),
      body: Column(
        children: [
          coffeeinfolist == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[900]),
                ))))
              : Flexible(
                  child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: (screenWidth / screenHeight) / 0.43,
                  children: List.generate(coffeeinfolist.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                          shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: new BorderSide(
                                    color: Colors.black, width: 2.0)),
                            child: InkWell(
                                // onTap: () => _loadCoffeeInfoDetail(index),
                                child: SingleChildScrollView(
                                    child: Column(children: [
                          Container(
                              height: screenHeight / 4.7,
                              width: screenWidth / 2,
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://doubleksc.com/coffee_home/images/coffeeimages/${coffeeinfolist[index]['image']}.jpg",
                                fit: BoxFit.fill,
                                placeholder: (context, url) =>
                                    new CircularProgressIndicator(),
                                errorWidget: (context, url, error) => new Icon(
                                  Icons.broken_image,
                                  size: screenWidth / 2,
                                ),
                              )),
                          Text(
                            "Posted By : " + coffeeinfolist[index]['username'],
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[700]),
                          ),
                          Text(
                            "Title : " + coffeeinfolist[index]['title'],
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[700]),
                          ),
                          Text(
                            "Post Date : " + coffeeinfolist[index]['date'],
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[700]),
                          ),
                          Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(75, 0, 0, 0)),
                              LikeButton(
                                size: 25,
                                likeCount: 0,
                                likeBuilder: (bool like) {
                                  return Icon(Icons.favorite,
                                      color: like ? Colors.red : Colors.grey,
                                      size: 25);
                                },
                              ),
                              SizedBox(width: 30),
                              IconButton(
                                  iconSize: 25,
                                  icon: Icon(
                                    Icons.comment,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    _loadCoffeeInfoDetail(index);
                                  }),
                              SizedBox(width: 20),
                              IconButton(
                                  iconSize: 25,
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    _deleteCoffeeInfo(index);
                                  })
                            ],
                          )
                        ])))));
                  }),
                ))
        ],
      ),
    );
  }

  void _loadCoffeeInfo() {
    http.post("https://doubleksc.com/coffee_home/php/load_coffeeinfo.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "no data") {
        coffeeinfolist = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          coffeeinfolist = jsondata["coffeeinfo"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadCoffeeInfoDetail(int index) {
    CoffeeInfo coffeeInfo = new CoffeeInfo(
        coffeeinfoid: coffeeinfolist[index]['coffeeinfoid'],
        email: coffeeinfolist[index]['email'],
        username: coffeeinfolist[index]['username'],
        image: coffeeinfolist[index]['image'],
        title: coffeeinfolist[index]['title'],
        description: coffeeinfolist[index]['description']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                CoffeeInfoDetail(coffeeInfo, widget.user)));
  }

  void _addCoffeeInfo() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                AddCoffeeInfo(user: widget.user)));
  }

  _deleteCoffeeInfo(int index) {
    print("Delete " + coffeeinfolist[index]['title']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Delete " + coffeeinfolist[index]['title'] + " ?",
            style: TextStyle(
              color: Colors.brown[900],
              fontWeight: FontWeight.bold,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are You Sure ?",
            style: TextStyle(
              color: Colors.indigo[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Yes, Delete",
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _delete(index);
              },
            ),
            new FlatButton(
              child: new Text(
                "No, Cancel",
                style: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _delete(int index) {
    http.post("http://doubleksc.com/coffee_home/php/delete_coffeeinfo.php",
        body: {
          "email": widget.user.email,
          "title": coffeeinfolist[index]['title'],
        }).then((res) {
      print(res.body);
      if (res.body == "success") {
        // Toast.show(
        //   "Delete Success",
        //   context,
        //   duration: Toast.LENGTH_LONG,
        //   gravity: Toast.TOP,
        // );
        _loadCoffeeInfo();
      } else {
        // Toast.show(
        //   "Delete Failed",
        //   context,
        //   duration: Toast.LENGTH_LONG,
        //   gravity: Toast.TOP,
        // );
      }
    }).catchError((err) {
      print(err);
    });
  }
}
