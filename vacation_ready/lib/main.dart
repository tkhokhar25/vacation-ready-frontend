import 'package:flutter/material.dart';
import 'cuisines_interest.dart';
import 'attractions_interest.dart';
import 'initial_set.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return new MaterialApp(
      theme: ThemeData(fontFamily: 'Roboto'),
      home: new CuisineInterest(),
      initialRoute: '/cuisines_select',
      routes: {
        '/cuisines_select': (BuildContext context) => new CuisineInterest(),
        '/attractions_select': (BuildContext context) => new AttractionsInterest(),
        '/create_initial_set': (BuildContext context) => new InitialSetInterest(),
      },
    );
  }
}