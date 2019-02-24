import 'package:flutter/material.dart';
import './pages/splash_screen.dart';
import './pages/attractions_interest.dart';
import './pages/cuisines_interest.dart';
import './pages/initial_set.dart';

// Main controller to run 4ceed_app
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
      routes: <String, WidgetBuilder> {
        // Add all routes here
        '/cuisines_select': (BuildContext context) => new CuisineInterest(),
        '/attractions_select': (BuildContext context) => new AttractionsInterest(),
        '/create_initial_set': (BuildContext context) => new InitialSetInterest(),
      }
    );
  }
}
