import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TestMapView extends StatefulWidget {
  const TestMapView({super.key});

  @override
  State<TestMapView> createState() => _TestMapViewState();
}

class _TestMapViewState extends State<TestMapView> {
  late CameraPosition initialCameraPosition;
  @override
  void initState() {
    initialCameraPosition = CameraPosition(
      target: LatLng(31.2156, 29.9553),
      zoom: 11,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(initialCameraPosition: initialCameraPosition);
  }
}
