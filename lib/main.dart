import 'package:flutter/material.dart';
import 'package:google_maps_test/views/my_location_tracker.dart';

void main() {
  runApp(const GoogleMapsTest());
}

class GoogleMapsTest extends StatelessWidget {
  const GoogleMapsTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google Maps',
      home: Scaffold(body: MyLocationTracker()),
    );
  }
}
