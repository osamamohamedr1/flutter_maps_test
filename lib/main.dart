import 'package:flutter/material.dart';

void main() {
  runApp(const GoogleMapsTest());
}

class GoogleMapsTest extends StatelessWidget {
  const GoogleMapsTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps',
      home: Scaffold(
        appBar: AppBar(title: const Text('Google Maps')),
        body: const Center(child: Text('Google Maps will be displayed here.')),
      ),
    );
  }
}
