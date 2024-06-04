import 'dart:io';

import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:flutter/services.dart';

Future<String> getReferralLink() async {
  final String userId = "12345";
  if (Platform.isAndroid) {
    String myReferrer =
        "https://play.google.com/store/apps/details?id=com.commercepal.commercepal&referrer=$userId";
    return myReferrer;
  } else if (Platform.isIOS) {
    String myReferrer =
        'https://apps.apple.com/us/app/commercepal/id1669974212?$userId=$userId';
    return myReferrer;
  }
  return "https://play.google.com/store/apps/details?id=com.commercepal.commercepal&referrer=$userId";

  // try {

  // final referrer = await AndroidPlayInstallReferrer.installReferrer;
  // final utmParams = referrer.installReferrer; // Get the install referrer
  // print(referrer.installReferrer);
  // print(utmParams);
  // final String userId = '2397883';
  // // Replace 'YOUR_APP_ID' with your actual app's package name
  // final playStoreLink =
  //     'https://play.google.com/store/apps/details?id=com.commercepal.commercepal&${referrer.installReferrer}';
  // Uri uri = Uri.parse(playStoreLink);
  // Map<String, String> queryParams = Map.from(uri.queryParameters);
  // queryParams['utm_content'] = userId;

  // // Reconstruct the URI with updated parameters
  // final updatedUri = uri.replace(queryParameters: queryParams);
  // Uri uri1 = Uri.parse(updatedUri.toString());

  // // Extract the query parameters
  // Map<String, String> queryParams1 = uri1.queryParameters;

  // // Construct the referrer parameter string by encoding the query parameters
  // String referrer1 = queryParams1.entries
  //     .map((e) =>
  //         '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
  //     .join('&');

  // // Create the new URL with the referrer parameter
  // String newUrl =
  //     'https://play.google.com/store/apps/details?id=com.commercepal.commercepal&referrer=$referrer1';

  // print(newUrl);
  // // Append the utmParams to your Play Store link
  // final referralLink = '$playStoreLink&userId=2397883';
  // // final referralLink = '$playStoreLink&$utmParams';
  // Map<String, String> queryParams =
  //     Uri.parse(playStoreLink).queryParameters; // returns Map<String, String>
  // // Get the `utm_content` parameter.
  // String? utmContent = queryParams["utm_content"];
  // print("hereee");
  // print(utmContent);
  // print(referralLink);
  // print(updatedUri.toString());
  // return updatedUri.toString();
  // } on PlatformException catch (e) {
  //   print('Failed to retrieve install referrer: $e');
  //   return "null";
  // }
}
