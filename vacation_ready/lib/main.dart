import 'package:flutter/material.dart';
import './pages/splash_screen.dart';
import './pages/attractions_interest.dart';
import './pages/cuisines_interest.dart';
import './pages/initial_set.dart';
import './pages/trip_info_select.dart';
import './pages/select_interest_set.dart';
import './pages/create_day.dart';

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
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: new MySplashScreen(),
      routes: <String, WidgetBuilder> {
        // Add all routes here
        '/cuisines_select': (BuildContext context) => new CuisineInterest(),
        '/attractions_select': (BuildContext context) => new AttractionsInterest(),
        '/create_initial_set': (BuildContext context) => new InitialSetInterest(),
        '/trip_info_select': (BuildContext context) => new TripInfoSelect(),
        '/select_interest_set': (BuildContext context) => new SelectInterestSet(),
        '/create_itinerary': (BuildContext context) => new CreateDay()
      }
    );
  }
}
