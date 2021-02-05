import 'dart:convert';
import 'dart:io';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'coffee.dart';
import 'coffeeinfo.dart';
import 'user.dart';

class AddCoffeeInfo extends StatefulWidget {
  final Coffee coffee;
  final CoffeeInfo coffeeinfo;
  final User user;

  const AddCoffeeInfo({Key key, this.coffeeinfo, this.coffee, this.user})
      : super(key: key);
  @override
  _AddCoffeeInfoState createState() => _AddCoffeeInfoState();
}

class _AddCoffeeInfoState extends State<AddCoffeeInfo> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();
  List coffeeinfolist;
  String _title = "";
  String _description = "";
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = 'assets/images/camera.png';

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Coffee Info',
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        )),
                    SizedBox(height: 5),
                    Text("*** Click Here To Upload Image ***",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.brown[900])),
                    SizedBox(height: 5),
                    TextField(
                        controller: _titlecontroller,
                        style: TextStyle(
                          fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[900]),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: 'Title',
                            icon: Icon(Icons.comment_bank))),
                    TextField(
                        controller: _descriptioncontroller,
                        style: TextStyle(
                          fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[900]),
                        keyboardType: TextInputType.name,
                        maxLines: 3,
                        decoration: InputDecoration(
                            labelText: 'Description',
                            icon: Icon(Icons.wysiwyg_rounded))),
                    SizedBox(height: 15),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 200,
                      height: 50,
                      child: Text('Add Coffee Info',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          )),
                      color: Colors.brown[900],
                      textColor: Colors.white,
                      elevation: 15,
                      onPressed: newCoffeeInfoDialog,
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
                        color: Colors.indigo[800],
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

  void newCoffeeInfoDialog() {
    _title = _titlecontroller.text;
    _description = _descriptioncontroller.text;
    if (_title == "" && _description == "") {
      Toast.show(
        "Fill All Required Fields !!!",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Share Coffee Info ?",
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
                "Yes, Share",
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _onAddCoffeeInfo();
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

  void _onAddCoffeeInfo() {
    _title = _titlecontroller.text;
    _description = _descriptioncontroller.text;
    String base64Image = base64Encode(_image.readAsBytesSync());

    http.post("http://doubleksc.com/coffee_home/php/add_coffeeinfo.php", body: {
      "email": widget.user.email,
      "username": widget.user.name,
      "title": _title,
      "description": _description,
      "encoded_string": base64Image,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        Navigator.pop(context);
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      }
    }).catchError((err) {
      print(err);
    });
  }
}
