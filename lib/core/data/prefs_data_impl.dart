import 'dart:convert';

import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/utils/token_refresh_util.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

enum PrefsKeys { user, userToken, auth, deliveryFee, userBusinessAcc }

@Injectable(as: PrefsData)
class PrefsDataImpl implements PrefsData {
  final FlutterSecureStorage flutterSecureStorage;
  final TokenRefreshUtil _tokenRefreshUtil = TokenRefreshUtil();

  PrefsDataImpl(this.flutterSecureStorage);

  @override
  Future<String?> readData(String key) async {
    if (await flutterSecureStorage.containsKey(key: key)) {
      final value = await flutterSecureStorage.read(key: key);

      // SECURITY: Validate JWT expiration for token keys
      if (key == PrefsKeys.userToken.name && value != null) {
        if (_isJwtExpired(value)) {
          // Attempt to refresh token before deleting
          final refreshSuccess = await _tokenRefreshUtil.refreshTokenIfNeeded();
          if (refreshSuccess) {
            // Token was refreshed, read the new token
            return await flutterSecureStorage.read(key: key);
          } else {
            // Refresh failed, delete token
            await deleteData(key);
            return null;
          }
        }
      }

      return value;
    } else {
      return null;
    }
  }

  /// SECURITY: Check if JWT token is expired
  bool _isJwtExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = json
          .decode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));

      final exp = payload['exp'];
      if (exp == null) return false;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true; // Treat parsing errors as expired
    }
  }

  @override
  Future writeData(String key, String data) async {
    await flutterSecureStorage.write(key: key, value: data);
  }

  @override
  Future<bool> contains(String key) async {
    return await flutterSecureStorage.containsKey(key: key);
  }

  @override
  Future deleteData(String key) async {
    await flutterSecureStorage.delete(key: key);
  }

  @override
  Future nuke() async {
    await flutterSecureStorage.deleteAll();
  }
}
