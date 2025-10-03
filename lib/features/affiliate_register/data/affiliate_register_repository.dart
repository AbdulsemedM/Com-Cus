import 'package:commercepal/features/affiliate_register/data/dto/affiliate_register_request_dto.dart';
import 'package:commercepal/features/affiliate_register/data/dto/affiliate_register_response_dto.dart';

abstract class AffiliateRegisterRepository {
  Future<AffiliateRegisterResponseDto> registerAffiliate(AffiliateRegisterRequestDto request);
}