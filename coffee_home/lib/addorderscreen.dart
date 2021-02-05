import 'package:coffee_home/user.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'coffee.dart';

class AddOrderScreen extends StatefulWidget {
  final Coffee coffee;
  final User user;

  const AddOrderScreen({Key key, this.coffee, this.user}) : super(key: key);
  @override
  _AddOrderScreenState createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  double screenWidth, screenHeight;
  final TextEditingController _remarkscontroller = TextEditingController();
  int selectedQuantity;
  String _remarks = "";

  @override
  Widget build(BuildContext context) {
    var quantity =
        Iterable<int>.generate(int.parse(widget.coffee.quantity) + 1).toList();
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
                          height: screenHeight / 3.5,
                          width: screenWidth / 1.5,
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
                      Row(
                        children: [
                          Icon(Icons.confirmation_number),
                          SizedBox(width: 20),
                          Container(
                            height: 50,
                            child: DropdownButton(
                              hint: Text(
                                'Quantity',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown[900]),
                              ),
                              value: selectedQuantity,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedQuantity = newValue;
                                  print(selectedQuantity);
                                });
                              },
                              items: quantity.map((selectedQuantity) {
                                return DropdownMenuItem(
                                  child: new Text(selectedQuantity.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.brown[900])),
                                  value: selectedQuantity,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      TextField(
                          controller: _remarkscontroller,
                          keyboardType: TextInputType.name,
                          maxLines: 3,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[900]),
                          decoration: InputDecoration(
                              labelText: 'Your Remark',
                              icon: Icon(Icons.notes))),
                      SizedBox(height: 20),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 300,
                        height: 50,
                        child: Text('Add to Cart',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        color: Colors.brown[900],
                        textColor: Colors.white,
                        elevation: 15,
                        onPressed: _onOrderDialog,
                      ),
                    ],
                  ),
                ))));
  }

  void _onOrderDialog() {
    _remarks = _remarkscontroller.text;
    if (_remarks == "") {
      Toast.show(
        "Fill your remark",
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
            "Order " + widget.coffee.name + "?",
            style: TextStyle(
              color: Colors.indigo[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Quantity: " + selectedQuantity.toString() + "?",
            style: TextStyle(
              color: Colors.brown[900],
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes, Order",
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _orderCoffee();
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

  void _orderCoffee() {
    http.post("http://doubleksc.com/coffee_home/php/add_order.php", body: {
      "email": widget.user.email,
      "id": widget.coffee.id,
      "quantity": selectedQuantity.toString(),
      "remarks": _remarkscontroller.text,
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
