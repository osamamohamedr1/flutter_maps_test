import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late CameraPosition initialCameraPosition;
  @override
  void initState() {
    initialCameraPosition = CameraPosition(
      zoom: 10,
      target: LatLng(31.254757038716278, 31.543353972025066),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      cameraTargetBounds: CameraTargetBounds(
        LatLngBounds(
          southwest: LatLng(31.1860747481394, 31.4676724649157),
          northeast: LatLng(31.28735385986459, 31.605479137667256),
        ),
      ),
      initialCameraPosition: initialCameraPosition,
    );
  }
}
