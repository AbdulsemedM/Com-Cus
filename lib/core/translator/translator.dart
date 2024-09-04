import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:flutter/material.dart';
import 'package:google_translate/google_translate.dart';
import 'package:http/http.dart' as http;

Future<String> translateText(text, sourceLanguage, targetLanguage) async {
  print(text);

  GoogleTranslate googleTranslate = GoogleTranslate();
  final String result = await googleTranslate.translate(
    text,
    sourceLanguage: sourceLanguage,
    targetLanguage: targetLanguage,
  );
  print(result);
  return result;
}

Future<String> fetchUser1({int retryCount = 0, BuildContext? context}) async {
  try {
    // setState(() {
    //   loading = true;
    // });
    final prefsData = getIt<PrefsData>();
    final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
    if (isUserLoggedIn) {
      final token = await prefsData.readData(PrefsKeys.userToken.name);
      final response = await http.get(
        Uri.https(
          "api.commercepal.com:2096",
          "prime/api/v1/get-details",
          {"userType": "BUSINESS"},
        ),
        headers: <String, String>{"Authorization": "Bearer $token"},
      );

      var data = jsonDecode(response.body);
      print(data);

      if (data['statusCode'] == '000') {
        // Handle the case when statusCode is '000'
        // setState(() {
        //   loading = false;
        // });
        return "login";
      } else {
        final prefsData = getIt<PrefsData>();
        await prefsData.deleteData(PrefsKeys.userToken.name);
        return "logout";
      }
    }
    return "logout";
  } catch (e) {
    print(e.toString());
    // setState(() {
    //   loading = false;
    // });
    return "logout";
    // Handle other exceptions
  }
}
