import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_test/models/place_model.dart';
import 'dart:ui' as ui;

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
      zoom: 5,
      target: LatLng(30.0444, 31.2357),
    );
    initMarkers();
    super.initState();
  }

  late GoogleMapController mapController;
  Set<Marker> markers = {};
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
            intitalizeMapStyle();
          },
          // cameraTargetBounds: CameraTargetBounds(
          //   LatLngBounds(
          //     southwest: LatLng(31.1860747481394, 31.4676724649157),
          //     northeast: LatLng(31.28735385986459, 31.605479137667256),
          //   ),
          // ),
          initialCameraPosition: initialCameraPosition,
        ),

        // Positioned(
        //   bottom: 20,
        //   right: 20,
        //   left: 20,
        //   child: ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: Colors.blue,
        //       foregroundColor: Colors.white,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //     ),
        //     onPressed: () {
        //       mapController.animateCamera(
        //         CameraUpdate.newLatLng(
        //           LatLng(31.0361588230587, 30.92684072019934),
        //         ),
        //       );
        //     },
        //     child: const Text('Locate Me'),
        //   ),
        // ),
      ],
    );
  }

  intitalizeMapStyle() async {
    var nightMap = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/map_styles/night_map_style.json');

    mapController.setMapStyle(nightMap);
  }

  Future<Uint8List> getIconBytes(String image, int width) async {
    var imageData = await rootBundle.load(image);

    var codecImage = await ui.instantiateImageCodec(
      imageData.buffer.asUint8List(),
      targetWidth: width,
    );
    var imageFrame = await codecImage.getNextFrame();
    var imgeByteDate = await imageFrame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return imgeByteDate!.buffer.asUint8List();
  }

  void initMarkers() async {
    var icon = BitmapDescriptor.bytes(
      await getIconBytes('assets/images/marker.png', 50),
    );

    // var icon = await BitmapDescriptor.asset(
    //   ImageConfiguration(),
    //   'assets/images/marker.png',
    // );
    var marker = places.map(
      (place) => Marker(
        icon: icon,
        infoWindow: InfoWindow(title: place.name),
        markerId: MarkerId(place.id.toString()),
        position: place.latLng,
      ),
    );
    markers.addAll(marker);
    setState(() {});
  }
}
