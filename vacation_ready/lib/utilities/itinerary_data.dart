List breakfast_list, names_of_options, lunch_list, dinner_list;
Map attractions;
Map events_data;
var attractions_list;
List selected_options = [{'lat': 40.111812, 'lng': -88.232343, 'maps_link': "https://maps.google.com/maps/contrib/100764625533607939882/photos", 'name': "Four Breakfast & More", 'place_id': "ChIJV0MEbwW1RIYRb1zpqKbtf0M"}];
List selected_options_type = [];
bool isLoaded = false;
bool apiCalled = false;
var current_day_number;

var SET_TRIP_DAY_URL = "http://vr-vacation-ready.herokuapp.com/add-trip";
var GET_TRIP_DAY_URL = "http://vr-vacation-ready.herokuapp.com/get-trip";