import 'dart:convert';
import 'dart:core';

List<String> favoriteCuisines = [];
List<String> favoriteAttractions = [];
int selectCount = 0;


double sliderMealNum = 3;
double sliderMealBudget = 10;
double sliderOverallBudget = 500;
double sliderNumPeople = 3;

/* {
   "num_meals":5,
   “average_meal_budget”: 1000,
   "cuisines":[
      "Mexican",
      "Indian"
   ],
   "average_attraction_budget": 5000,
   "attractions":[
      "Concerts",
      "Parks"
   ],
    “user_id” : 5
}
*/

class Request {
  int num_meals = 0;
  int average_meal_budget = 0;
  List cuisines = [];
  int average_attraction_budget = 0;
  List attractions = [];
  int user_id = -1;

  // Constructor, with syntactic sugar for assignment to members.
  Request(this.num_meals, this.average_meal_budget, this.cuisines, this.average_attraction_budget, this.attractions, this.user_id) {
    // Initialization code goes here.
  }
}

Map request_to_map(Request r1){
    var m1 = Map();
    m1["num_meals"] = r1.num_meals;
    m1["average_meal_budget"] = r1.average_meal_budget;
    m1["cuisines"] = r1.cuisines;
    m1["average_attraction_budget"] = r1.average_attraction_budget;
    m1["attractions"] = r1.attractions;
    m1["user_id"] = r1.user_id;
    return m1;
}

String request_to_JSON(Map m1){
    var jsonText = jsonEncode(m1);
    print(jsonText);
    return jsonText;
}
