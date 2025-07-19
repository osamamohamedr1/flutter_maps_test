// ignore_for_file: unused_catch_clause

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_test/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:google_maps_test/models/place_details_model/place_details_model.dart';
import 'package:google_maps_test/models/route_body/destination..dart';
import 'package:google_maps_test/models/route_body/lat_lng..dart';
import 'package:google_maps_test/models/route_body/location..dart';
import 'package:google_maps_test/models/route_body/origin..dart';
import 'package:google_maps_test/models/route_body/route_body..dart';
import 'package:google_maps_test/utils/location_service.dart';
import 'package:google_maps_test/utils/place_service.dart';
import 'package:google_maps_test/utils/routes_service.dart';

class GoogleMapService {
  PlacesService placesService = PlacesService();
  LocationService locationService = LocationService();
  RoutesService routesService = RoutesService();
  LatLng? myLocation;

  Future<void> getPredictions({
    required String input,
    required String sesstionToken,
    required List<PlaceModel> places,
  }) async {
    if (input.isNotEmpty) {
      var result = await placesService.getPredictions(
        input: input,
        sesstionToken: sesstionToken,
      );

      places.clear();
      places.addAll(result);
    } else {
      places.clear();
    }
  }

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) {
    return placesService.getPlaceDetails(placeId: placeId);
  }

  void updateMyLocation({
    required Function onLocationUpdated,
    required Set<Marker> markers,
    required GoogleMapController googleMapController,
  }) {
    locationService.getLiveLocation((locationData) {
      myLocation = LatLng(locationData.latitude!, locationData.longitude!);
      var cameraPosition = CameraPosition(target: myLocation!, zoom: 10);
      var myMarker = Marker(
        markerId: MarkerId('My location'),
        position: myLocation!,
      );
      markers.add(myMarker);

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
      onLocationUpdated();
    });
  }

  Future<List<LatLng>> getRoutesData({required LatLng destination}) async {
    // ignore: unused_local_variable
    final routeBody = RouteBody(
      origin: Origin(
        location: LocationModel(
          latLng: LatLngModel(
            latitude: myLocation!.latitude,
            longitude: myLocation!.longitude,
          ),
        ),
      ),
      destination: Destination(
        location: LocationModel(
          latLng: LatLngModel(
            latitude: destination.latitude,
            longitude: destination.longitude,
          ),
        ),
      ),
      travelMode: 'DRIVE',
      routingPreference: 'ROUTING_PREFERENCE_TRAFFIC_AWARE',
      computeAlternativeRoutes: false,
    );

    // var result = await routesService.fetchRoutes(routBody: routeBody.toJson());
    // print(result.routes);
    return getDecodedRoute();
  }

  //RoutesModel result get points in its constructor
  List<LatLng> getDecodedRoute() {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> points = polylinePoints.decodePolyline(
      'cvs}Do`kvDff`Gcv`F',
      // result.routes!.first.polyline!.encodedPolyline!,
    );
    // log(points.toString());
    return points.map((e) => LatLng(e.latitude, e.longitude)).toList();
  }

  void drawRoute({
    required List<LatLng> points,
    required GoogleMapController googleMapController,
    required Set<Polyline> polylines,
  }) {
    Polyline polyline = Polyline(
      color: Colors.black,
      width: 5,
      polylineId: PolylineId('route'),
      points: points,
    );
    polylines.add(polyline);
    LatLngBounds bounds = getLatLangBounds(points);
    googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 16));
  }

  LatLngBounds getLatLangBounds(List<LatLng> points) {
    double southwestLat = points.first.latitude;
    double southwestLng = points.first.longitude;
    double northeastLat = points.first.latitude;
    double northeastLng = points.first.longitude;
    for (var point in points) {
      southwestLat = min(southwestLat, point.latitude);
      southwestLng = min(southwestLng, point.longitude);
      northeastLat = max(northeastLat, point.latitude);
      northeastLng = max(northeastLng, point.longitude);
    }
    return LatLngBounds(
      southwest: LatLng(southwestLat, southwestLng),
      northeast: LatLng(northeastLat, northeastLng),
    );
  }
}
