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
  List breakfast_list, lunch_list, dinner_list, attractions;
  bool isLoaded = false;
  List<String> litems = [];
  final TextEditingController eCtrl = new TextEditingController();

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
        return new Container();
      }
    });
  }

  @override
  void initState() {
    this.getData();
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

  void addNewEvent() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              color: Color(0xFF737373),
              height: 150,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: CarouselSlider(
                        viewportFraction: 0.95,
                        height: 100.0,
                        items: breakfast_list.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(child: buildCard(i));
                            },
                          );
                        }).toList(),
                      ),
                    )
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
          children: <Widget>[
            new Expanded(
                child: new ListView.builder(
                    itemCount: litems.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return new Text(litems[Index]);
                    }))
          ],
        ));
  }
}
