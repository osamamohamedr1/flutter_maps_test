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
      zoom: 11,
      target: LatLng(31.2156, 29.9553),
    );
    initMarkers();
    initPolyLines();
    initPolygons();
    super.initState();
  }

  late GoogleMapController mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  Set<Polygon> polygons = {};
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          zoomControlsEnabled: false,
          polygons: polygons,
          polylines: polylines,
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

  // use this method if you get marker form api and its size not correct
  // but if you have access to image adjust its size by any toll and not use this method as it takes time
  Future<Uint8List> getIconBytes(String image, int width) async {
    //load image as bytes
    var imageData = await rootBundle.load(image);
    //convet it to Uint8List to change width
    var codecImage = await ui.instantiateImageCodec(
      imageData.buffer.asUint8List(),
      targetWidth: width,
    );
    // get image frame
    var imageFrame = await codecImage.getNextFrame();
    // adjust imge format to png
    var imgeByteDate = await imageFrame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    // return image as Uint8List
    return imgeByteDate!.buffer.asUint8List();
  }

  void initMarkers() async {
    // var icon = BitmapDescriptor.bytes(
    //   await getIconBytes('assets/images/marker.png', 20),
    // );

    var icon = await BitmapDescriptor.asset(
      ImageConfiguration(),
      'assets/images/marker.png',
    );
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

  void initPolyLines() {
    Polyline polyLine = Polyline(
      color: Colors.amber,
      endCap: Cap.roundCap,
      zIndex: 1,
      width: 3,
      polylineId: PolylineId('1'),
      points: [
        LatLng(31.25320304319797, 29.983311819285383),
        LatLng(31.18976038445989, 30.010545093514246),
        LatLng(31.18132492732671, 29.909594163183122),
      ],
    );
    Polyline polyLine1 = Polyline(
      geodesic: true,
      color: Colors.black,
      endCap: Cap.roundCap,
      width: 4,
      polylineId: PolylineId('2'),
      points: [
        LatLng(31.14596817199962, 30.01571002483351),
        LatLng(31.21144810768513, 29.92837573161682),
      ],
    );
    polylines.add(polyLine1);
    polylines.add(polyLine);
  }

  void initPolygons() {
    Polygon polygon = Polygon(
      holes: [
        [
          // dimensions of hole that must be located inside the polygun
        ],
      ],
      polygonId: PolygonId('1'),
      fillColor: Colors.black45,
      strokeWidth: 2,
      points: [
        LatLng(31.211028556866843, 29.881688732172954),
        LatLng(31.264556296232755, 29.994479240614535),
        LatLng(31.264556296232755, 29.994479240614535),
        LatLng(31.224302724748142, 29.997066178881546),
      ],
    );
    polygons.add(polygon);
  }
}
