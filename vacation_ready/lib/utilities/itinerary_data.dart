List breakfast_list, names_of_options, lunch_list, dinner_list;
Map attractions;
Map events_data;
var attractions_list;
List selected_options = [{'lat': 40.11181207989272, 'lng':  -88.23234357010726, 'maps_link': "https://maps.google.com/maps/contrib/100764625533607939882/photos", 'name': "Starbucks", 'place_id': "ChIJV0MEbwW1RIYRb1zpqKbtf0M", 'type' : "lunch", 'cuisine': "Breakfast"}];
List selected_options_type = [];
bool isLoaded = false;
bool apiCalled = false;
var current_day_number;

var SET_TRIP_DAY_URL = "http://vr-vacation-ready.herokuapp.com/add-trip";
var GET_TRIP_DAY_URL = "http://vr-vacation-ready.herokuapp.com/get-trip";