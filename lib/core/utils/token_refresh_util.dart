import 'dart:async';
import 'dart:convert';

import 'package:commercepal/app/data/network/api_provider.dart';
import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/core/dto/Login_dto.dart';
import 'package:commercepal/app/utils/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenRefreshUtil {
  static final TokenRefreshUtil _instance = TokenRefreshUtil._internal();
  factory TokenRefreshUtil() => _instance;
  TokenRefreshUtil._internal();

  // Lazy-load dependencies to avoid circular dependency issues
  PrefsData get _prefsData => getIt<PrefsData>();
  ApiProvider get _apiProvider => getIt<ApiProvider>();
  
  // Thread-safety: prevent concurrent refresh attempts
  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;

  /// Check if JWT token is expired
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

  /// Refresh token if expired. Returns true if token is valid (either was valid or was refreshed successfully)
  /// Returns false if refresh failed or refresh token is missing
  Future<bool> refreshTokenIfNeeded() async {
    try {
      // Check if user token exists
      final hasToken = await _prefsData.contains(PrefsKeys.userToken.name);
      if (!hasToken) {
        return false;
      }

      // Read token directly from storage to avoid recursion (bypassing PrefsDataImpl's refresh logic)
      final storage = getIt<FlutterSecureStorage>();
      final tokenValue = await storage.read(key: PrefsKeys.userToken.name);
      if (tokenValue == null) {
        return false;
      }

      // Check if token is expired
      if (!_isJwtExpired(tokenValue)) {
        return true; // Token is still valid
      }

      // Token is expired, need to refresh
      appLog("Token expired, attempting to refresh...");

      // If already refreshing, wait for that to complete
      if (_isRefreshing && _refreshCompleter != null) {
        return await _refreshCompleter!.future;
      }

      // Start refresh process
      _isRefreshing = true;
      _refreshCompleter = Completer<bool>();

      try {
        // Get refresh token directly from storage to avoid recursion
        final storage = getIt<FlutterSecureStorage>();
        final refreshTokenValue = await storage.read(key: "refresh_token");
        if (refreshTokenValue == null || refreshTokenValue.isEmpty) {
          appLog("Refresh token not found, clearing auth data");
          await _prefsData.deleteData(PrefsKeys.userToken.name);
          _refreshCompleter!.complete(false);
          return false;
        }

        // Call refresh API
        final response = await _apiProvider.refreshToken();

        // Check if response is successful
        if (response['statusCode'] == '000') {
          final responseObject = LoginDto.fromJson(response);

          // Update tokens
          if (responseObject.userToken != null) {
            await _prefsData.writeData(
                PrefsKeys.userToken.name, responseObject.userToken!);
          }

          if (responseObject.refreshToken != null) {
            await _prefsData.writeData(
                "refresh_token", responseObject.refreshToken!);
          }

          // Update auth data
          await _prefsData.writeData(PrefsKeys.auth.name, jsonEncode(response));

          appLog("Token refreshed successfully");
          _refreshCompleter!.complete(true);
          return true;
        } else {
          appLog("Token refresh failed: ${response['statusMessage'] ?? 'Unknown error'}");
          // Clear auth data on refresh failure
          await _prefsData.deleteData(PrefsKeys.userToken.name);
          await _prefsData.deleteData("refresh_token");
          _refreshCompleter!.complete(false);
          return false;
        }
      } catch (e) {
        appLog("Token refresh error: $e");
        // Clear auth data on error
        await _prefsData.deleteData(PrefsKeys.userToken.name);
        await _prefsData.deleteData("refresh_token");
        _refreshCompleter!.complete(false);
        return false;
      } finally {
        _isRefreshing = false;
        _refreshCompleter = null;
      }
    } catch (e) {
      appLog("Error in refreshTokenIfNeeded: $e");
      _isRefreshing = false;
      _refreshCompleter = null;
      return false;
    }
  }

  /// Check if token is expired (without refreshing)
  Future<bool> isTokenExpired() async {
    try {
      final hasToken = await _prefsData.contains(PrefsKeys.userToken.name);
      if (!hasToken) {
        return true;
      }

      // Read token directly from storage to avoid recursion
      final storage = getIt<FlutterSecureStorage>();
      final tokenValue = await storage.read(key: PrefsKeys.userToken.name);
      if (tokenValue == null) {
        return true;
      }

      return _isJwtExpired(tokenValue);
    } catch (e) {
      return true;
    }
  }
}

