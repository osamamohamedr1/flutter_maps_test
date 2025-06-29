import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MyLocationTracker extends StatefulWidget {
  const MyLocationTracker({super.key});

  @override
  State<MyLocationTracker> createState() => _MyLocationTrackerState();
}

class _MyLocationTrackerState extends State<MyLocationTracker> {
  late final CameraPosition initialCameraPosition;
  late final Location location;
  @override
  void initState() {
    initialCameraPosition = CameraPosition(target: LatLng(30.0444, 31.2357));
    location = Location();
    checkAndRequestLocationService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(initialCameraPosition: initialCameraPosition);
  }

  void checkAndRequestLocationService() async {
    var isEnabled = await location.serviceEnabled();
    if (!isEnabled) {
      var isEnabled = await location.requestService();
      if (!isEnabled) {
        // show error
      }
    }
    checkAndRequestLocationPermission();
  }

  checkAndRequestLocationPermission() async {
    var permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      var isGarnted = await location.requestPermission();
      if (isGarnted != PermissionStatus.granted) {
        //show error
      }
    }
  }
}
