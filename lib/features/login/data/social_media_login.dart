import "dart:convert";

import "package:commercepal/features/login/global_credential/global_credential.dart";
import "package:http/http.dart" as http;
import 'package:commercepal/app/utils/logger.dart';

Future<Map<String, dynamic>> getUserToken(
    String channel,
    String provider,
    String providerUserId,
    String email,
    String firstName,
    String lastName,
    String deviceId) async {
  try {
    Map<String, dynamic> request = {
      "channel": channel, // IOS, ANDROID, WEB
      "provider": provider, // GOOGLE or FACEBOOK
      "providerUserId": providerUserId, // google or facebook user id
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "deviceId": deviceId
    };
    appLog(request);
    final response = await http.post(
      Uri.https(
        "api.commercepal.com:2096",
        "/prime/api/v1/oauth2",
      ),
      body: jsonEncode(request),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
    );
    var data = jsonDecode(response.body);
    appLog("here we go agaiiina");
    appLog(data);
    GlobalCredential.setGlobalString(data);
    return data;
  } catch (e) {
    throw "Something went wrong please try again or contact our support team!";
  }
}
