import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../utilities/drawer.dart';
import '../utilities/attractions_user_data.dart';

class InitialSetInterest extends StatefulWidget {
  const InitialSetInterest({Key key}) : super(key: key);

  @override
  InitialSetInterestState createState() => InitialSetInterestState();
}

class InitialSetInterestState extends State<InitialSetInterest> {
  void changePage() {
    var jsonReq = new Request(
        sliderMealNum.toInt(),
        sliderMealBudget.toInt(),
        favoriteCuisines,
        (sliderOverallBudget / (sliderNumPeople + 1)).toInt(),
        favoriteAttractions,
        2);
    Map myMap = request_to_map(jsonReq);
    String json = request_to_JSON(myMap);
    sendCreateAccountRequest(json);
    
    Navigator.pushNamed(context, '/trip_info_select');
  }

  Widget build(BuildContext context) {
    // final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        drawer: new MyDrawer(),
        appBar: new AppBar(
            title: new Text("vacation ready"),
            backgroundColor: Color.fromRGBO(101, 202, 214, 1.0)),
        body: Column(
          children: <Widget>[
            new Padding(padding: EdgeInsets.only(top: 30.0)),
            Container(
                child: Column(children: <Widget>[
              Container(
                child: Text(
                  "How many people are travelling with you?",
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 18),
                  textAlign: TextAlign.left,
                ),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
              ),
              Container(
                  padding: EdgeInsets.only(top: 15.0, left: 40.0, right: 40.0),
                  child: Row(
                    children: <Widget>[
                      new Text(sliderNumPeople.toInt().toString()),
                      Expanded(
                          child: Slider(
                        activeColor: Color.fromRGBO(101, 202, 214, 1.0),
                        min: 0,
                        max: 15,
                        divisions: 15,
                        onChanged: (newRating) {
                          setState(() => sliderNumPeople = newRating);
                        },
                        value: sliderNumPeople,
                      ))
                    ],
                  )),
              Container(
                child: Text(
                  "How many meals do you usually have in a day?",
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 18),
                  textAlign: TextAlign.left,
                ),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
              ),
              Container(
                  padding: EdgeInsets.only(top: 15.0, left: 40.0, right: 40.0),
                  child: Row(
                    children: <Widget>[
                      new Text(sliderMealNum.toInt().toString()),
                      Expanded(
                          child: Slider(
                        activeColor: Color.fromRGBO(101, 202, 214, 1.0),
                        min: 0,
                        max: 6,
                        divisions: 6,
                        onChanged: (newRating) {
                          setState(() => sliderMealNum = newRating);
                        },
                        value: sliderMealNum,
                      ))
                    ],
                  )),
              new Padding(padding: EdgeInsets.only(top: 35.0)),
              Container(
                child: Text(
                  "What is your average budget per meal?",
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 18),
                  textAlign: TextAlign.left,
                ),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
              ),
              Container(
                  padding: EdgeInsets.only(top: 15.0, left: 40.0, right: 40.0),
                  child: Row(
                    children: <Widget>[
                      new Text('\$' + sliderMealBudget.toInt().toString()),
                      Expanded(
                          child: Slider(
                        activeColor: Color.fromRGBO(101, 202, 214, 1.0),
                        min: 5.0,
                        max: 150.0,
                        onChanged: (newRating) {
                          setState(() => sliderMealBudget = newRating);
                        },
                        value: sliderMealBudget,
                      ))
                    ],
                  )),
              new Padding(padding: EdgeInsets.only(top: 35.0)),
              Container(
                child: Text(
                  "What is your overall budget?",
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 18),
                  textAlign: TextAlign.left,
                ),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
              ),
              Container(
                  padding: EdgeInsets.only(top: 15.0, left: 40.0, right: 40.0),
                  child: Row(
                    children: <Widget>[
                      new Text('\$' + sliderOverallBudget.toInt().toString()),
                      Expanded(
                          child: Slider(
                        activeColor: Color.fromRGBO(101, 202, 214, 1.0),
                        min: 50,
                        max: 10000,
                        onChanged: (newRating) {
                          setState(() => sliderOverallBudget = newRating);
                        },
                        value: sliderOverallBudget,
                      ))
                    ],
                  ))
            ])),
            new Expanded(
                child: new Container(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          onPressed: changePage,
                          color: Color.fromRGBO(162, 228, 236, 1),
                          child: Text('Submit', style: TextStyle(fontFamily: 'Montserrat-Black'),),
                        ))))
          ],
        ));
  }
}
