import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_test/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:google_maps_test/utils/google_map_service.dart';
import 'package:google_maps_test/utils/location_service.dart';
import 'package:google_maps_test/widgets/custom_text_field.dart';
import 'package:google_maps_test/widgets/predections_list_view.dart';
import 'package:uuid/uuid.dart';

class RouteTrackingView extends StatefulWidget {
  const RouteTrackingView({super.key});

  @override
  State<RouteTrackingView> createState() => _RouteTrackingViewState();
}

class _RouteTrackingViewState extends State<RouteTrackingView> {
  late CameraPosition initialCameraPosition;
  late GoogleMapService googleMapService;
  late GoogleMapController googleMapController;
  late TextEditingController textEditingController;
  Set<Marker> markers = {};
  List<PlaceModel> places = [];
  String? sessionToken;
  late Uuid uuid;
  late LatLng myLocation;
  late LatLng destination;

  Set<Polyline> polylines = {};
  @override
  void initState() {
    uuid = Uuid();
    textEditingController = TextEditingController();
    initialCameraPosition = CameraPosition(target: LatLng(0, 0));
    googleMapService = GoogleMapService();
    // updateMyLocation();
    fetchPredictions();
    super.initState();
  }

  void fetchPredictions() {
    textEditingController.addListener(() async {
      sessionToken ??= uuid.v4();
      await googleMapService.getPredictions(
        input: textEditingController.text,
        sesstionToken: sessionToken!,
        places: places,
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          polylines: polylines,
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

              PredictionsListView(
                places: places,
                googleMapService: googleMapService,
                onplaceSelected: (placeDetailsModel) async {
                  textEditingController.clear();
                  places.clear();
                  sessionToken = null;
                  destination = LatLng(
                    placeDetailsModel.geometry!.location!.lat!,
                    placeDetailsModel.geometry!.location!.lng!,
                  );

                  var points = await getRoutesData();
                  drawRoute(points);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void updateMyLocation() async {
    try {
      myLocation = await googleMapService.updateMyLocation(
        markers: markers,
        googleMapController: googleMapController,
      );
    } on LocationPermissionException catch (e) {
      // TODO
      log(e.toString());
    } on LocationServiceException catch (e) {
      // TODO
      log(e.toString());
    }
  }

  Future<List<LatLng>> getRoutesData() async {
    // ignore: unused_local_variable
    var result = await googleMapService.getRoutesData(
      destination: destination,
      myLocation: myLocation,
    );

    // decode route take result
    return googleMapService.getDecodedRoute();
  }

  void drawRoute(List<LatLng> points) {
    googleMapService.drawRoute(
      points: points,
      googleMapController: googleMapController,
      polylines: polylines,
    );
    setState(() {});
  }
}
