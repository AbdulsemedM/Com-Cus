import 'package:shared_preferences/shared_preferences.dart';

Future<String> getStoredLang() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("lang") ?? 'en';
}

class GlobalStrings {
  static String _globalString = "en";

  static void setGlobalString(String value) {
    _globalString = value;
    print("set Success");
  }

  static String getGlobalString() {
    return _globalString;
  }
}
