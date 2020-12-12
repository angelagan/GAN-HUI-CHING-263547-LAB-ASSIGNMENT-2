import 'package:flutter/material.dart';
 
void main() => runApp(MainScreen());
 
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
        appBar: AppBar(
          title: Text('Main Screen'),
        ),
        body: Center(
          child: Container(
            child: Text('Welcome to Coffee Home'),
          ),
        ),
    );
  }
}