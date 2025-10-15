import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:commercepal/features/affiliate_register/data/affiliate_register_repository.dart';
import 'package:commercepal/features/affiliate_register/data/dto/affiliate_register_request_dto.dart';
import 'package:commercepal/features/affiliate_register/data/dto/affiliate_register_response_dto.dart';
import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/app/utils/logger.dart';

class AffiliateRegisterRepositoryImpl implements AffiliateRegisterRepository {
  static const String _baseUrl = 'api.commercepal.com';
  static const String _registerEndpoint = '/api/v1/affiliates/register';

  @override
  Future<AffiliateRegisterResponseDto> registerAffiliate(
      AffiliateRegisterRequestDto request) async {
    try {
      final prefsData = getIt<PrefsData>();
      final token = await prefsData.readData(PrefsKeys.userToken.name);

      final uri = Uri.https(_baseUrl, _registerEndpoint);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      appLog('Affiliate Registration Request: ${response.request}');

      appLog('Affiliate Registration Response Status: ${response.statusCode}');
      appLog('Affiliate Registration Response Body: ${response.body}');

      final jsonData = jsonDecode(response.body);
      return AffiliateRegisterResponseDto.fromJson(jsonData);
    } catch (e) {
      appLog('Error registering affiliate: $e');
      return AffiliateRegisterResponseDto(
        statusCode: 'ERROR',
        statusMessage: 'Network error occurred. Please try again.',
      );
    }
  }
}
