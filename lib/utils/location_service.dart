import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  //check if location enabled
  Future<bool> checkAndRequestLocationService() async {
    var isEnabled = await location.serviceEnabled();
    if (!isEnabled) {
      var isEnabled = await location.requestService();
      return isEnabled ? true : false;
    }
    return true;
  }

  //check permission
  Future<bool> checkAndRequestLocationPermission() async {
    var permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.deniedForever) {
      return false;
    }
    if (permissionStatus == PermissionStatus.denied) {
      var isGarnted = await location.requestPermission();
      return isGarnted == PermissionStatus.granted;
    }

    return true;
  }

  //
  Future<void> getLiveLocation(void Function(LocationData)? onData) async {
    location.changeSettings(distanceFilter: 2);
    location.onLocationChanged.listen(onData);
  }
}
