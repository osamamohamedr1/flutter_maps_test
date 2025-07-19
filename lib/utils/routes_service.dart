import 'dart:convert';
import 'dart:developer';

import 'package:google_maps_test/models/routes_model/routes_model.dart';
import 'package:http/http.dart' as http;

final String baseUrl =
    'https://routes.googleapis.com/directions/v2:computeRoutes';
final String apiKey = 'AIzaSyAJqb4dVmIbmbj0iPWaESzapoJvYOM0CTA';

class RoutesService {
  Future<RoutesModel> fetchRoutes({
    required Map<String, dynamic> routBody,
  }) async {
    Uri url = Uri.parse(baseUrl);
    Map<String, String> header = {
      'X-Goog-Api-Key': apiKey,
      'Content-Type': 'application/json',
      'X-Goog-FieldMask': 'routes.duration,routes.distanceMeters',
    };

    try {
      log(routBody.toString());
      var result = await http.post(
        url,
        body: jsonEncode(routBody),
        headers: header,
      );
      log('Response Code: ${result.statusCode}');
      log('Response Body: ${result.body}');
      return RoutesModel.fromJson(jsonDecode(result.body));
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }
}
