import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:toast/toast.dart';
import 'coffee.dart';
import 'user.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddCoffeeScreen extends StatefulWidget {
  final Coffee coffee;
  final User user;

  const AddCoffeeScreen({Key key, this.coffee, this.user}) : super(key: key);
  @override
  _AddCoffeeScreenState createState() => _AddCoffeeScreenState();
}

class _AddCoffeeScreenState extends State<AddCoffeeScreen> {
  double screenHeight, screenWidth;
  File _image;
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _pricecontroller = TextEditingController();
  final TextEditingController _quantitycontroller = TextEditingController();
  final TextEditingController _ratingcontroller = TextEditingController();
  String coffeetype = "Coffee";
  String _name = "";
  String pathAsset = 'assets/images/camera.png';
  String _price = "";
  String _quantity = "";
  String _rating = "";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sell Coffee',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: () => {_onPictureSelection()},
                        child: Container(
                          height: screenHeight / 3.2,
                          width: screenWidth / 1.8,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: _image == null
                                  ? AssetImage(pathAsset)
                                  : FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              width: 3.0,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(
                                    5.0) //         <--- border radius here
                                ),
                          ),
                        )),
                    SizedBox(height: 5),
                    Text("*** Click Image To Take Coffee Picture ***",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.brown[900])),
                    SizedBox(height: 5),
                    TextField(
                        controller: _namecontroller,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[900]),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: 'Name',
                            icon: Icon(Icons.emoji_food_beverage))),
                    TextField(
                        controller: _pricecontroller,
                        style: TextStyle(
                          fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[900]),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Price', icon: Icon(Icons.money))),
                    TextField(
                        controller: _quantitycontroller,
                        style: TextStyle(
                          fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[900]),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Quantity',
                            icon: Icon(Icons.confirmation_number_outlined))),
                    TextField(
                        controller: _ratingcontroller,
                        style: TextStyle(
                          fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[900]),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Rating',
                            icon: Icon(Icons.star_border_outlined))),
                    SizedBox(height: 15),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 200,
                      height: 50,
                      child: Text('Add New Coffee',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          )),
                      color: Colors.brown[900],
                      textColor: Colors.white,
                      elevation: 15,
                      onPressed: newCoffeeDialog,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ))),
    );
  }

  _onPictureSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            //backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              //color: Colors.white,
              height: screenHeight / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Take Picture From :",
                        style: TextStyle(
                            color: Colors.brown[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Camera',
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            )),
                        //color: Color.fromRGBO(101, 255, 218, 50),
                        color: Colors.indigo[800],
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseCamera()},
                      )),
                      SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Gallery',
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            )),
                        //color: Color.fromRGBO(101, 255, 218, 50),
                        color: Colors.indigo[800],
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () => {
                          Navigator.pop(context),
                          _chooseGallery(),
                        },
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  void _chooseCamera() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  void _chooseGallery() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Resize',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void newCoffeeDialog() {
    _name = _namecontroller.text;
    _price = _pricecontroller.text;
    _quantity = _quantitycontroller.text;
    _rating = _ratingcontroller.text;
    if (_name == "" && _price == "" && _quantity == "" && _rating == "") {
      Toast.show(
        "Fill All Required Fields !!!",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
        // backgroundColor: Colors.brown,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          // backgroundColor: Colors.yellow,
          title: new Text(
            "Sell Coffee ? ",
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
                "Yes, Sell",
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _onAddCoffee();
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

  void _onAddCoffee() {
    // final dateTime = DateTime.now();
    _name = _namecontroller.text;
    _price = _pricecontroller.text;
    _quantity = _quantitycontroller.text;
    _rating = _ratingcontroller.text;
    String base64Image = base64Encode(_image.readAsBytesSync());

    http.post("http://doubleksc.com/coffee_home/php/add_coffee.php", body: {
      "email": widget.user.email,
      "name": _name,
      "price": _price,
      "quantity": _quantity,
      "encoded_string": base64Image,
      "rating": _rating,
      // "image":_image,
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
