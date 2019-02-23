import 'package:flutter/material.dart';
import './pages/splash_screen.dart';


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
        
      }
    );
  }
}
