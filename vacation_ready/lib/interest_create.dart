//imports
import 'package:flutter/material.dart';

//widget code
class Interests extends StatelessWidget {
  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Multi Page Application"),
      ),
      body: new Checkbox(
          value: false,
          onChanged: null
      )
    );
  }
}