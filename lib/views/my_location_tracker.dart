import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MyLocationTracker extends StatefulWidget {
  const MyLocationTracker({super.key});

  @override
  State<MyLocationTracker> createState() => _MyLocationTrackerState();
}

class _MyLocationTrackerState extends State<MyLocationTracker> {
  GoogleMapController? googleMapController;
  late final CameraPosition initialCameraPosition;
  late final Location location;
  Set<Marker> markers = {};
  @override
  void initState() {
    initialCameraPosition = CameraPosition(target: LatLng(30.0444, 31.2357));
    location = Location();
    updateMyLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: markers,
      onMapCreated: (controller) {
        googleMapController = controller;
        intitalizeMapStyle();
      },
      initialCameraPosition: initialCameraPosition,
    );
  }

  //change map style call it after map created
  intitalizeMapStyle() async {
    var nightMap = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/map_styles/night_map_style.json');

    googleMapController!.setMapStyle(nightMap);
  }

  //check if location enabled
  Future<void> checkAndRequestLocationService() async {
    var isEnabled = await location.serviceEnabled();
    if (!isEnabled) {
      var isEnabled = await location.requestService();
      if (!isEnabled) {
        // show error
      }
    }
  }

  //check permission
  Future<bool> checkAndRequestLocationPermission() async {
    var permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.deniedForever) {
      return false;
    }
    if (permissionStatus == PermissionStatus.denied) {
      var isGarnted = await location.requestPermission();
      if (isGarnted != PermissionStatus.granted) {
        //show error
        return false;
      }
    }

    return true;
  }

  // streem for user location to track
  void getLocation() {
    location.changeSettings(distanceFilter: 2);
    location.onLocationChanged.listen((location) {
      var myLocationMarker = Marker(
        markerId: MarkerId('myLocationMarker'),
        position: LatLng(location.latitude!, location.longitude!),
      );

      var cameraPosition = CameraPosition(
        zoom: 15,
        target: LatLng(location.latitude!, location.longitude!),
      );

      googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
      markers.add(myLocationMarker);
      setState(() {});
    });
  }

  void updateMyLocation() async {
    await checkAndRequestLocationService();
    var hasPemission = await checkAndRequestLocationPermission();
    if (hasPemission) {
      getLocation();
    } else {}
  }
}
