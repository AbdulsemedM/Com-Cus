import 'dart:convert';

import 'package:commercepal/app/data/network/api_provider.dart';
import 'package:commercepal/app/data/network/end_points.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/core/models/auth_model.dart';
import 'package:commercepal/core/models/user_model.dart';
import 'package:commercepal/core/dto/Login_dto.dart';
import 'package:commercepal/features/login/global_credential/global_credential.dart';
import 'package:injectable/injectable.dart';

import '../../../core/data/prefs_data.dart';
import '../domain/login_repository.dart';

@Injectable(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  final PrefsData prefsData;
  final ApiProvider apiProvider;

  LoginRepositoryImpl(this.prefsData, this.apiProvider);

  @override
  Future<AuthModel> login(String email, String pass) async {
    try {
      print(pass);
      if (pass == "social media") {
        var decodedResponse = GlobalCredential.getGlobalString();
        // final decodedResponse = jsonDecode(response);
        if (decodedResponse['statusCode'] == '000') {
          final responseObject = LoginDto.fromJson(decodedResponse);

          // store auth credentials
          print("credetial stored");
          await prefsData.writeData(
              PrefsKeys.userToken.name, responseObject.userToken!);
          await prefsData.writeData(
              "refresh_token", responseObject.refreshToken!);
          await prefsData.writeData(
              PrefsKeys.auth.name, jsonEncode(decodedResponse));

          // get user details
          print("getting user detail");
          final userResponse = await apiProvider.get(EndPoints.userDetails.url);
          if (userResponse['statusCode'] == '000') {
            final uObj = UserModel.fromJson(userResponse);
            await prefsData.writeData(PrefsKeys.user.name, jsonEncode(uObj));

            // attach phone number
            decodedResponse['phoneNumber'] = uObj.details?.phoneNumber;
          } else {
            // clear token in case user is not found
            await prefsData.nuke();
            throw userResponse['statusDescription'];
          }

          return AuthModel.fromJson(decodedResponse);
        } else {
          throw decodedResponse['statusDescription'];
        }
      } else {
        final request = {"email": email, "password": pass};
        final response = await apiProvider.post(request, EndPoints.login.url);
        final decodedResponse = jsonDecode(response);
        if (decodedResponse['statusCode'] == '000') {
          final responseObject = LoginDto.fromJson(decodedResponse);

          // store auth credentials
          await prefsData.writeData(
              PrefsKeys.userToken.name, responseObject.userToken!);
          await prefsData.writeData(
              "refresh_token", responseObject.refreshToken!);
          await prefsData.writeData(PrefsKeys.auth.name, response);

          // get user details
          final userResponse = await apiProvider.get(EndPoints.userDetails.url);
          if (userResponse['statusCode'] == '000') {
            final uObj = UserModel.fromJson(userResponse);
            await prefsData.writeData(PrefsKeys.user.name, jsonEncode(uObj));

            // attach phone number
            decodedResponse['phoneNumber'] = uObj.details?.phoneNumber;
          } else {
            // clear token in case user is not found
            await prefsData.nuke();
            throw userResponse['statusDescription'];
          }

          return AuthModel.fromJson(decodedResponse);
        } else {
          throw decodedResponse['statusDescription'];
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return await prefsData.contains(PrefsKeys.userToken.name);
  }
}
