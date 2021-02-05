import 'dart:async';
import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'addorderscreen.dart';
import 'billscreen.dart';
import 'coffee.dart';
import 'user.dart';

class CartScreen extends StatefulWidget {
  final User user;

  const CartScreen({Key key, this.user}) : super(key: key);
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _visible = false;
  bool _stdeli = false;
  bool _stpickup = true;
  CameraPosition _home;
  CameraPosition _userpos;
  Completer<GoogleMapController> _controller = Completer();
  double delcharge = 0.0;
  double latitude, longitude;
  double payable = 0.0;
  double restdel = 0.0;
  double screenWidth, screenHeight;
  double sizing = 11.5;
  double totalPrice = 0.0;
  final formatter = new NumberFormat("#,##");
  GoogleMapController gmcontroller;
  int numcart = 0;
  int _radioValue = 0;
  List cartList;
  MarkerId markerId1 = MarkerId("12");
  Position _currentPosition;
  Set<Marker> markers = Set();
  String _delivery = "Pickup";
  String _homeloc = "searching...";
  String titlecenter = "No Data Found";
  TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
              height: screenHeight / 9,
              width: screenWidth / 0.3,
              child: Card(
                child: SingleChildScrollView(
                    child: Column(children: [
                  Text(
                    widget.user.name +
                        ", there are " +
                        numcart.toString() +
                        " item/s in your cart.",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[900]),
                  ),
                  Text(
                    "Total amount is RM " + totalPrice.toStringAsFixed(2) + ".",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[900]),
                  ),
                ])),
              )),
          cartList == null
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
                  childAspectRatio: (screenWidth / screenHeight) / 0.25,
                  children: List.generate(cartList.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: new BorderSide(
                                    color: Colors.black, width: 2.0)),
                            child: InkWell(
                                onTap: () => _loadCoffeeDetail(index),
                                // onLongPress: () => _deleteOrderDialog(index),
                                child: SingleChildScrollView(
                                    // child: Row(
                                    //  crossAxisAlignment: CrossAxisAlignment.start,
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                      Container(
                                          height: 120,
                                          width: 120,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "http://doubleksc.com/coffee_home/images/coffeeimages/${cartList[index]['image']}.jpg",
                                            fit: BoxFit.fill,
                                            placeholder: (context, url) =>
                                                new CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(
                                              Icons.broken_image,
                                              size: screenWidth / 2,
                                            ),
                                          )),
                                      SizedBox(width: 5),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Coffee : "+cartList[index]['name'],
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.indigo[800]),
                                          ),
                                          Text(
                                            "Each Cup : RM " + cartList[index]['price'],
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.brown[900]),
                                          ),
                                          Text(
                                            "Quantity: " +
                                                cartList[index]['quantity'],
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.brown[900]),
                                          ),
                                          Text(
                                            "Total Price: RM " +
                                                (double.parse(cartList[index]
                                                            ['price']) *
                                                        int.parse(
                                                            cartList[index]
                                                                ["quantity"]))
                                                    .toStringAsFixed(2),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.indigo[800]),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_sharp,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          _deleteOrderDialog(index);
                                        },
                                      ),
                                    ])))));
                  }),
                )),
          Container(
              decoration: new BoxDecoration(
                color: Colors.indigo[700],
              ),
              height: screenHeight / sizing,
              width: screenWidth / 0.4,
              child: Card(
                  elevation: 15,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: IconButton(
                            icon: _visible
                                ? new Icon(Icons.expand_more)
                                : new Icon(Icons.attach_money),
                            onPressed: () {
                              setState(() {
                                if (_visible) {
                                  _visible = false;
                                  sizing = 11.5;
                                } else {
                                  _visible = true;
                                  sizing = 1.42;
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "TOTAL ITEM/S",
                          style: TextStyle(
                            color: Colors.indigo[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                            widget.user.name +
                                ", there are " +
                                numcart.toString() +
                                " item/s in your cart.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[900])),
                        Text(
                            "Total amount is RM " +
                                totalPrice.toStringAsFixed(2) +
                                ".",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[900])),
                        SizedBox(height: 8),
                        Divider(height: 1, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          "DELIVERY OPTIONS ",
                          style: TextStyle(
                            color: Colors.indigo[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Pickup",
                              style: TextStyle(
                                color: Colors.brown[900],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            new Radio(
                              value: 0,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                            ),
                            Text(
                              "Delivery",
                              style: TextStyle(
                                color: Colors.brown[900],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            new Radio(
                              value: 1,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                            ),
                          ],
                        ),
                        Divider(height: 2, color: Colors.grey),
                        SizedBox(height: 8),
                        Visibility(
                            visible: _stpickup,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "SELF PICKUP",
                                  style: TextStyle(
                                    color: Colors.indigo[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Set pickup time at ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        _timeController.text,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                          width: 20,
                                          child: IconButton(
                                              iconSize: 32,
                                              icon: Icon(Icons.watch),
                                              onPressed: () =>
                                                  {_selectTime(context)})),
                                    ])
                              ],
                            )),
                        SizedBox(height: 5),
                        Visibility(
                            visible: _stdeli,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: screenWidth / 2,
                                    child: Column(
                                      children: [
                                        Text(
                                          "DELIVERY ADDRESS ",
                                          style: TextStyle(
                                            color: Colors.indigo[700],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          _homeloc,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        GestureDetector(
                                          child: Text("Set / Change Location ?",
                                              style: TextStyle(
                                                color: Colors.deepOrange,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          onTap: () => {
                                            _loadMapDialog(),
                                          },
                                        ),
                                        SizedBox(height: 5),
                                      ],
                                    )),
                              ],
                            )),
                        SizedBox(height: 8),
                        Divider(height: 1, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          "PAYMENT ",
                          style: TextStyle(
                            color: Colors.indigo[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                            "Delivery Charge : RM " +
                                delcharge.toStringAsFixed(2),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[900])),
                        Text(
                            "Coffee's Price : RM " +
                                totalPrice.toStringAsFixed(2),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[900])),
                        Text(
                            "Total Amount Payable RM " +
                                payable.toStringAsFixed(2),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[900])),
                        SizedBox(height: 3),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          height: 30,
                          child: Text(
                            'Make Payment',
                            style: TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: Colors.indigo[700],
                          elevation: 10,
                          onPressed: () => {
                            _makePaymentDialog(),
                          },
                        ),
                      ],
                    ),
                  ))),
        ],
      ),
    ));
  }

  void _loadCart() {
    http.post("http://doubleksc.com/coffee_home/php/load_cart.php", body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body == "no data") {
        cartList = null;
        setState(() {
          titlecenter = "No Item Found";
        });
      } else {
        totalPrice = 0;
        numcart = 0;
        setState(() {
          var jsondata = json.decode(res.body);
          cartList = jsondata["cart"];
          for (int i = 0; i < cartList.length; i++) {
            totalPrice = totalPrice +
                double.parse(cartList[i]['price']) *
                    double.parse(cartList[i]['quantity']);
            numcart = numcart + int.parse(cartList[i]['quantity']);
          }
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deleteOrderDialog(int index) {
    print("Delete " + cartList[index]['name']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete Order " + cartList[index]['name'] + "?",
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
                "Yes, Delete",
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _deleteOrder(index);
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

  void _deleteOrder(int index) {
    http.post("http://doubleksc.com/coffee_home/php/delete_order.php", body: {
      "email": widget.user.email,
      "id": cartList[index]['id'],
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Delete Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        _loadCart();
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

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _delivery = "Pickup";
          _stpickup = true;
          _stdeli = false;
          _calculatePayment();
          break;
        case 1:
          _delivery = "Delivery";
          _stpickup = false;
          _stdeli = true;
          _getLocation();
          break;
      }
      print(_delivery);
    });
  }

  Future<Null> _selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
    String _hour, _minute, _time;
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  _loadMapDialog() {
    _controller = null;
    try {
      if (_currentPosition.latitude == null) {
        Toast.show("Current location not available. Please wait...", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _getLocation(); //_getCurrentLocation();
        return;
      }
      _controller = Completer();
      _userpos = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 16,
      );
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newSetState) {
              var alheight = MediaQuery.of(context).size.height;
              var alwidth = MediaQuery.of(context).size.width;
              return AlertDialog(
                  //scrollable: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  title: Center(
                    child: Text("Select New Delivery Location",
                        style: TextStyle(
                          color: Colors.indigo[700],
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  //titlePadding: EdgeInsets.all(5),
                  //content: Text(_homeloc),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          _homeloc,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: alheight - 300,
                          width: alwidth - 10,
                          child: GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: _userpos,
                              markers: markers.toSet(),
                              onMapCreated: (controller) {
                                _controller.complete(controller);
                              },
                              onTap: (newLatLng) {
                                _loadLoc(newLatLng, newSetState);
                              }),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          //minWidth: 200,
                          height: 30,
                          child: Text('Close'),
                          color: Colors.deepOrangeAccent,
                          textColor: Colors.white,
                          elevation: 10,
                          onPressed: () => {
                            markers.clear(),
                            Navigator.of(context).pop(false),
                          },
                        ),
                      ],
                    ),
                  ));
            },
          );
        },
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  void _loadLoc(LatLng loc, newSetState) async {
    newSetState(() {
      print("insetstate");
      markers.clear();
      latitude = loc.latitude;
      longitude = loc.longitude;
      _getLocationfromlatlng(latitude, longitude, newSetState);
      _home = CameraPosition(
        target: loc,
        zoom: 16,
      );
      markers.add(Marker(
        markerId: markerId1,
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(
          title: 'New Location',
          snippet: 'New Delivery Location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ));
    });
    _userpos = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );
    _newhomeLocation();
  }

  Future<void> _newhomeLocation() async {
    gmcontroller = await _controller.future;
    gmcontroller.animateCamera(CameraUpdate.newCameraPosition(_home));
  }

  _getLocationfromlatlng(double lat, double lng, newSetState) async {
    final Geolocator geolocator = Geolocator()
      ..placemarkFromCoordinates(lat, lng);
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //debugPrint('location: ${_currentPosition.latitude}');
    final coordinates = new Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    newSetState(() {
      _homeloc = first.addressLine;
      if (_homeloc != null) {
        latitude = lat;
        longitude = lng;
        _calculatePayment();
        return;
      }
    });
    setState(() {
      _homeloc = first.addressLine;
      if (_homeloc != null) {
        latitude = lat;
        longitude = lng;
        _calculatePayment();
        return;
      }
    });
  }

  Future<void> _getLocation() async {
    try {
      final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) async {
        _currentPosition = position;
        if (_currentPosition != null) {
          final coordinates = new Coordinates(
              _currentPosition.latitude, _currentPosition.longitude);
          var addresses =
              await Geocoder.local.findAddressesFromCoordinates(coordinates);
          setState(() {
            var first = addresses.first;
            _homeloc = first.addressLine;
            if (_homeloc != null) {
              latitude = _currentPosition.latitude;
              longitude = _currentPosition.longitude;
              _calculatePayment();
              return;
            }
          });
        }
      }).catchError((e) {
        print(e);
      });
    } catch (exception) {
      print(exception.toString());
    }
  }

  _makePaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Proceed With Payment ?',
          style: TextStyle(
            color: Colors.indigo[700],
            fontWeight: FontWeight.bold,
          ),
        ),
        content: new Text(
          'Are You Sure To Pay :    '
                  'RM ' +
              payable.toStringAsFixed(2) +
              " ?",
          style: TextStyle(
            color: Colors.brown[900],
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _makePayment();
              },
              child: Text(
                "Yes, Pay",
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "No, Return",
                style: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      ),
    );
  }

  Future<void> _makePayment() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => BillScreen(
                  user: widget.user,
                  val: payable.toStringAsFixed(2),
                )));
    _calculatePayment();
    _loadCart();
  }

  _calculatePayment() {
    setState(() {
      if (_delivery == "Pickup") {
        delcharge = payable * 0;
        payable = totalPrice + delcharge;
      } else {
        delcharge = payable * 0.10;
        payable = totalPrice + delcharge;
      }
    });
  }

  _loadCoffeeDetail(int index) async {
    Coffee coffee = new Coffee(
        image: cartList[index]['image'],
        id: cartList[index]['id'],
        name: cartList[index]['name'],
        price: cartList[index]['price'],
        quantity: cartList[index]['quantity'],
        rating: cartList[index]['rating']);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AddOrderScreen(
                  coffee: coffee,
                  user: widget.user,
                )));
    _loadCart();
  }
}
