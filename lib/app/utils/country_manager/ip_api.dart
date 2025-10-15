import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:commercepal/app/utils/logger.dart';

Future<String?> getCountryFromIP() async {
  try {
    final response = await http.get(Uri.parse('http://ip-api.com/json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['countryCode']; // e.g., 'US'
    }
  } catch (e) {
    appLog('Error fetching country from IP: $e');
  }
  return null;
}
