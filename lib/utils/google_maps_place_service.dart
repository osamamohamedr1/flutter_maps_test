import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_maps_test/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:google_maps_test/models/place_details_model/place_details_model.dart';
// import 'package:http/http.dart' as http;

class PlacesService {
  final String baseUrl = 'https://maps.googleapis.com/maps/api/place';
  final String apiKey = 'AIzaSyAJqb4dVmIbmbj0iPWaESzapoJvYOM0CTA';
  Future<List<PlaceModel>> getPredictions({
    required String input,
    required String sesstionToken,
  }) async {
    // var response = await http.get(
    //   Uri.parse(
    //     '$baseUrl/autocomplete/json?key=$apiKey&input=$input&sessiontoken=$sesstionToken',
    //   ),
    // );
    List<PlaceModel> places = [];
    final String jsonString = await rootBundle.loadString(
      'assets/predictions_json.json',
    );

    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    for (var element in jsonData['predictions']) {
      places.add(PlaceModel.fromJson(element));
    }
    return places;

    // if (response.statusCode == 200) {
    //   var data = jsonDecode(response.body)['predictions'];
    //   List<PlaceModel> places = [];
    //   for (var item in data) {
    //     places.add(PlaceModel.fromJson(item));
    //   }
    //   return places;
    // } else {
    //   throw Exception();
    // }
  }

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    // var response = await http.get(
    //   Uri.parse('$baseUrl/details/json?key=$apiKey&place_id=$placeId'),
    // );

    final String jsonFile = await rootBundle.loadString(
      'assets/place_details_json.json',
    );
    var result = jsonDecode(jsonFile);

    return PlaceDetailsModel.fromJson(result);

    // if (response.statusCode == 200) {
    //   var data = jsonDecode(response.body)['result'];
    //   return PlaceDetailsModel.fromJson(data);
    // } else {
    //   throw Exception();
    // }
  }
}
