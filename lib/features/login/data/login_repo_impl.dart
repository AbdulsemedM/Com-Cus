import 'dart:convert';

import 'package:commercepal/app/data/network/api_provider.dart';
import 'package:commercepal/app/data/network/end_points.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/core/models/auth_model.dart';
import 'package:commercepal/core/models/user_model.dart';
import 'package:commercepal/core/dto/Login_dto.dart';
import 'package:commercepal/core/utils/token_refresh_util.dart';
import 'package:commercepal/features/login/global_credential/global_credential.dart';
import 'package:injectable/injectable.dart';

import '../../../core/data/prefs_data.dart';
import '../domain/login_repository.dart';
import 'package:commercepal/app/utils/logger.dart';

@Injectable(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  final PrefsData prefsData;
  final ApiProvider apiProvider;
  final TokenRefreshUtil _tokenRefreshUtil = TokenRefreshUtil();

  LoginRepositoryImpl(this.prefsData, this.apiProvider);

  @override
  Future<AuthModel> login(String email, String pass) async {
    try {
      // SECURITY: Password logging removed to prevent exposure
      if (pass == "social media") {
        var decodedResponse = GlobalCredential.getGlobalString();
        appLog("Social media login response received");
        // SECURITY: Full response logging removed to prevent token exposure
        if (decodedResponse['statusCode'] == '000') {
          // store auth credentials
          appLog("credetial stored");
          if (decodedResponse['userToken'] != null) {
            await prefsData.writeData(
                PrefsKeys.userToken.name, decodedResponse['userToken']);
          }
          if (decodedResponse['refreshToken'] != null) {
            await prefsData.writeData(
                "refresh_token", decodedResponse['refreshToken']);
          }
          await prefsData.writeData(
              PrefsKeys.auth.name, jsonEncode(decodedResponse));

          appLog("this is for affiliate");
          // SECURITY: Full response logging removed to prevent token exposure

          // Check if token is expired and refresh if needed (safety check)
          if (decodedResponse['userToken'] != null) {
            final isExpired = await _tokenRefreshUtil.isTokenExpired();
            if (isExpired) {
              appLog("Token expired immediately after login, attempting refresh...");
              await _tokenRefreshUtil.refreshTokenIfNeeded();
            }
          }

          // get user details
          appLog("getting user detail");
          final userResponse = await apiProvider.get(EndPoints.userDetails.url);
          if (userResponse['statusCode'] == '000') {
            final uObj = UserModel.fromJson(userResponse);
            await prefsData.writeData(PrefsKeys.user.name, jsonEncode(uObj));

            // attach phone number
            decodedResponse['phoneNumber'] = uObj.details?.phoneNumber;
          } else {
            // clear token in case user is not found
            await prefsData.nuke();
            throw userResponse['statusDescription'] ??
                "Something went wrong please try again or contact our support team!";
          }

          return AuthModel.fromJson(decodedResponse);
        } else {
          throw decodedResponse['statusDescription'] ??
              "Something went wrong please try again or contact our support team!";
        }
      } else {
        final request = {"emailOrPhone": email, "password": pass};
        appLog("here is the request");

        final response = await apiProvider.post(request, EndPoints.login.url);
        // final decodedResponse = jsonDecode(response);

        if (response['statusCode'] == '000') {
          final responseObject = LoginDto.fromJson(response);

          // store auth credentials
          if (responseObject.userToken != null) {
            await prefsData.writeData(
                PrefsKeys.userToken.name, responseObject.userToken!);
          }
          appLog("here is the response");
          appLog(response.runtimeType);
          appLog("isithere");
          if (responseObject.refreshToken != null) {
            await prefsData.writeData(
                "refresh_token", responseObject.refreshToken!);
          }
          await prefsData.writeData(PrefsKeys.auth.name, jsonEncode(response));

          // Check if token is expired and refresh if needed (safety check)
          if (responseObject.userToken != null) {
            final isExpired = await _tokenRefreshUtil.isTokenExpired();
            if (isExpired) {
              appLog("Token expired immediately after login, attempting refresh...");
              await _tokenRefreshUtil.refreshTokenIfNeeded();
            }
          }

          // get user details
          appLog("here goes the login");
          final userResponse = await apiProvider.get(EndPoints.userDetails.url);
          if (userResponse['statusCode'] == '000') {
            final uObj = UserModel.fromJson(userResponse);
            await prefsData.writeData(PrefsKeys.user.name, jsonEncode(uObj));

            // attach phone number
            response['phoneNumber'] = uObj.details?.phoneNumber;
          } else {
            // clear token in case user is not found
            await prefsData.nuke();
            appLog(userResponse['statusMessage']);
            throw userResponse['statusMessage'] ??
                "Something went wrong please try again or contact our support team!";
          }

          return AuthModel.fromJson(response);
        } else {
          throw response['statusMessage'] ??
              "Something went wrong please try again or contact our support team!";
        }
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return await prefsData.contains(PrefsKeys.userToken.name);
  }
}
