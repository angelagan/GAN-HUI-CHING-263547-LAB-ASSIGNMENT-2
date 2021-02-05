import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coffee_home/loginscreen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _passwordVisible = false;
  bool _rememberMe = false;
  bool _termCondition = false;
  double screenHeight, screenWidth;
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emcontroller = TextEditingController();
  final TextEditingController _pscontroller = TextEditingController();
  final TextEditingController _phcontroller = TextEditingController();
  String _email = "";
  String _password = "";
  String _name = "";
  String _phone = "";

  // bool _autoValidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.brown),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Registration'),
        ),
        body: new SingleChildScrollView(
          child: new Container(
            margin: new EdgeInsets.all(15.0),
            child: new Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: registration(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget registration(BuildContext context) {
    return new Container(
      child: Padding(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/coffee_home.png',
                  scale: 1,
                ),
                Container(
                    child: TextFormField(
                  controller: _namecontroller,
                  validator: validateName,
                  onSaved: (String val1) {
                    _name = val1;
                  },
                  decoration: InputDecoration(
                      labelText: 'Name', icon: Icon(Icons.person)),
                  keyboardType: TextInputType.name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[900]),
                )),
                Container(
                    child: TextFormField(
                  controller: _emcontroller,
                  validator: validateEmail,
                  onSaved: (String val2) {
                    _email = val2;
                  },
                  decoration: InputDecoration(
                      labelText: 'Email', icon: Icon(Icons.email)),
                  keyboardType: TextInputType.name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[900]),
                )),
                Container(
                    child: TextFormField(
                  controller: _phcontroller,
                  validator: validatePhone,
                  onSaved: (String val3) {
                    _phone = val3;
                  },
                  decoration: InputDecoration(
                      labelText: 'Mobile', icon: Icon(Icons.phone)),
                  keyboardType: TextInputType.name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[900]),
                )),
                Container(
                    child: TextFormField(
                  controller: _pscontroller,
                  validator: validatePassword,
                  onSaved: (String val4) {
                    _password = val4;
                  },
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[900]),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: _passwordVisible,
                )),
                SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool value) {
                        _onChange(value);
                      },
                    ),
                    Text('Remember Me',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[900]))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _termCondition,
                      onChanged: (bool value) {
                        _onChange1(value);
                      },
                    ),
                    GestureDetector(
                        onTap: _showEULA,
                        child: Text('Term & Condition',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[900]))),
                  ],
                ),
                SizedBox(height: 10),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 300,
                  height: 50,
                  child: Text('Register',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                  color: Colors.brown[900],
                  textColor: Colors.white,
                  elevation: 15,
                  onPressed: _newRegister,
                ),
                SizedBox(height: 10),
                GestureDetector(
                    onTap: _onLogin,
                    child: Text('Already Register',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo[700]))),
              ],
            ),
          )),
    );
  }

  void _onRegister() async {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _pscontroller.text;
    _phone = _phcontroller.text;
    // if (validateEmail(_email) && validatePassword(_password)) {
    //    Toast.show(
    //       "Check your email/password",
    //       context,
    //       duration: Toast.LENGTH_LONG,
    //       gravity: Toast.TOP,
    //     );
    //   return;
    // }
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Registration...");
    await pr.show();
    http.post("http://doubleksc.com/coffee_home/php/PHPMailer/index.php", body: {
      "name": _name,
      "email": _email,
      "password": _password,
      "phone": _phone,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Registration Success. An email has been sent to .$_email. Please check your email for OTP verification. Also check in your spam folder.",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        if (_rememberMe) {
          savepref();
        }
        _onLogin();
      } else {
        Toast.show(
          "Registration Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  void _onLogin() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _rememberMe = value;
    });
  }

  void _onChange1(bool value) {
    setState(() {
      _termCondition = value;
    });
  }

  void savepref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = _emcontroller.text;
    _password = _pscontroller.text;
    await prefs.setString('Email', _email);
    await prefs.setString('Password', _password);
    await prefs.setBool('RememberMe', true);
  }

  // bool validateEmail(String value) {
  //   Pattern pattern =
  //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  //   RegExp regex = new RegExp(pattern);
  //   return (!regex.hasMatch(value)) ? false : true;
  // }

  // bool validatePassword(String value){
  //       String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  //       RegExp regExp = new RegExp(pattern);
  //       return regExp.hasMatch(value);
  // }

  void _newRegister() {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _pscontroller.text;
    _phone = _phcontroller.text;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    } else {
      // setState(() {
      //   _autoValidate = true;
      // });
    }
    // if (validateEmail(_email) && validatePassword(_password)) {
    //   Toast.show(
    //     "Check your email/password",
    //     context,
    //     duration: Toast.LENGTH_LONG,
    //     gravity: Toast.TOP,
    //   );
    //   return;
    // }

    if (!_termCondition) {
      Toast.show(
        "Please click Term & Condition",
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
            "Register New Account? ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.indigo[800],
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are You Sure?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.brown[900],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes, Register",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _onRegister();
              },
            ),
            new FlatButton(
              child: new Text(
                "No, Cancel",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
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

  void _showEULA() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("End-User License Agreement (EULA) of Coffee Home",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo[800])),
          content: new Container(
            height: 500,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.0,
                          ),
                          text:
                              "This End-User License Agreement is a legal agreement between you and Doubleksc. This EULA agreement governs your acquisition and use of our Coffee Home software (Software) directly from Doubleksc or indirectly through a Doubleksc authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the Coffee Home software. It provides a license to use the Coffee Home software and contains warranty information and liability disclaimers. If you register for a free trial of the Coffee Home software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the Coffee Home software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by Doubleksc herewith regardless of whether other software is referred to or described herein. The terms also apply to any Doubleksc updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for Coffee Home. Doubleksc shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of Doubleksc. Doubleksc reserves the right to grant licences to use the Software to third parties",
                        )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[800],
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  String validateName(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Name is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be word";
    }
    return null;
  }

  String validatePhone(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Phone Number is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Phone Number must be digits";
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return "Password is Required";
    }
    return null;
  }
}
