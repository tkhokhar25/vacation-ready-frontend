import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import '../utilities/attractions_user_data.dart';

String place_id = "";
String arrival = "";
String departure = "";
double sliderMealNum = 3;
double sliderMealBudget = 10;
double sliderOverallBudget = 500;
double sliderNumPeople = 3;
int trip_id = -1;

var SET_INTEREST_URL = "http://vr-vacation-ready.herokuapp.com/set-trip-info";

class Request {
  int num_meals = 0;
  int budget_per_meal = 0;
  int attraction_budget = 0;
  int user_id = -1;
  String place_id = "";
  String arrival_time = "";
  String departure_time = "";

  // Constructor, with syntactic sugar for assignment to members.
  Request(this.num_meals, this.attraction_budget, this.budget_per_meal, this.user_id, 
          this.arrival_time, this.departure_time, this.place_id) {
    // Initialization code goes here.
  }
}

Map request_to_map(Request r1){
    var m1 = Map();
    m1["num_meals"] = r1.num_meals;
    m1["budget_per_meal"] = r1.budget_per_meal;
    m1["attraction_budget"] = r1.attraction_budget;
    m1["user_id"] = r1.user_id;
    m1["interest_set_id"] = interest_set_id;
    m1["arrival_time"] = r1.arrival_time;
    m1["departure_time"] = r1.departure_time;
    m1["place_id"] = r1.place_id;
    return m1;
}

String request_to_JSON(Map m1){
    var jsonText = jsonEncode(m1);
    return jsonText;
}

sendCreateAccountRequest(String json) async {
  String URL = SET_INTEREST_URL;
  try{
    http
    .post(URL, headers : {"Content-Type" : "application/json"}, body : json)
    .then((response) {
      Map data = jsonDecode(response.body);
      if (data['STATUS'] == 'SUCCESS') {
          trip_id = data['trip_id'];
      }
    });
    } catch (Exception) {
      print(Exception.toString());
  }
}

int getNumDays(){
  String arrival_day = arrival.split(" ")[0];
  String departure_day = departure.split(" ")[0];

  var arrival_date = DateTime.parse(arrival_day);
  var departure_date = DateTime.parse(departure_day);

 Duration difference = departure_date.difference(arrival_date);
  print("num days = " + difference.inDays.toString());
  return difference.inDays;
}

List getDayNames(int num_days){
  List day_names = [];
  for (int i = 1; i < num_days + 1; i++) {
    String name_of_day = "Day "+ i.toString();
    day_names.add(name_of_day);
  }
  return day_names;
}