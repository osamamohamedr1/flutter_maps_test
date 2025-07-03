import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_test/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:google_maps_test/utils/google_maps_place_service.dart';
import 'package:google_maps_test/utils/location_service.dart';
import 'package:google_maps_test/widgets/custom_text_field.dart';
import 'package:google_maps_test/widgets/predections_list_view.dart';

class RouteTrackingView extends StatefulWidget {
  const RouteTrackingView({super.key});

  @override
  State<RouteTrackingView> createState() => _RouteTrackingViewState();
}

class _RouteTrackingViewState extends State<RouteTrackingView> {
  late CameraPosition initialCameraPosition;
  late PlacesService placesService;
  late LocationService locationService;
  late GoogleMapController googleMapController;
  late TextEditingController textEditingController;
  Set<Marker> markers = {};
  List<PlaceModel> places = [];
  @override
  void initState() {
    textEditingController = TextEditingController();
    initialCameraPosition = CameraPosition(target: LatLng(0, 0));
    locationService = LocationService();
    placesService = PlacesService();
    updateMyLocation();
    fetchPredictions();
    super.initState();
  }

  void fetchPredictions() {
    textEditingController.addListener(() async {
      if (textEditingController.text.isNotEmpty) {
        log(textEditingController.text);
        var result = await placesService.getPredictions(
          input: textEditingController.text,
          sesstionToken: 'sesstionToken',
        );
        log(textEditingController.text);
        log(places.length.toString());
        places.clear();
        places.addAll(result);
        setState(() {});
      } else {
        places.clear();
        setState(() {});
      }
    });
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
          child: Column(
            spacing: 16,
            children: [
              CustomTextField(textEditingController: textEditingController),

              PredictionsListView(places: places),
            ],
          ),
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
