import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:commercepal/app/app.dart';
import 'package:commercepal/app/utils/app_bloc_observer.dart';
import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  // Initialize OneSignal after Flutter is initialized
  await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  await OneSignal.shared.setAppId('c02d769f-6576-472a-8eb1-cd5d300e53b9');
  bool accepted =
      await OneSignal.shared.promptUserForPushNotificationPermission();
  print("Accepted Permission: $accepted");

  await configureInjection(Environment.prod);

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: Colors.white, // status bar color
    ));
  }

  String lang = await getStoredLang();
  GlobalStrings.setGlobalString(lang);

  // await translateStrings();

  Bloc.observer = AppBlocObserver();

  runApp(const App());
}
