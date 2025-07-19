import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_test/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:google_maps_test/models/route_body/destination..dart';
import 'package:google_maps_test/models/route_body/lat_lng..dart';
import 'package:google_maps_test/models/route_body/location..dart';
import 'package:google_maps_test/models/route_body/origin..dart';
import 'package:google_maps_test/models/route_body/route_body..dart';
import 'package:google_maps_test/utils/google_maps_place_service.dart';
import 'package:google_maps_test/utils/location_service.dart';
import 'package:google_maps_test/utils/routes_service.dart';
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
  late PlacesService placesService;
  late LocationService locationService;
  late GoogleMapController googleMapController;
  late TextEditingController textEditingController;
  Set<Marker> markers = {};
  List<PlaceModel> places = [];
  String? sessionToken;
  late Uuid uuid;
  late LatLng myLocation;
  late LatLng destination;
  late RoutesService routesService;
  Set<Polyline> polylines = {};
  @override
  void initState() {
    uuid = Uuid();
    textEditingController = TextEditingController();
    initialCameraPosition = CameraPosition(target: LatLng(0, 0));
    locationService = LocationService();
    placesService = PlacesService();
    routesService = RoutesService();
    // updateMyLocation();
    fetchPredictions();
    super.initState();
  }

  void fetchPredictions() {
    textEditingController.addListener(() async {
      sessionToken ??= uuid.v4();
      if (textEditingController.text.isNotEmpty) {
        var result = await placesService.getPredictions(
          input: textEditingController.text,
          sesstionToken: 'sesstionToken',
        );

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
                placesService: placesService,
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
    var locationData = await locationService.getLocation();

    try {
      myLocation = LatLng(locationData.latitude!, locationData.longitude!);
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
      log(e.toString());
    } on LocationServiceException catch (e) {
      // TODO
      log(e.toString());
    }
  }

  Future<List<LatLng>> getRoutesData() async {
    final routeBody = RouteBody(
      origin: Origin(
        location: LocationModel(
          latLng: LatLngModel(
            latitude: myLocation.latitude,
            longitude: myLocation.longitude,
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

  //RoutesModel result
  List<LatLng> getDecodedRoute() {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> points = polylinePoints.decodePolyline(
      'cvs}Do`kvDff`Gcv`F',
      // result.routes!.first.polyline!.encodedPolyline!,
    );
    log(points.toString());
    return points.map((e) => LatLng(e.latitude, e.longitude)).toList();
  }

  void drawRoute(List<LatLng> points) {
    log('drawed');
    Polyline polyline = Polyline(
      color: Colors.black,
      width: 5,
      polylineId: PolylineId('route'),
      points: points,
    );
    polylines.add(polyline);
    LatLngBounds bounds = getLatLangBounds(points);
    googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 16));
    setState(() {});
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
