// import 'package:flutter/material.dart';
// import '../utilities/drawer.dart';
// import '../utilities/user_info.dart';
// import '../utilities/trip_info_user_data.dart';
// import '../utilities/attractions_user_data.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';
// import 'package:carousel_slider/carousel_slider.dart';

// class CreateItinerary extends StatefulWidget {
//   @override
//   State createState() => CreateItineraryState();
// }

// class CreateItineraryState extends State<CreateItinerary> {
//   String currentId, currentType;
//   bool loaded = false;
//   List breakfast_list, lunch_list, dinner_list, attractions;
//   bool isLoaded = false;

//   Future<Widget> getData() async {
//     http.Response response = await http.post(
//         serverAddress + 'generate-trip',
//         headers: {
//           "Content-Type": "application/json"
//         }, body: json.encode({
//           "trip_id": 29,
//           "interest_set_id": 24
//         }));
//     print(response.statusCode);
//     this.setState(() {
//       if (response.statusCode == 400) {

//       } else {
//         isLoaded = true;
//         breakfast_list = jsonDecode(response.body)['restaurants']['breakfast'];
//         lunch_list = jsonDecode(response.body)['restaurants']['lunch'];
//         dinner_list = jsonDecode(response.body)['restaurants']['dinner'];
//         return new Container();
//       }
//     });
//   }

//   @override
//   void initState() {
//       this.getData();
//     }

//   Icon getIconAssociatedToType(String type) {
//     Icon iconToReturn;

//     if (type == "breakfast" || type == "lunch" || type == "dinner") {
//       iconToReturn = Icon(
//         Icons.fastfood,
//         color: Colors.indigoAccent,
//       );
//     } else {
//       iconToReturn = Icon(
//         Icons.party_mode,
//         color: Colors.indigoAccent,
//       );
//     }

//     return iconToReturn;
//   }

//   Card buildCard(var data) {
//     var customCard = new Card(
//       elevation: 5.0,
//       margin: EdgeInsets.all(4.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       child: new Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           ListTile(
//             leading: getIconAssociatedToType("breakfast"),
//             title: Text(data["name"],
//                 overflow: TextOverflow.ellipsis,
//                 style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
//             subtitle: Text(data["cuisine"].toString().toUpperCase(),
//                 style: new TextStyle(fontSize: 12.0),
//                 overflow: TextOverflow.ellipsis),
//             trailing: GestureDetector (
//               child: Icon(Icons.location_on,
//                 color: Colors.indigoAccent,
//               ),
//               onTap: () {
//                 launch(data['maps_link']);
//               }
//             ),
//           ),
//         ],
//       ),
//     );
//     return customCard;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         drawer: new MyDrawer(),
//         appBar: new AppBar(
//           title: new Text("vacation ready"),
//           backgroundColor: Color.fromRGBO(101, 202, 214, 1.0),
//         ),
//         body:
//                     !isLoaded ?
//                        new Container(child: CircularProgressIndicator(), alignment: Alignment.center) :
//                        new Container(
//           padding: EdgeInsets.only(left: 80, top: 20.0),
//           child: Column(
//             children: <Widget>[
//               CarouselSlider(
//                 viewportFraction: 0.95,
//               height: 80.0,
//               items: breakfast_list.map((i) {
//                 return Builder(
//                   builder: (BuildContext context) {
//                     return Container(
//                       child: buildCard(i)
//                     );
//                   },
//                 );
//               }).toList(),
//           ),
//             CarouselSlider(
//                 viewportFraction: 0.95,
//               height: 80.0,
//               items: lunch_list.map((i) {
//                 return Builder(
//                   builder: (BuildContext context) {
//                     return Container(
//                       child: buildCard(i)
//                     );
//                   },
//                 );
//               }).toList(),
//           ),
//            CarouselSlider(
//                 viewportFraction: 0.95,
//               height: 80.0,
//               items: dinner_list.map((i) {
//                 return Builder(
//                   builder: (BuildContext context) {
//                     return Container(
//                       child: buildCard(i)
//                     );
//                   },
//                 );
//               }).toList(),
//           ),
//             ])
//           ));
//     }
//   }

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
  List breakfast_list, lunch_list, dinner_list, total_options;
  Map attractions;
  bool isLoaded = false;
  List<ListTile> litems = [];
  List<Widget> carousels = [];
  bool is_first_carousel = true;
  Map events_data;
  var _current, attractions_list, data_to_card;

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

  Card buildCard(var data) {
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
            leading: getIconAssociatedToType("breakfast"),
            title: Text(data["name"],
                overflow: TextOverflow.ellipsis,
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
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
                      fontWeight: FontWeight.bold, fontSize: 12.0)),
              subtitle: Text(typeEvent,
                  style: new TextStyle(fontSize: 12.0),
                  overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
    return customCard;
  }

  // Card buildEventCard(var data) {
  //   var customCard = new Card(
  //     elevation: 5.0,
  //     margin: EdgeInsets.all(4.0),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(15.0),
  //     ),
  //     child: new Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         ListTile(
  //           leading: getIconAssociatedToType("breakfast"),
  //           title: Text(data["name"],
  //               overflow: TextOverflow.ellipsis,
  //               style:
  //                   new TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
  //           subtitle: Text(data["cuisine"].toString().toUpperCase(),
  //               style: new TextStyle(fontSize: 12.0),
  //               overflow: TextOverflow.ellipsis),
  //           trailing: GestureDetector(
  //               child: Icon(
  //                 Icons.location_on,
  //                 color: Colors.indigoAccent,
  //               ),
  //               onTap: () {
  //                 launch(data['maps_link']);
  //               }),
  //         ),
  //       ],
  //     ),
  //   );
  //   return customCard;
  // }

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

  void confirmNewEvent() {
    Navigator.pop(context);
    if (_current == null) {
      _current = 0;
    }

    String selected_option = total_options[_current];
    if (selected_option == "breakfast") {
      data_to_card = breakfast_list;
    } else if (selected_option == "lunch") {
      data_to_card = lunch_list;
    } else if (selected_option == "dinner") {
      data_to_card = dinner_list;
    } else {
      data_to_card = attractions[selected_option];
    }

    Widget carousel = new Container(
          padding: EdgeInsets.only(left: 80, top: 20.0),
          child: Column(
            children: <Widget>[
              CarouselSlider(
                viewportFraction: 0.95,
              height: 80.0,
              items: data_to_card.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      child: buildCard(i)
                    );
                  },
                );
              }).toList(),
          )]));
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
        floatingActionButton: new FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Color.fromRGBO(101, 202, 214, 1.0),
          onPressed: addNewEvent,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: new Column(
          // children: <Widget>[
          //   new Expanded(
                
          // ],
        ));
  }
}
