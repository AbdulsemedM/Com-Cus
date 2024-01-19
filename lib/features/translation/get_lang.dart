import 'package:shared_preferences/shared_preferences.dart';

Future<String> getStoredLang() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("lang") ?? 'en';
}

class GlobalStrings {
  // Declare a static variable
  static String _globalString = "en";

  // Setter method to update the global string
  static void setGlobalString(String value) {
    _globalString = value;
    print("set Success");
  }

  // Getter method to retrieve the global string
  static String getGlobalString() {
    return _globalString;
  }
}
