import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:flutter/services.dart';

Future<String> getReferralLink() async {
  try {
    final referrer = await AndroidPlayInstallReferrer.installReferrer;
    final utmParams = referrer.installReferrer; // Get the install referrer
    print(referrer.installReferrer);
    print(utmParams);

    // Replace 'YOUR_APP_ID' with your actual app's package name
    final playStoreLink =
        'https://play.google.com/store/apps/details?id=com.commercepal.commercepal&${referrer.installReferrer}';

    // Append the utmParams to your Play Store link
    final referralLink = '$playStoreLink&userId=2397883';
    // final referralLink = '$playStoreLink&$utmParams';
    Map<String, String> queryParams =
        Uri.parse(playStoreLink).queryParameters; // returns Map<String, String>
    // Get the `utm_content` parameter.
    String? utmContent = queryParams["utm_content"];
    print("hereee");
    print(utmContent);
    print(referralLink);

    return referralLink;
  } on PlatformException catch (e) {
    print('Failed to retrieve install referrer: $e');
    return "null";
  }
}
