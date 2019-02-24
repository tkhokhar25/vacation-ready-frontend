import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import './login.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 7,
      navigateAfterSeconds: new SignIn(),
      image: new Image.asset(
      'images/vacation_ready_logo.png'),
      backgroundColor: Colors.black,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.red,
    );
  }
}
