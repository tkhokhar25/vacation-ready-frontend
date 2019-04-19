List breakfast_list, names_of_options, lunch_list, dinner_list;
Map attractions;
Map events_data;
var attractions_list;
List selected_options = [];
List selected_options_type = [];
bool isLoaded = false;
bool apiCalled = false;
var current_day_number;

var SET_TRIP_DAY_URL = "http://vr-vacation-ready.herokuapp.com/add-trip";
var GET_TRIP_DAY_URL = "http://vr-vacation-ready.herokuapp.com/get-trip";