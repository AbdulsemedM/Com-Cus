import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:commercepal/features/affiliate_register/data/affiliate_register_repository.dart';
import 'package:commercepal/features/affiliate_register/data/dto/affiliate_register_request_dto.dart';
import 'package:commercepal/features/affiliate_register/data/dto/affiliate_register_response_dto.dart';

class AffiliateRegisterRepositoryImpl implements AffiliateRegisterRepository {
  static const String _baseUrl = 'api.commercepal.com';
  static const String _registerEndpoint = '/api/v1/affiliates/register';

  @override
  Future<AffiliateRegisterResponseDto> registerAffiliate(AffiliateRegisterRequestDto request) async {
    try {
      final uri = Uri.https(_baseUrl, _registerEndpoint);
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      print('Affiliate Registration Response Status: ${response.statusCode}');
      print('Affiliate Registration Response Body: ${response.body}');

      final jsonData = jsonDecode(response.body);
      return AffiliateRegisterResponseDto.fromJson(jsonData);
    } catch (e) {
      print('Error registering affiliate: $e');
      return AffiliateRegisterResponseDto(
        statusCode: 'ERROR',
        statusMessage: 'Network error occurred. Please try again.',
      );
    }
  }
}