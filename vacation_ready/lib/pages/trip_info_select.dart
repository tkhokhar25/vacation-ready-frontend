import 'dart:async';

import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../utilities/drawer.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import '../utilities/trip_info_user_data.dart';

const kGoogleApiKey = "AIzaSyD1FDVqtCDH9dapUleXSdfILVpCsR6cYog";

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class TripInfoSelect extends StatefulWidget {
  @override
  _TripInfoSelectState createState() => _TripInfoSelectState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();
final myController = TextEditingController();

class _TripInfoSelectState extends State<TripInfoSelect> {
  Mode _mode = Mode.overlay;

  final formats = {
    InputType.both: DateFormat("MM/d/yyyy , h:mma"),
  };

  // Changeable in demo
  InputType inputType = InputType.both;
  bool editable = true;
  DateTime dateArrival;
  DateTime dateDeparture;

  void saveDetails() {
    if (dateArrival.toString() == "" ||
        dateDeparture.toString() == "" ||
        place_id == "") {
      return;
    }
    arrival = dateArrival.toString();
    departure = dateDeparture.toString();
    
    var jsonReq = new Request(
      sliderMealNum.toInt(),
      sliderMealBudget.toInt(),
      (sliderOverallBudget / (sliderNumPeople + 1)).toInt(),
      2,
      arrival,
      departure,
      place_id);
    Map myMap = request_to_map(jsonReq);
    String json = request_to_JSON(myMap);
    sendCreateAccountRequest(json);
    // Navigator.of(context).pushNamed('/itinerary_page');
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focus_node = new FocusNode();
    // focus_node.addListener();

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveDetails();
          Navigator.pushNamed(context, '/create_itinerary');
        },
        child: Icon(Icons.flight_takeoff),
        backgroundColor: Color.fromRGBO(101, 202, 214, 1.0),
        foregroundColor: Colors.white,
      ),
      drawer: new MyDrawer(),
      appBar: new AppBar(
          title: new Text("vacation ready"),
          backgroundColor: Color.fromRGBO(101, 202, 214, 1.0)),
      key: homeScaffoldKey,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              "Trip Details",
              style: TextStyle(fontFamily: "Montserrat", fontSize: 30),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Where to ?",
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: new FocusScope(
                          node: new FocusScopeNode(),
                          child: new TextField(
                            onTap: _handlePressButton,
                            decoration: InputDecoration(hintText: "City Name"),
                            controller: myController,
                          ))),
                )
              ],
            ),
          ),

          Padding(
            child: Text(
              "What is your date and time of arrival ?",
              style: TextStyle(fontSize: 20),
            ),
            padding: EdgeInsets.only(top: 70, right: 40, left: 20),
          ),

          //Expanded(
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 40),
            height: 90,
            child: ListView(
              children: <Widget>[
                FocusScope(
                    node: new FocusScopeNode(),
                    child: DateTimePickerFormField(
                      maxLines: 1,
                      inputType: inputType,
                      format: formats[inputType],
                      editable: editable,
                      decoration: InputDecoration(
                        labelText: 'Date/Time',
                        hasFloatingPlaceholder: false,
                      ),
                      onChanged: (dt) => setState(() => dateArrival = dt),
                    )),
                SizedBox(height: 5.0),
              ],
            ),
          ),
          //),

          Padding(
            child: Text(
              "What is your date and time of departure ?",
              style: TextStyle(fontSize: 20),
            ),
            padding: EdgeInsets.only(right: 40, left: 20),
          ),

          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 20.0, right: 40),
              child: ListView(
                children: <Widget>[
                  FocusScope(
                      node: new FocusScopeNode(),
                      child: DateTimePickerFormField(
                        inputType: inputType,
                        format: formats[inputType],
                        editable: editable,
                        decoration: InputDecoration(
                          labelText: 'Date/Time',
                          hasFloatingPlaceholder: false,
                        ),
                        onChanged: (dt) => setState(() => dateDeparture = dt),
                      )),
                  SizedBox(height: 50.0),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _handlePressButton() async {
    List<String> type = ['(cities)'];
    Prediction p = await PlacesAutocomplete.show(
        context: context, apiKey: kGoogleApiKey, mode: _mode, types: type);

    displayPrediction(p, homeScaffoldKey.currentState);
  }
}

Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
  if (p != null) {
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    myController.text = detail.result.name.toString();
    place_id = detail.result.placeId;
  }
}

