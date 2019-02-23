import 'package:flutter/material.dart';
import 'cuisines_interest.dart';
import 'attractions_interest.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return new MaterialApp(
      theme: ThemeData(fontFamily: 'Roboto'),
      home: new GridListDemo(),
    );
  }
}