import 'dart:convert';

import 'package:commercepal/core/data/prefs_data_impl.dart';

import '../data/prefs_data.dart';

AuthModel authModelFromJson(String str) => AuthModel.fromJson(json.decode(str));

String authModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  AuthModel({
    String? userToken,
    this.isPhoneValidated,
    this.isEmailProvided,
    this.isEmailValidated,
    num? changePin,
    String? refreshToken,
    String? phoneNumber,
    num? isPhoneProvided,
    // num? isEmailProvided,
  }) {
    _userToken = userToken;
    _changePin = changePin;
    _refreshToken = refreshToken;
    _phoneNumber = phoneNumber;
    isPhoneProvided = isPhoneProvided;
    isPhoneProvided = isEmailProvided;
  }

  AuthModel.fromJson(dynamic json) {
    _userToken = json['userToken'];
    isPhoneValidated = json['isPhoneValidated'];
    isEmailValidated = json['isEmailValidated'];
    _changePin = json['changePin'];
    _refreshToken = json['refreshToken'];
    _refreshToken = json['refreshToken'];
    isPhoneProvided = json['isPhoneProvided'];
    isEmailProvided = json['isEmailProvided'];
    if (json['phoneNumber'] != null) _phoneNumber = json['phoneNumber'];
  }

  String? _userToken;
  num? isPhoneValidated;
  num? isEmailValidated;
  num? _changePin;
  String? _refreshToken;
  String? _phoneNumber;
  num? isPhoneProvided;
  num? isEmailProvided;

  AuthModel copyWith({
    String? userToken,
    num? isPhoneValidated,
    num? isEmailValidated,
    num? changePin,
    String? refreshToken,
    num? isPhoneProvided,
    num? isEmailProvided,
  }) =>
      AuthModel(
        userToken: userToken ?? _userToken,
        isPhoneValidated: isPhoneValidated ?? this.isPhoneValidated,
        isEmailValidated: isEmailValidated ?? this.isEmailValidated,
        changePin: changePin ?? _changePin,
        refreshToken: refreshToken ?? _refreshToken,
        isPhoneProvided: isPhoneProvided ?? isPhoneProvided,
        isEmailProvided: isEmailProvided ?? isEmailProvided,
      );

  String? get userToken => _userToken;

  num? get changePin => _changePin;

  String? get refreshToken => _refreshToken;

  String? get phoneNumber => _phoneNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userToken'] = _userToken;
    map['isPhoneValidated'] = isPhoneValidated;
    map['isEmailValidated'] = isEmailValidated;
    map['changePin'] = _changePin;
    map['refreshToken'] = _refreshToken;
    map['phoneNumber'] = _phoneNumber;
    return map;
  }

  static Future<AuthModel?> getAuthStatus(PrefsData prefsData) async {
    final authModel = await prefsData.readData(PrefsKeys.auth.name);
    if (authModel == null) return null;
    return authModelFromJson(authModel);
  }
}
