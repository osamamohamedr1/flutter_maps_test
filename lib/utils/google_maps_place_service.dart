import 'dart:convert';

import 'package:google_maps_test/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:http/http.dart' as http;

class PlacesService {
  final String baseUrl = 'https://maps.googleapis.com/maps/api/place';
  final String apiKey = 'AIzaSyAJqb4dVmIbmbj0iPWaESzapoJvYOM0CTA';
  Future<List<PlaceModel>> getPredictions({
    required String input,
    required String sesstionToken,
  }) async {
    var response = await http.get(
      Uri.parse(
        '$baseUrl/autocomplete/json?key=$apiKey&input=$input&sessiontoken=$sesstionToken',
      ),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['predictions'];
      List<PlaceModel> places = [];
      for (var item in data) {
        places.add(PlaceModel.fromJson(item));
      }
      return places;
    } else {
      throw Exception();
    }
  }

  // Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
  //   var response = await http
  //       .get(Uri.parse('$baseUrl/details/json?key=$apiKey&place_id=$placeId'));

  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body)['result'];
  //     return PlaceDetailsModel.fromJson(data);
  //   } else {
  //     throw Exception();
  //   }
  // }
}
