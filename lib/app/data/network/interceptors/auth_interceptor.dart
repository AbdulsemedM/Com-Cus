import 'dart:convert';
import 'dart:developer';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/core/utils/token_refresh_util.dart';
import 'package:dio/dio.dart';


class AuthInterceptor extends Interceptor {
  final TokenRefreshUtil _tokenRefreshUtil = TokenRefreshUtil();

  @override
  void onRequest(RequestOptions options,
      RequestInterceptorHandler handler) async {
    final prefsData = getIt<PrefsData>();
    final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
    if (isUserLoggedIn) {
      // Check if token is expired and refresh if needed
      final isExpired = await _tokenRefreshUtil.isTokenExpired();
      if (isExpired) {
        // Attempt to refresh token
        final refreshSuccess = await _tokenRefreshUtil.refreshTokenIfNeeded();
        if (!refreshSuccess) {
          // Refresh failed, proceed without token (request will likely fail with 401)
          super.onRequest(options, handler);
          return;
        }
      }
      
      final token = await prefsData.readData(PrefsKeys.userToken.name);
      if (token != null) {
        options.headers['Authorization'] = "Bearer $token";
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(jsonEncode(response.data));
    super.onResponse(response, handler);
  }
}
