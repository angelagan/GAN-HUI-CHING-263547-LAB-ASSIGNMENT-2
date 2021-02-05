import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';
import 'addcoffeescreen.dart';
import 'addorderscreen.dart';
import 'addreviewscreen.dart';
import 'cartscreen.dart';
import 'coffee.dart';
import 'loadcoffeeinfo.dart';
import 'loadreviewscreen.dart';
// import 'review.dart';
import 'loginscreen.dart';
import 'user.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double screenWidth, screenHeight;
  List coffeeList;
  List reviewList;
  String titlecenter = "Loading Coffee...";

  @override
  void initState() {
    super.initState();
    _loadCoffee();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Main Screen',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              _addCoffeeScreen();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              _loadCoffee();
            },
          ),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text("Name : " + widget.user.name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            accountEmail: new Text("Email : " + widget.user.email,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: new Text(
                widget.user.name.toString().substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 40.0, color: Colors.indigo[700]),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.indigo[700],
            ),
            title: Text('Shopping Cart ',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.brown[900],
                    fontWeight: FontWeight.bold)),
            onTap: () {
              _cartScreen();
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Icon(
              Icons.star_outline_outlined,
              color: Colors.indigo[700],
            ),
            title: Text('Review Center ',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.brown[900],
                    fontWeight: FontWeight.bold)),
            onTap: () {
              _loadReviewScreen();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline_rounded,
              color: Colors.indigo[700],
            ),
            title: Text('Coffee Info ',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.brown[900],
                    fontWeight: FontWeight.bold)),
            onTap: () {
              _loadCoffeeInfo();
            },
          ),
          Expanded(child: SizedBox(height: 100)),
          Divider(),
          Container(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                leading: Icon(
                  Icons.power_settings_new,
                  color: Colors.indigo[700],
                ),
                title: Text('Sign Out',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.brown[900],
                        fontWeight: FontWeight.bold)),
                onTap: () {
                  _signoutDialog();
                  // Update the state of the app.
                  // ...
                },
              ),
            ),
          ),
        ]),
      ),
      body: Column(
        children: [
          coffeeList == null
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
                  crossAxisCount: 2,
                  childAspectRatio: (screenWidth / screenHeight) / 1,
                  children: List.generate(coffeeList.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: new BorderSide(
                                    color: Colors.black, width: 2.0)),
                            child: InkWell(
                                // onTap: () => _addOrderScreen(index),
                                onLongPress: () => _deleteCoffeeScreen(index),
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: [
                                    Container(
                                        height: screenHeight / 4.2,
                                        width: screenWidth / 2,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "http://doubleksc.com/coffee_home/images/coffeeimages/${coffeeList[index]['image']}.jpg",
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: 80.0,
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
                                    Positioned(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(coffeeList[index]['rating'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.brown[900])),
                                          Icon(Icons.star,
                                              color: Colors.brown[900]),
                                        ],
                                      ),
                                      bottom: 20,
                                      right: 10,
                                    ),
                                    Text(
                                      coffeeList[index]['name'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.brown[900]),
                                    ),
                                    Text(
                                      "RM: " + coffeeList[index]['price'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.brown[900]),
                                    ),
                                    Text(
                                      "Quantity: " +
                                          coffeeList[index]['quantity'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.brown[900]),
                                    ),
                                    Container(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color: Colors.brown[900])),
                                            color: Colors.white,
                                            onPressed: () {
                                              _addReviewScreen(index);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(1),
                                              child: Text(
                                                "Add Review",
                                                style: TextStyle(
                                                  color: Colors.brown[900],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.add_shopping_cart,
                                              color: Colors.brown[900],
                                            ),
                                            onPressed: () {
                                              _addOrderScreen(index);
                                            },
                                          )
                                        ]))
                                  ],
                                )))));
                  }),
                ))
        ],
      ),
    );
  }

  void _loadCoffee() {
    http.post("http://doubleksc.com/coffee_home/php/load_coffee.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "no data") {
        coffeeList = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          coffeeList = jsondata["coffee"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _addOrderScreen(int index) {
    print(coffeeList[index]['name']);
    print('RM:' + coffeeList[index]['price']);
    print('QUANTITY: ' + coffeeList[index]['quantity']);
    Coffee coffee = new Coffee(
        image: coffeeList[index]['image'],
        id: coffeeList[index]['id'],
        name: coffeeList[index]['name'],
        price: coffeeList[index]['price'],
        quantity: coffeeList[index]['quantity'],
        rating: coffeeList[index]['rating']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                AddOrderScreen(coffee: coffee, user: widget.user)));
  }

  void _cartScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CartScreen(user: widget.user)));
  }

  void _addCoffeeScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                AddCoffeeScreen(user: widget.user)));
  }

  _loadReviewScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                LoadReviewScreen(user: widget.user)));
  }

  _addReviewScreen(int index) {
    print(coffeeList[index]['name']);
    Coffee coffee = new Coffee(
        image: coffeeList[index]['image'],
        id: coffeeList[index]['id'],
        name: coffeeList[index]['name']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                AddReviewScreen(coffee: coffee, user: widget.user)));
  }

  _deleteCoffeeScreen(int index) {
    print("Delete " + coffeeList[index]['name']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete " + coffeeList[index]['name'] + "?",
            style: TextStyle(
              color: Colors.indigo[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are You Sure?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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
                _deleteCoffee(index);
              },
            ),
            new FlatButton(
              child: new Text(
                "No, Cancel",
                style: TextStyle(
                  color: Colors.red[900],
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

  void _deleteCoffee(int index) {
    http.post("http://doubleksc.com/coffee_home/php/delete_coffee.php", body: {
      "email": widget.user.email,
      "id": coffeeList[index]['id'],
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Delete Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        _loadCoffee();
      } else {
        Toast.show(
          "Delete Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadCoffeeInfo() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                LoadCoffeeInfo(user: widget.user)));
  }

  void _signoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Sign Out Account ?",
            style: TextStyle(
              color: Colors.indigo[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are You Sure ?",
            style: TextStyle(
              color: Colors.brown[900],
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Yes, Sign Out",
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _log();
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

  void _log() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }
}
