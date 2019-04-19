import 'package:flutter/material.dart';
import '../utilities/drawer.dart';
import '../utilities/user_info.dart';
import '../utilities/trip_info_user_data.dart';
import '../utilities/attractions_user_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';

class CreateItinerary extends StatefulWidget {
  @override
  State createState() => CreateItineraryState();
}

class CreateItineraryState extends State<CreateItinerary> {
  String currentId, currentType;
  bool loaded = false;
  List breakfast_list, lunch_list, dinner_list, total_options, data_to_card;
  Map attractions;
  bool isLoaded = false, isSelected = false;
  List<ListTile> litems = [];
  List<Widget> carousels = [];
  bool is_first_carousel = true;
  Map events_data;
  var _current, attractions_list, _currentSelection;
  List selected_options = [];
  String cardType = "";
  ScrollController scroll_controller = ScrollController();

  Future<Widget> getData() async {
    http.Response response = await http.post(serverAddress + 'generate-trip',
        headers: {"Content-Type": "application/json"},
        body: json.encode({"trip_id": 29, "interest_set_id": 24}));
    print(response.statusCode);
    this.setState(() {
      if (response.statusCode == 400) {
      } else {
        isLoaded = true;
        breakfast_list = jsonDecode(response.body)['restaurants']['breakfast'];
        lunch_list = jsonDecode(response.body)['restaurants']['lunch'];
        dinner_list = jsonDecode(response.body)['restaurants']['dinner'];
        attractions = jsonDecode(response.body)['attractions'];
        return new Container();
      }
    });
  }

  Future<Map> getInterestSet(var interest_set_id) async {
    String URL = GET_INTEREST_URL;
    String json;
    if (interest_set_id != -1) {
      Map interest_data = new Map();
      interest_data["interest_set_id"] = interest_set_id;
      json = jsonEncode(interest_data);
    }

    try {
      http
          .post(URL, headers: {"Content-Type": "application/json"}, body: json)
          .then((response) {
        events_data = jsonDecode(response.body);
        attractions_list = events_data['result'][0]['attractions'];
        total_options = attractions_list;
        total_options.add("breakfast");
        total_options.add("lunch");
        total_options.add("dinner");
      });
    } catch (Exception) {
      print(Exception.toString());
    }
    return null;
  }

  @override
  void initState() {
    this.getData();
    this.getInterestSet(24);
    print(total_options);
  }

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

  Card buildCard(var data, int index, int whocalled) {
    var customCard;
    if (cardType == "food") {
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
              leading: getIconAssociatedToType("attraction"),
              title: Text(data["name"],
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 11.0)),
              subtitle: Text(data["type"].toString().toUpperCase(),
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

  Card buildOptionsCard(var type) {
    var typeEvent = "attraction";
    if (type == "breakfast" || type == "lunch" || type == "dinner") {
      typeEvent = "food";
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
                              items: total_options.map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                        child: buildOptionsCard(i));
                                  },
                                );
                              }).toList(),
                              onPageChanged: (index) {
                                setState(() {
                                  _current = index;
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
    });
  }

  void confirmNewEvent() {
    Navigator.pop(context);
    if (_currentSelection == null) {
      _currentSelection = 0;
    }
    setState(() {
      isSelected = true;
      //print(_currentSelection);
      if (data_to_card != null) {
        selected_options.add(data_to_card[_currentSelection]);
        scroll_controller.animateTo(scroll_controller.position.maxScrollExtent,
            duration: Duration(seconds: 1), curve: Curves.easeIn);
      }
    });

    if (_current == null) {
      _current = 0;
    }

    String selected = total_options[_current];
    cardType = "food";
    setState(() {
      if (selected == "breakfast") {
        data_to_card = breakfast_list;
        total_options.removeAt(_current);
      } else if (selected == "lunch") {
        data_to_card = lunch_list;
        total_options.removeAt(_current);
      } else if (selected == "dinner") {
        data_to_card = dinner_list;
        total_options.removeAt(_current);
      } else {
        cardType = "attraction";
        data_to_card = attractions[selected];
      }
    });
    print(data_to_card);
    print(isSelected);

    _current = 0;
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
            : new FloatingActionButton(
                tooltip: "Add a new event to your day",
                elevation: 8.0,
                child: const Icon(Icons.add),
                backgroundColor: Color.fromRGBO(23, 150, 174, 1.0),
                onPressed: addNewEvent,
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: !isLoaded
            ? new Container(
                child: CircularProgressIndicator(), alignment: Alignment.center)
            : !isSelected
                ? new Container()
                : new ListView(
                    controller: scroll_controller,
                    children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 15)),
                        Container(
                            padding: EdgeInsets.only(left: 70, right: 15),
                            height: selected_options.length * 78.0,
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: selected_options.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return new Container(
                                      child: Row(children: <Widget>[
                                    Expanded(
                                        child: buildCard(
                                            selected_options[index], index, 0)),
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
                            padding: EdgeInsets.only(left: 80, right: 50),
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
                                    items: data_to_card.map((i) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Container(
                                              child: buildCard(i, 0, 1));
                                        },
                                      );
                                    }).toList(),
                                  )
                                ])),
                      ]));
  }
}

// new ListView(
//                             physics: NeverScrollableScrollPhysics(),
//                             children: List.generate(
//                                 selected_options == null
//                                     ? 0
//                                     : selected_options.length, (index) {
//                                 return new Container(child:Row (children: <Widget> [
//                                   Expanded(
//                                     child: buildCard(selected_options[index], index, 0)
//                                   ),
//                                   Container(
//                                     padding: EdgeInsets.only(left: 10),
//                                     height: 28,
//                                     width: 35,
//                                     key: Key(index.toString()),
//                                     child:new RaisedButton(
//                                       disabledColor: Colors.white,
//                                       color: Colors.white,
//                                       elevation: 0,
//                                       padding: EdgeInsets.only(left: 0 ,right:5),
//                                       child: Icon(Icons.delete, color: Colors.red, size: 28,),
//                                       onPressed: () => delete_card(index),
//                                   ))
//                               ]));
//                             }),
//                         )
