import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_test/utils/location_service.dart';
import 'package:location_platform_interface/location_platform_interface.dart';

class MyLocationTracker extends StatefulWidget {
  const MyLocationTracker({super.key});

  @override
  State<MyLocationTracker> createState() => _MyLocationTrackerState();
}

class _MyLocationTrackerState extends State<MyLocationTracker> {
  GoogleMapController? googleMapController;
  late final CameraPosition initialCameraPosition;
  late LocationService locationService;
  bool isFristCall = true;
  Set<Marker> markers = {};
  @override
  void initState() {
    initialCameraPosition = CameraPosition(
      target: LatLng(30.0444, 31.2357),
      zoom: 1,
    );
    locationService = LocationService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: markers,
      onMapCreated: (controller) {
        googleMapController = controller;
        updateMyLocation();

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

  void updateMyLocation() async {
    locationService.getLiveLocation((location) {
      updateMyCamera(location);
      setMyLocationMarker(location);
      setState(() {});
    });
  }

  void updateMyCamera(LocationData location) {
    if (isFristCall) {
      var cameraPosition = CameraPosition(
        zoom: 20,
        target: LatLng(location.latitude!, location.longitude!),
      );
      googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
      isFristCall = false;
    } else {
      googleMapController?.animateCamera(
        CameraUpdate.newLatLng(LatLng(location.latitude!, location.longitude!)),
      );
    }
  }

  void setMyLocationMarker(LocationData location) {
    var myLocationMarker = Marker(
      markerId: MarkerId('myLocationMarker'),
      position: LatLng(location.latitude!, location.longitude!),
    );
    markers.add(myLocationMarker);
    setState(() {});
  }
}
