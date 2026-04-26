import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<bool> requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      return true;
    } else {
      status = await Permission.locationAlways.request();
      return status.isGranted;
    }
  }

  Future<Position?> getCurrentPosition() async {
    bool isGranted =
        await Permission.location.isGranted || await Permission.locationAlways.isGranted;
    if (!isGranted) {
      isGranted = await requestPermission();
    }
    if (isGranted) {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    }
    return null;
  }

  Stream<Position> get positionStream {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }
}
