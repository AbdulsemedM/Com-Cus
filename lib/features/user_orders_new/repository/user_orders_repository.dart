import 'dart:convert';
import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/user_orders_new/models/user_order_model.dart';
import 'package:http/http.dart' as http;
import 'package:commercepal/app/utils/logger.dart';

class UserOrdersRepository {
  static const String _baseUrl = 'api.commercepal.com';
  static const String _ordersEndpoint = '/api/v2/orders/my-orders';

  Future<UserOrdersResponse> fetchOrders({
    int page = 0,
    int size = 5,
    String status = 'success',
    String sortDirection = 'desc',
  }) async {
    try {
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);

      if (!isUserLoggedIn) {
        throw Exception('User not logged in');
      }

      final token = await prefsData.readData(PrefsKeys.userToken.name);

      final queryParameters = {
        'status': status,
        'page': page.toString(),
        'size': size.toString(),
        'sortDirection': sortDirection,
      };

      final uri = Uri.https(_baseUrl, _ordersEndpoint, queryParameters);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      appLog('Orders API Response Status: ${response.statusCode}');
      appLog('Orders API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final ordersResponse = UserOrdersResponse.fromJson(jsonData);

        if (ordersResponse.statusCode == '000') {
          return ordersResponse;
        } else {
          throw Exception(ordersResponse.statusMessage);
        }
      } else {
        throw Exception('Failed to fetch orders: ${response.statusCode}');
      }
    } catch (e) {
      appLog('Error fetching orders: $e');
      rethrow;
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      final prefsData = getIt<PrefsData>();
      return await prefsData.contains(PrefsKeys.userToken.name);
    } catch (e) {
      appLog('Error checking login status: $e');
      return false;
    }
  }
}
