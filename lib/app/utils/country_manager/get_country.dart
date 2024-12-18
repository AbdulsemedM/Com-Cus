import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String?> getCountryUsingNominatim() async {
  try {
    // Get user's current location
    Position position = await Geolocator.getCurrentPosition();
    final latitude = position.latitude;
    final longitude = position.longitude;

    // Nominatim API URL
    final url =
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$latitude&lon=$longitude';

    // API call
    final response = await http.get(Uri.parse(url), headers: {
      'User-Agent': 'FlutterApp', // Required by Nominatim
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['address']['country_code'].toUpperCase(); // e.g., 'US'
    }
  } catch (e) {
    print('Error fetching country: $e');
  }
  return null;
}
