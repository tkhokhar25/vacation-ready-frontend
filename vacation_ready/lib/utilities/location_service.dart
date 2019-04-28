import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './itinerary_data.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../utilities/user_info.dart';


// final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

// var finalList = [{'lat': 40.111812, 'lng': -88.232343, 'maps_link': "https://maps.google.com/maps/contrib/100764625533607939882/photos", 'name': "Stevie Ray Vaughan Statue", 'place_id': "ChIJV0MEbwW1RIYRb1zpqKbtf0M"}, {'lat': 30.263103, 'lng': -97.75068399999999, 'maps_link': "https://maps.google.com/maps/contrib/100764625533607939882/photos", 'name': "Stevie Ray Vaughan Statue", 'place_id': "ChIJV0MEbwW1RIYRb1zpqKbtf0M"}, {'lat': 30.263103, 'lng': -97.75068399999999, 'maps_link': "https://maps.google.com/maps/contrib/100764625533607939882/photos", 'name': "Stevie Ray Vaughan Statue", 'place_id': "ChIJV0MEbwW1RIYRb1zpqKbtf0M"}, {'lat': 30.263103, 'lng': -97.75068399999999, 'maps_link': "https://maps.google.com/maps/contrib/100764625533607939882/photos", 'name': "Stevie Ray Vaughan Statue", 'place_id': "ChIJV0MEbwW1RIYRb1zpqKbtf0M"}, {'lat': 45.111812, 'lng': -88.232343, 'maps_link': "https://maps.google.com/maps/contrib/100764625533607939882/photos", 'name': "Four Breakfast & More", 'place_id': "ChIJV0MEbwW1RIYRb1zpqKbtf0M"}];

class GetLocationPage extends StatefulWidget {
  @override
  _GetLocationPageState createState() => _GetLocationPageState();
}

class _GetLocationPageState extends State<GetLocationPage> {
  FlutterLocalNotificationsPlugin plugin;
  Geolocator geolocator = Geolocator();
  String success = "";

  @override
  void initState() {
    super.initState();
    plugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =  new AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    plugin.initialize(initializationSettings, onSelectNotification: onSelect);
    // _firebaseMessaging.configure();
    _getLocation().then((position) {
      success = position;
    });
  }

  Future onSelect(String payload) {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("Did you enjoy your visit?"),
          content: new Container(
            height: 130,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
           child: new Column(children: <Widget>[new RaisedButton(disabledColor: Colors.white,
                                          color: Colors.white,
                                          elevation: 0,
                                          padding: EdgeInsets.only(
                                              left: 0, right: 5),
                                          child: Icon(
                                            Icons.thumb_up,
                                            color: Colors.red,
                                            size: 28,
                                          ),
                                          onPressed: () => _sendVote(1, "$payload"),
                                        ), new Padding(padding: EdgeInsets.only(bottom: 10)),
                                        new RaisedButton(disabledColor: Colors.white,
                                          color: Colors.white,
                                          elevation: 0,
                                          padding: EdgeInsets.only(
                                              left: 0, right: 5),
                                          child: Icon(
                                            Icons.thumb_down,
                                            color: Colors.red,
                                            size: 28,
                                          ),
                                          onPressed: () => _sendVote(0, "$payload"),
                                        )
            ] )
            
          ),
        );
        },
    );
  }

  
 Future _sendVote (type, place_id) async{
   print(type);
   print(place_id);
  http.Response response = await http.post(serverAddress + 'review-place',
        headers: {"Content-Type": "application/json"},
        body: json.encode({"place_id": place_id.toString(), "action": (type == 1 ? "upvote" : " downvote")}));
    print(response.statusCode);
// {
// 	"place_id" : "ch",
// 	"action" : "upvote"
// }

  }

  Future _showNotificationWithDefaultSound(var current) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await plugin.show(
      0,
      'Did you check into '+current["name"],
      'Take a moment to upvote/downvote',
      platformChannelSpecifics,
      payload: current["place_id"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            success == ""
                ? CircularProgressIndicator()
                : new Text("You gotcha location!"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:  Text(
                  "Location Detection Taking Place...",
                  style: TextStyle(color: Colors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<Null> _getLocation() async {
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    geolocator.getPositionStream(locationOptions).listen(
      (Position position) {
        for (var current in selected_options) {
            Geolocator().distanceBetween(position.latitude, position.longitude, current['lat'], current['lng']).then((distanceInMeters) {
            print(distanceInMeters);
            print(current["name"]);
            if (distanceInMeters < 300) {
              setState(() {
                  success = "FOUND";  
                  _showNotificationWithDefaultSound(current);       
              });
            }
            });
        }
      });
  }
}