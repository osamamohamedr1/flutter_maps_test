import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  //check if location enabled
  Future<void> checkAndRequestLocationService() async {
    var isEnabled = await location.serviceEnabled();
    if (!isEnabled) {
      var isEnabled = await location.requestService();
      if (!isEnabled) {
        throw LocationServiceException();
      }
    }
  }

  //check permission
  Future<void> checkAndRequestLocationPermission() async {
    var permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.deniedForever) {
      throw LocationPermissionException();
    }
    if (permissionStatus == PermissionStatus.denied) {
      var isGarnted = await location.requestPermission();
      if (isGarnted != PermissionStatus.granted) {
        throw LocationPermissionException();
      }
    }
  }

  //
  Future<void> getLiveLocation(void Function(LocationData)? onData) async {
    location.changeSettings(distanceFilter: 2);
    await checkAndRequestLocationService();
    await checkAndRequestLocationPermission();
    location.onLocationChanged.listen(onData);
  }

  Future<LocationData> getLocation() async {
    await checkAndRequestLocationService();
    await checkAndRequestLocationPermission();
    return await location.getLocation();
  }
}

class LocationServiceException implements Exception {}

class LocationPermissionException implements Exception {}
