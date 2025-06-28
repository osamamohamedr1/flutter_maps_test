import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final String name;
  final int id;

  final LatLng latLng;

  PlaceModel({required this.name, required this.id, required this.latLng});
}

List<PlaceModel> places = [
  PlaceModel(name: 'Cairo', id: 1, latLng: LatLng(30.0444, 31.2357)),
  PlaceModel(name: 'Alexandria', id: 2, latLng: LatLng(31.2156, 29.9553)),
  PlaceModel(name: 'Giza', id: 3, latLng: LatLng(29.9784, 31.1342)),
];
