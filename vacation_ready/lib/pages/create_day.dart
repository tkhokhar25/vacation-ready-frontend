import 'package:flutter/material.dart';
import '../utilities/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utilities/itinerary_data.dart';
import '../utilities/trip_info_user_data.dart';

class CreateDay extends StatefulWidget {
  @override
  State createState() => CreateDayState();
}

class CreateDayState extends State<CreateDay> {
  String currentId, currentType;
  bool loaded = false;
  List data_for_carousel;
  bool isSelectedOption = false;
  List<Widget> carousels = [];
  bool is_first_carousel = true;
  var _currentOption, _currentSelection, _currentSelectionType;
  String selectedOption = "";
  ScrollController scroll_controller = ScrollController();

  Icon getIconAssociatedToType(String type) {
    Icon iconToReturn;
    if (type == "breakfast" || type == "lunch" || type == "dinner") {
      iconToReturn = Icon(
        Icons.fastfood,
        color: Colors.indigoAccent,
      );
    } else {
      iconToReturn = Icon(
        Icons.party_mode,
        color: Colors.indigoAccent,
      );
    }

    return iconToReturn;
  }

  Card buildOptionsCard(var type) {
    var typeEvent = "Attraction";
    if (type == "Breakfast" || type == "Lunch" || type == "Dinner") {
      typeEvent = "Food";
    }
    var customCard = new Card(
      elevation: 5.0,
      margin: EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              title: Text(type,
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 11.0)),
              subtitle: Text(typeEvent,
                  style: new TextStyle(fontSize: 10.0),
                  overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
    return customCard;
  }

  Card buildCard(var data) {
    var type = data["type"];
    var customCard;
    if (type == "breakfast" || type == "lunch" || type == "dinner") {
      customCard = new Card(
        elevation: 5.0,
        margin: EdgeInsets.all(4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: getIconAssociatedToType("breakfast"),
              title: Text(data["name"],
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12.0)),
              subtitle: Text(data["cuisine"].toString().toUpperCase(),
                  style: new TextStyle(fontSize: 12.0),
                  overflow: TextOverflow.ellipsis),
              trailing: GestureDetector(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.indigoAccent,
                  ),
                  onTap: () {
                    launch(data['maps_link']);
                  }),
            ),
          ],
        ),
      );
    } else {
      customCard = new Card(
        elevation: 5.0,
        margin: EdgeInsets.all(2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: getIconAssociatedToType("Attraction"),
              title: Text(data["name"],
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 11.0)),
              subtitle: Text(type.toString().toUpperCase(),
                  style: new TextStyle(fontSize: 10.0),
                  overflow: TextOverflow.ellipsis),
              trailing: GestureDetector(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.indigoAccent,
                  ),
                  onTap: () {
                    launch(data['maps_link']);
                  }),
            ),
          ],
        ),
      );
    }

    return customCard;
  }

  void addNewEvent() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              color: Color(0xFF737373),
              height: 190,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Stack(children: [
                          CarouselSlider(
                              viewportFraction: 0.95,
                              height: 100.0,
                              items: names_of_options.map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                        child: buildOptionsCard(i));
                                  },
                                );
                              }).toList(),
                              onPageChanged: (index) {
                                setState(() {
                                  _currentOption = index;
                                });
                              }),
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: RaisedButton(
                          child: const Icon(
                            Icons.done,
                            color: Colors.white,
                          ),
                          onPressed: confirmNewEvent,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(300.0)),
                          color: Color.fromRGBO(101, 202, 214, 1.0),
                        )),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
              ));
        });
  }

  void delete_card(int idx) {
    setState(() {
      selected_options.removeAt(idx);
      //selected_options_type.removeAt(idx);
    });
  }

  findClosest(listToSort) {
    if (selected_options.length == 0) {
      return listToSort;
    }

    var optionToCheck = selected_options[selected_options.length - 1];
    var distanceMap = Map<double, int>();

    for (var i = 0; i < listToSort.length; i++) {
      try {
        var distance = pow(listToSort[i]["lat"] - optionToCheck["lat"], 2) +
            pow(listToSort[i]["lng"] - optionToCheck["lng"], 2);
        distanceMap[distance] = i;
      } catch (e) {
        distanceMap[100.0] = i;
      }
    }

    var sortedKeys = distanceMap.keys.toList()..sort();
    List listToReturn = List();

    for (var i = 0; i < sortedKeys.length; i++) {
      listToReturn.add(listToSort[distanceMap[sortedKeys[i]]]);
    }

    return listToReturn;
  }

  void confirmNewEvent() {
    Navigator.pop(context);

    if (_currentSelection == null) {
      _currentSelection = 0;
    }
    setState(() {
      isSelectedOption = true;

      // First time, data_to_card will be null since it has not be set. Adds to final list
      if (data_for_carousel != null) {
        selected_options.add(data_for_carousel[_currentSelection]);
        scroll_controller.animateTo(scroll_controller.position.maxScrollExtent,
            duration: Duration(seconds: 1), curve: Curves.easeIn);
      }
    });

    if (_currentOption == null) {
      _currentOption = 0;
    }

    setState(() {
      selectedOption = names_of_options[_currentOption];
      selected_options_type.add(selectedOption);
      if (selectedOption == "Breakfast") {
        data_for_carousel = findClosest(breakfast_list);
        //names_of_options.removeAt(_currentOption);
      } else if (selectedOption == "Lunch") {
        data_for_carousel = findClosest(lunch_list);
        //names_of_options.removeAt(_currentOption);
      } else if (selectedOption == "Dinner") {
        data_for_carousel = findClosest(dinner_list);
        //names_of_options.removeAt(_currentOption);
      } else {
        data_for_carousel = findClosest(attractions[selectedOption]);
      }
    });

    _currentOption = 0;
  }

  Future<Map> setDayofTrip(var trip_id) async {
    String URL = SET_TRIP_DAY_URL;
    String json;
    Map day_data;
    if (trip_id != -1) {
      Map set_trip_day_data = new Map();
      set_trip_day_data["trip_id"] = trip_id;
      set_trip_day_data["day_num"] = current_day_number;
      set_trip_day_data["day_details"] = selected_options;
      json = jsonEncode(set_trip_day_data);
      print(json);
    }

    try {
      http
          .post(URL, headers: {"Content-Type": "application/json"}, body: json)
          .then((response) {
        day_data = jsonDecode(response.body);
        if (day_data["STATUS"] == "SUCCESS"){
          print("successsssss");
          return day_data;
        
        }else {
          return null;
        }
      });
    } catch (Exception) {
      print(Exception.toString());
    }
    return null;
  }


  void donePlanning(){
    // setDayofTrip(trip_id);
    // selected_options.clear();
    //selected_options_type.clear();
    Navigator.pushNamed(context, '/location_detection');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: new MyDrawer(),
        appBar: new AppBar(
          title: new Text("vacation ready"),
          backgroundColor: Color.fromRGBO(101, 202, 214, 1.0),
        ),
        floatingActionButton: !isLoaded
            ? new Container()
            : new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new FloatingActionButton(
                    heroTag: null,
                    tooltip: "Add a new event to your day",
                    elevation: 8.0,
                    child: const Icon(Icons.add),
                    backgroundColor: Color.fromRGBO(23, 150, 174, 0.6),
                    onPressed: addNewEvent,
                  ),

                  new Padding(padding: EdgeInsets.only(top: 15),),

                  new FloatingActionButton(
                    heroTag: null,
                    tooltip: "Finish Planning for the day",
                    elevation: 8.0,
                    child: const Icon(Icons.done),
                    backgroundColor: Color.fromRGBO(23, 150, 174, 0.6),
                    onPressed: donePlanning,
                  )
                ],
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: !isLoaded
            ? new Container(
                child: CircularProgressIndicator(), alignment: Alignment.center)
            : !isSelectedOption
                ? new Container()
                : new ListView(
                    controller: scroll_controller,
                    children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 15)),
                        Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            height: selected_options.length * 80.0,
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: selected_options.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return new Container(
                                      child: Row(children: <Widget>[
                                    Expanded(
                                        child: buildCard(
                                            selected_options[index],
                                            /*selected_options_type[index]*/)),
                                    Container(
                                        padding: EdgeInsets.only(left: 10),
                                        height: 28,
                                        width: 35,
                                        key: Key(index.toString()),
                                        child: new RaisedButton(
                                          disabledColor: Colors.white,
                                          color: Colors.white,
                                          elevation: 0,
                                          padding: EdgeInsets.only(
                                              left: 0, right: 5),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 28,
                                          ),
                                          onPressed: () => delete_card(index),
                                        ))
                                  ]));
                                })),
                        Container(
                            height: 91.0,
                            padding: EdgeInsets.only(left: 50, right: 50),
                            child: new ListView(
                                physics: NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  CarouselSlider(
                                    viewportFraction: 0.95,
                                    onPageChanged: (index) {
                                      setState(() {
                                        _currentSelection = index;
                                      });
                                    },
                                    height: 80.0,
                                    items: data_for_carousel.map((i) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Container(
                                              child:
                                                  buildCard(i));
                                        },
                                      );
                                    }).toList(),
                                  )
                                ])),
                      ]));
  }
}
