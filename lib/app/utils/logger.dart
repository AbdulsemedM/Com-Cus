import 'package:flutter/foundation.dart';

void appLog(Object? message) {
  if (kDebugMode) {
    // Only prints in debug mode
    print(message);
  }
}
