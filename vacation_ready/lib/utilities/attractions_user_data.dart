import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;

List<String> favoriteCuisines = [];
List<String> favoriteAttractions = [];
int selectCount = 0;
var interest_set_id = -1;
String set_name = "";

var SET_INTEREST_URL = "http://vr-vacation-ready.herokuapp.com/set-interest-set";
var UPDATE_INTEREST_URL = "http://vr-vacation-ready.herokuapp.com/update-interest-set";

class Request {
  List cuisines = [];
  List attractions = [];
  int user_id = -1;
  String set_name = "";

  Request(this.cuisines, this.attractions, this.user_id) {
    // Initialization code goes here.
  }
}

Map request_to_map(Request r1){
    var m1 = Map();
    m1["cuisines"] = r1.cuisines;
    m1["attractions"] = r1.attractions;
    m1["user_id"] = r1.user_id;
    return m1;
}

String request_to_JSON(Map m1){
    var jsonText = jsonEncode(m1);
    return jsonText;
}

sendCreateAccountRequest(String json) async {
  String URL = SET_INTEREST_URL;
  if (interest_set_id != -1){
      URL = UPDATE_INTEREST_URL;
      Map data_to_update = jsonDecode(json);
      data_to_update["interest_set_id"] = interest_set_id;
      json = jsonEncode(data_to_update);
  }

  try{
    http
    .post(URL, headers : {"Content-Type" : "application/json"}, body : json)
    .then((response) {
      Map data = jsonDecode(response.body);  
      if (data['STATUS'] == 'SUCCESS') {
          interest_set_id = data['interest_set_id'];
      }
      print(jsonDecode(response.body));
    });
    } catch (Exception) {
      print(Exception.toString());
  }
}