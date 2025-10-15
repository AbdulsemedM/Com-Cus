import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:commercepal/app/data/network/api_provider.dart';
import 'package:commercepal/app/data/network/end_points.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/core/device-info/device_info.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/data/prefs_data.dart';
import '../../../core/models/user_model.dart';
import '../../../core/dto/Login_dto.dart';
import '../domain/user_registration_repo.dart';
import 'package:commercepal/app/utils/logger.dart';

@Injectable(as: UserRegistrationRepo)
class UserRegistrationRepoImpl implements UserRegistrationRepo {
  final ApiProvider apiProvider;
  final DeviceInfo deviceInfo;
  final PrefsData prefsData;

  UserRegistrationRepoImpl(this.apiProvider, this.deviceInfo, this.prefsData);

  @override
  Future<bool> userExists(String emailOrPhone) async {
    try {
      final payLoad = {"user": emailOrPhone};

      final response =
          await apiProvider.post(payLoad, EndPoints.userExists.url);
      final objResponse = jsonDecode(response);
      // return true if user does not exist
      return objResponse['statusCode'] != '000';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> registerUser(
      String fName,
      String sName,
      String phoneNumber,
      String country,
      String city,
      String? email,
      String? countryCode,
      String? password,
      String? confirmPassword) async {
    try {
      // check if user exists
      // final userResponse = await userExists(phoneNumber);
      // if (!userResponse) {
      //   throw "User exists";
      // }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? referrer = prefs.getString("referrer");
      final deviceData = await deviceInfo.getDeviceInfo();
      // final payload = referrer == null
      //     ? {
      //         "msisdn": phoneNumber,
      //         "firstName": fName,
      //         "lastName": sName,
      //         "email": email ?? '$phoneNumber@gmail.com',
      //         "city": city,
      //         "country": country,
      //         "language": "en",
      //         "registeredBy": "self",
      //         "channel": deviceData.name,
      //         "deviceId": deviceData.deviceId
      //       }
      //     : {
      //         "msisdn": phoneNumber,
      //         "firstName": fName,
      //         "lastName": sName,
      //         "email": email ?? '$phoneNumber@gmail.com',
      //         "city": city,
      //         "country": country,
      //         "language": "en",
      //         "registeredBy": "self",
      //         "channel": deviceData.name,
      //         "deviceId": deviceData.deviceId,
      //         "referralCode": referrer
      //       };
      final payload = {
        "country": country,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "firstName": fName,
        "lastName": sName,
        "countryCode": countryCode,
        "phoneNumber": phoneNumber == "" ? null : phoneNumber,
        "registrationChannel": Platform.isAndroid
            ? 'ANDROID'
            : Platform.isIOS
                ? 'IOS'
                : 'Unknown',
        "deviceId": await getDeviceId()
      };
      // if (phoneNumber == "") {
      //   payload.remove("phoneNumber");
      // }
      if (referrer != null) {
        prefs.remove("referrer");
      }
      appLog("the payload");
      appLog(payload);
      final response = await http.post(
        Uri.https("api.commercepal.com", "/api/v2/customers/register"),
        body: jsonEncode(payload), // convert Dart map to JSON string
        headers: {
          'Content-Type': 'application/json',
        },
      );

      appLog(response.body);
      //  await http.post(
      //     Uri.parse("https://api.commercepal.com/api/v2/customers/register"),
      //   body: payload,
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      // );
      appLog(response.body);
      // await apiProvider.post(payload, EndPoints.registration.url);
      final objResponse = jsonDecode(response.body);
      // appLog(objResponse.runtimeType);
      if (objResponse['statusCode'] == '000') {
        appLog(objResponse['statusMessage']);
        return objResponse['statusMessage'];
      } else {
        throw objResponse['statusMessage'] ??
            "Something went wrong please try again or contact our support team!";
      }
    } catch (e) {
      appLog(e.toString());
      throw "Something went wrong please try again or contact our support team!";
    }
  }

  Future<String?> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // or androidInfo.androidId
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    } else {
      return null;
    }
  }
}
