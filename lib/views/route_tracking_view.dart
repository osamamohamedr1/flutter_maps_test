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
  GoogleMapController? googleMapController;
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
      onMapCreated: (controller) {
        googleMapController = controller;
      },
      initialCameraPosition: initialCameraPosition,
    );
  }

  void updateMyLocation() async {
    locationService.getLiveLocation((location) {
      googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 10,
            target: LatLng(location.altitude!, location.longitude!),
          ),
        ),
      );
    });
    // await locationService.checkAndRequestLocationService();
    // var hasPermission =
    //     await locationService.checkAndRequestLocationPermission();
    // if (hasPermission) {
    //   locationService.getLiveLocation((location) {
    //     googleMapController?.animateCamera(
    //       CameraUpdate.newCameraPosition(
    //         CameraPosition(
    //           zoom: 10,
    //           target: LatLng(location.altitude!, location.longitude!),
    //         ),
    //       ),
    //     );
    //   });
    // }
  }
}
