import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coffee_home/registerscreen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'mainscreen.dart';
import 'user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool autoValidate = false;
  bool _passwordShow = false;
  bool _rememberMe = false;
  final formKeyForResetEmail = GlobalKey<FormState>();
  final formKeyForResetPassword = GlobalKey<FormState>();
  final TextEditingController _emcontroller = TextEditingController();
  final TextEditingController _pscontroller = TextEditingController();
  SharedPreferences prefs;
  String _email = "";
  String _password = "";
  TextEditingController emailForgotController = new TextEditingController();
  TextEditingController passResetController = new TextEditingController();

  @override
  void initState() {
    loadpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Login',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            //resizeToAvoidBottomPadding: false,
            body: new Container(
              padding: EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/coffee_home.png',
                      scale: 1,
                    ),
                    TextField(
                        controller: _emcontroller,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            fontSize:16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[900]),
                        decoration: InputDecoration(
                            labelText: 'Email', icon: Icon(Icons.email))),
                    TextField(
                      controller: _pscontroller,
                      style: TextStyle(
                          fontSize:16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[900]),
                      decoration: InputDecoration(
                          labelText: 'Password', icon: Icon(Icons.lock)),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 300,
                      height: 50,
                      //child: new Icon(Icons.arrow_right),
                      child: Text('Login',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      color: Colors.brown[900],
                      textColor: Colors.white,
                      elevation: 15,
                      onPressed: _onLogin,
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
                    GestureDetector(
                        onTap: _onRegister,
                        child: Text('Register New Account',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[700]))),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: _forgotPassword,
                        child: Text('Reset Password',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[700]))),
                  ],
                ),
              ),
            )));
  }

  Future<void> _onLogin() async {
    _email = _emcontroller.text;
    _password = _pscontroller.text;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Login...");
    await pr.show();
    http.post("http://doubleksc.com/coffee_home/php/login_user.php", body: {
      "email": _email,
      "password": _password,
    }).then((res) {
      print(res.body);
      List userdata = res.body.split(",");

      if (userdata[0] == "success") {
        Toast.show(
          "Login Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        User user = new User(
            email: _email,
            name: userdata[1],
            password: _password,
            phone: userdata[2],
            datereg: userdata[3]);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(user: user)));
      } else {
        Toast.show(
          "Login Failed",
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

  void _onRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  // void _onForgot() {
  //   print('Forgot');
  // }

  void _onChange(bool value) {
    setState(() {
      _rememberMe = value;
      savepref(value);
    });
  }

  void loadpref() async {
    prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email')) ?? '';
    _password = (prefs.getString('password')) ?? '';
    _rememberMe = (prefs.getBool('rememberme')) ?? false;
    if (_email.isNotEmpty) {
      setState(() {
        _emcontroller.text = _email;
        _pscontroller.text = _password;
        _rememberMe = _rememberMe;
      });
    }
  }

  void savepref(bool value) async {
    prefs = await SharedPreferences.getInstance();
    _email = _emcontroller.text;
    _password = _pscontroller.text;

    if (value) {
      if (_email.length < 5 && _password.length < 3) {
        print("EMAIL/PASSWORD EMPTY");
        _rememberMe = false;
        Toast.show(
          "Email / Password Empty!!!",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        return;
      } else {
        await prefs.setString('email', _email);
        await prefs.setString('password', _password);
        await prefs.setBool('rememberme', value);
        Toast.show(
          "Preferences Saved",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        print("SUCCESS");
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      await prefs.setBool('rememberme', false);
      setState(() {
        _emcontroller.text = "";
        _pscontroller.text = "";
        _rememberMe = false;
      });
      Toast.show(
        "Preferences Removed",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
      );
    }
  }

  Future<bool> _onBackPressAppBar() async {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Exit App',
              style: TextStyle(
                  color: Colors.indigo[800], fontWeight: FontWeight.bold),
            ),
            content: new Text(
              'Do You Want to Exit Coffee Home ?',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Text(
                  "Yes, Exit",
                  style: TextStyle(
                      color: Colors.green[700], fontWeight: FontWeight.bold),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  "No, Cancel",
                  style: TextStyle(
                      color: Colors.red[700], fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _forgotPassword() {
    TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Forgot Password ?",
            style: TextStyle(
                color: Colors.indigo[700], fontWeight: FontWeight.bold),
          ),
          content: new Container(
              height: 100,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Enter Your Email : ",
                        style: TextStyle(
                            color: Colors.brown[900],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Form(
                        key: formKeyForResetEmail,
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email', icon: Icon(Icons.email)),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[900]),
                          validator: emailValidate,
                          onSaved: (String value) {
                            _email = value;
                          },
                        )),
                  ],
                ),
              )),
          actions: <Widget>[
            new FlatButton(
                child: new Text(
                  "Yes, Reset Password",
                  style: TextStyle(
                      color: Colors.green[700], fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (formKeyForResetEmail.currentState.validate()) {
                    _passwordShow = false;
                    emailForgotController.text = emailController.text;
                    _enterResetPass();
                  }
                }),
            new FlatButton(
              child: new Text(
                "No, Return Login",
                style: TextStyle(
                    color: Colors.red[700], fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  String emailValidate(String value) {
    if (value.isEmpty) {
      return 'Email is Required';
    }

    if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value)) {
      return 'Please Enter a Valid Email Address!';
    }

    return null;
  }

  void _enterResetPass() {
    TextEditingController passController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: new Text(
                "New Password",
                style: TextStyle(
                    color: Colors.indigo[800], fontWeight: FontWeight.bold),
              ),
              content: new Container(
                  height: 100,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Enter Your New Password : ",
                            style: TextStyle(
                                color: Colors.brown[900],
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                        Form(
                            key: formKeyForResetPassword,
                            child: TextFormField(
                                controller: passController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  icon: Icon(Icons.lock),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _passwordShow = !_passwordShow;
                                      });
                                    },
                                    child: Icon(_passwordShow
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown[900]),
                                obscureText: !_passwordShow,
                                validator: passValidate,
                                onSaved: (String value) {
                                  _password = value;
                                }))
                      ],
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes, Done",
                      style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (formKeyForResetPassword.currentState.validate()) {
                        passResetController.text = passController.text;
                        _resetPass();
                      }
                    }),
                new FlatButton(
                  child: new Text(
                    "No, Cancel",
                    style: TextStyle(
                        color: Colors.red[700], fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  String passValidate(String value) {
    if (value.isEmpty) {
      return 'Password is Required';
    }

    if (value.length < 5) {
      return 'Password Length Must Be 5 Digits Above';
    }
    return null;
  }

  void _resetPass() {
    String email = emailForgotController.text;
    String password = passResetController.text;

    final form = formKeyForResetPassword.currentState;

    if (form.validate()) {
      form.save();
      http.post("https://doubleksc.com/coffee_home/php/reset_password.php",
          body: {
            "email": email,
            "password": password,
          }).then((res) {
        print(res.body);
        if (res.body.contains("success")) {
          Navigator.of(context).pop();
          Toast.show("Reset Password Success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        } else {
          Toast.show("Reset Password Failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }
}