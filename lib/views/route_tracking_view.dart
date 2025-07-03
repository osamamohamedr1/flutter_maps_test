import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_test/utils/location_service.dart';

class RouteTrackingView extends StatefulWidget {
  const RouteTrackingView({super.key});

  @override
  State<RouteTrackingView> createState() => _RouteTrackingViewState();
}

class _RouteTrackingViewState extends State<RouteTrackingView> {
  late CameraPosition initialCameraPosition;
  late LocationService locationService;
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  @override
  void initState() {
    initialCameraPosition = CameraPosition(target: LatLng(0, 0));
    locationService = LocationService();
    updateMyLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: markers,
      onMapCreated: (controller) {
        googleMapController = controller;
        updateMyLocation();
      },
      initialCameraPosition: initialCameraPosition,
    );
  }

  void updateMyLocation() async {
    var locationData = await locationService.getLocation();

    try {
      var myLocaton = LatLng(locationData.latitude!, locationData.longitude!);
      var cameraPosition = CameraPosition(target: myLocaton, zoom: 10);
      var myMarker = Marker(
        markerId: MarkerId('My location'),
        position: myLocaton,
      );
      markers.add(myMarker);
      setState(() {});
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
    } on LocationPermissionException catch (e) {
      // TODO
    } on LocationServiceException catch (e) {
      // TODO
    }
  }
}
