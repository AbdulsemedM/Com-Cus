import 'package:commercepal/app/utils/country_manager/get_country.dart';
import 'package:commercepal/app/utils/country_manager/ip_api.dart';
import 'package:commercepal/app/utils/country_manager/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountryManager {
  static const String _defaultCountry = 'US';
  static const String _countryKey = 'country';
  static const String _currencyKey = 'currency';
  String? _country;

  /// Getter for the current country.
  String get country => _country ?? _defaultCountry;

  /// Load the country from SharedPreferences.
  Future<void> loadCountryFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _country = prefs.getString(_countryKey) ?? _defaultCountry;
    // Set currency based on country
    final currency = _country == 'ET'
        ? 'ETB'
        : _country == "AE"
            ? "AED"
            : _country == "KE"
                ? "KES"
                : _country == "SO"
                    ? "SOS"
                    : 'USD';
    await prefs.setString(_currencyKey, currency);
    print(
        "Loaded country from preferences: $_country with currency: $currency");
  }

  /// Fetch the country and update the stored value.
  Future<void> fetchAndStoreCountry() async {
    try {
      String? country;

      // Attempt to get location-based country
      Position? position = await getUserLocation();
      if (position != null) {
        country = await getCountryUsingNominatim();
        print("Country from Nominatim: $country");
      }

      // Fallback to IP-based country
      if (country == null) {
        print("Falling back to IP-based geolocation...");
        country = await getCountryFromIP();
        print("Country from IP: $country");
      }

      // Fallback to default country if all else fails
      country ??= _defaultCountry;
      print("Country fallback: $country");

      // Update in-memory and persistent storage
      _country = country;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_countryKey, country);

      // Set currency based on country
      final currency = country == 'ET'
          ? 'ETB'
          : country == "AE"
              ? "AED"
              : 'USD';
      await prefs.setString(_currencyKey, currency);
      print("Stored currency: $currency");
    } catch (e) {
      print("Error fetching country: $e");
    }
  }
}
