import 'dart:io';

import 'package:commercepal/app/utils/country_manager/country_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:commercepal/app/app.dart';
import 'package:commercepal/app/utils/app_bloc_observer.dart';
import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/features/translation/get_lang.dart';
// import 'package:commercepal/features/translation/translation_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'services/firebase_messaging_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  Upgrader.clearSavedSettings();

  // Initialize OneSignal after Flutter is initialized
  await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  await OneSignal.shared.setAppId('c02d769f-6576-472a-8eb1-cd5d300e53b9');
  bool accepted =
      await OneSignal.shared.promptUserForPushNotificationPermission();
  print("Accepted Permission: $accepted");
  await Permission.notification.isDenied.then((isDenied) {
    if (isDenied) {
      Permission.notification.request();
    }
  });

  await configureInjection(Environment.prod);

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: Colors.white, // status bar color
    ));
  }
  final prefs = await SharedPreferences.getInstance();

  if (prefs.getBool('first_run') ?? true) {
    FlutterSecureStorage storage = FlutterSecureStorage();

    await storage.deleteAll();

    prefs.setBool('first_run', false);
  }
  String lang = await getStoredLang();
  GlobalStrings.setGlobalString(lang);
  final String? currentCountry = prefs.getString("currency");

  if (currentCountry == null) {
    final countryManager = CountryManager();
    await countryManager.fetchAndStoreCountry();
  }

  Bloc.observer = AppBlocObserver();

  await Firebase.initializeApp();
  if (Platform.isAndroid) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // Initialize messaging service
    final messagingService = await FirebaseMessaging.instance;
    await messagingService.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(const App());
}
