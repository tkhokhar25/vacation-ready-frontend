import 'package:flutter/material.dart';
import 'cuisines_interest.dart';
import 'attractions_interest.dart';
import './pages/splash_screen.dart';

void main() {
  runApp(
    new App()
  );
}

// A stateless widget to control routes in the application
class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MySplashScreen(),
      theme: ThemeData(fontFamily: 'Roboto'),
      routes: <String, WidgetBuilder> {
        // Add all routes here
          '/grid-list' : (BuildContext context) => new GridListDemo()
      }
    );
  }
}
