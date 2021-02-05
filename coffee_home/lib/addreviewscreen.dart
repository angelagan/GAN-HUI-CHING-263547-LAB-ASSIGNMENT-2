import 'package:coffee_home/user.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'coffee.dart';

class AddReviewScreen extends StatefulWidget {
  final Coffee coffee;
  final User user;

  const AddReviewScreen({Key key, this.coffee, this.user, review})
      : super(key: key);
  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  double screenWidth, screenHeight;
  final TextEditingController _reviewcontroller = TextEditingController();
  final TextEditingController _ratingcontroller = TextEditingController();
  String _rating = "";
  String _review = "";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.coffee.name,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Container(
            child: Padding(
                padding: EdgeInsets.all(40.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          height: screenHeight / 4,
                          width: screenWidth / 2,
                          child: CachedNetworkImage(
                            imageUrl:
                                "http://doubleksc.com/coffee_home/images/coffeeimages/${widget.coffee.image}.jpg",
                            fit: BoxFit.fill,
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) => new Icon(
                              Icons.broken_image,
                              size: screenWidth / 2,
                            ),
                          )),
                      SizedBox(height: 20),
                      Text("*** Please Fill Review and Rating ***",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              color: Colors.brown[900])),
                      TextField(
                          controller: _reviewcontroller,
                          keyboardType: TextInputType.name,
                          maxLines: 3,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[900]),
                          decoration: InputDecoration(
                              labelText: 'Your Review:',
                              icon: Icon(Icons.comment))),
                      TextField(
                          controller: _ratingcontroller,
                          keyboardType: TextInputType.name,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[900]),
                          decoration: InputDecoration(
                              labelText: 'Your Rating:',
                              icon: Icon(Icons.star))),
                      SizedBox(height: 20),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 300,
                        height: 50,
                        child: Text('Add Review',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        color: Colors.brown[900],
                        textColor: Colors.white,
                        elevation: 15,
                        onPressed: _onReviewDialog,
                      ),
                    ],
                  ),
                ))));
  }

  void _onReviewDialog() {
    _review = _reviewcontroller.text;
    _rating = _ratingcontroller.text;
    if (_review == "" && _rating == "") {
      Toast.show(
        "Please Fill Your Review & Rating",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Finish Write " + widget.coffee.name + " Review ?",
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
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes, Finish",
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _addReview();
              },
            ),
            new FlatButton(
              child: new Text(
                "No, Return",
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

  void _addReview() {
    http.post("http://doubleksc.com/coffee_home/php/add_review.php", body: {
      "image": widget.coffee.image,
      "id": widget.coffee.id,
      "coffeename": widget.coffee.name,
      "email": widget.user.email,
      "name": widget.user.name,
      "review": _reviewcontroller.text,
      "rating": _ratingcontroller.text,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        Navigator.pop(context);
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
