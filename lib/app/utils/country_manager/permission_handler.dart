import 'package:geolocator/geolocator.dart';
import 'package:commercepal/app/utils/logger.dart';

Future<Position?> getUserLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    appLog('Location services are disabled.');
    return null; // Location services disabled
  }

  // Check for location permissions
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      appLog('Location permissions are denied.');
      return null; // Permissions denied
    }
  }

  if (permission == LocationPermission.deniedForever) {
    appLog('Location permissions are permanently denied.');
    return null; // Permissions permanently denied
  }

  // Get the current position
  return await Geolocator.getCurrentPosition();
}
