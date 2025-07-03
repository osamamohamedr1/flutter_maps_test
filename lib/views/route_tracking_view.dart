import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_test/utils/location_service.dart';
import 'package:google_maps_test/widgets/custom_text_field.dart';

class RouteTrackingView extends StatefulWidget {
  const RouteTrackingView({super.key});

  @override
  State<RouteTrackingView> createState() => _RouteTrackingViewState();
}

class _RouteTrackingViewState extends State<RouteTrackingView> {
  late CameraPosition initialCameraPosition;
  late LocationService locationService;
  late GoogleMapController googleMapController;
  late TextEditingController textEditingController;
  Set<Marker> markers = {};
  @override
  void initState() {
    textEditingController = TextEditingController();
    initialCameraPosition = CameraPosition(target: LatLng(0, 0));
    locationService = LocationService();
    updateMyLocation();
    textEditingController.addListener(() {
      log(textEditingController.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          markers: markers,
          onMapCreated: (controller) {
            googleMapController = controller;
            updateMyLocation();
          },
          initialCameraPosition: initialCameraPosition,
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: CustomTextField(textEditingController: textEditingController),
        ),
      ],
    );
  }

  void updateMyLocation() async {
    var locationData = await locationService.getLocation();

    try {
      var myLocation = LatLng(locationData.latitude!, locationData.longitude!);
      var cameraPosition = CameraPosition(target: myLocation, zoom: 10);
      var myMarker = Marker(
        markerId: MarkerId('My location'),
        position: myLocation,
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
