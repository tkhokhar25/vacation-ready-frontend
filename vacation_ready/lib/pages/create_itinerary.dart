import 'package:flutter/material.dart';
import '../utilities/drawer.dart';
import '../utilities/user_info.dart';
import '../utilities/trip_info_user_data.dart';
import '../utilities/attractions_user_data.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../utilities/itinerary_data.dart';

class CreateItinerary extends StatefulWidget {
  @override
  State createState() => CreateItineraryState();
}

class CreateItineraryState extends State<CreateItinerary> {
  int num_days = getNumDays();

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
        names_of_options = attractions_list;
        names_of_options.add("Breakfast");
        names_of_options.add("Lunch");
        names_of_options.add("Dinner");
      });
    } catch (Exception) {
      print(Exception.toString());
    }
    return null;
  }

  Future<Map> getDayofTrip(var trip_id, var day_num) async {
    String URL = GET_TRIP_DAY_URL;
    String json;
    Map day_data;
    if (trip_id != -1) {
      Map get_trip_day_data = new Map();
      get_trip_day_data["trip_id"] = trip_id;
      get_trip_day_data["day_num"] = day_num;
      json = jsonEncode(get_trip_day_data);
      print(json);
    }

    try {
      http
          .post(URL, headers: {"Content-Type": "application/json"}, body: json)
          .then((response) {
        day_data = jsonDecode(response.body);
        if (day_data["STATUS"] == "SUCCESS"){
          current_day_number = day_num;
          selected_options = day_data['result'];
          print("SHITTTTTTTTT");
          print(day_data["result"]);
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

  @override
  void initState() {
    if (apiCalled == false) {
      this.getData();
      this.getInterestSet(24);
      apiCalled = true;
    }
    print(names_of_options);
  }

  void _onTileClicked(int index) {
    index++;
    if (isLoaded == false){
      return;
    }
    current_day_number = index;
    if (getDayofTrip(trip_id, index) == null){
      print("creating a new day");
    }
    Navigator.pushNamed(context, '/create_day');
  }

  List<Widget> _getTiles() {
    final List<Widget> tiles = <Widget>[];
    for (int i = 0; i < num_days; i++) {
      tiles.add(new GridTile(
          child: new InkResponse(
        enableFeedback: true,
        child: new Padding(
            padding: EdgeInsets.only(top: 15, left: 5, right: 5),
            child: Card(
              elevation: 2.0,
              child: Padding(
                padding: EdgeInsets.only(left: 20, bottom: 20, right: 20),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Day " + (i + 1).toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Color.fromRGBO(101, 180, 220, 1.0),
            )),
        onTap: () => _onTileClicked(i),
      )));
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.pushNamed(context, '/create_day');
        //   },
        //   child: Icon(Icons.flight_takeoff),
        //   backgroundColor: Color.fromRGBO(101, 202, 214, 1.0),
        //   foregroundColor: Colors.white,
        // ),
        drawer: new MyDrawer(),
        appBar: new AppBar(
          title: new Text("vacation ready"),
          backgroundColor: Color.fromRGBO(101, 202, 214, 1.0),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          padding: const EdgeInsets.all(4.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: _getTiles(),
        ));
  }
}
