import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:commercepal/features/affiliate_register/data/affiliate_register_repository.dart';
import 'package:commercepal/features/affiliate_register/data/dto/affiliate_register_request_dto.dart';
import 'package:commercepal/features/affiliate_register/presentation/bloc/affiliate_register_state.dart';
import 'package:commercepal/app/utils/logger.dart';

class AffiliateRegisterCubit extends Cubit<AffiliateRegisterState> {
  final AffiliateRegisterRepository repository;

  AffiliateRegisterCubit({required this.repository})
      : super(AffiliateRegisterInitial());

  Future<void> registerAffiliate({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
    required String commissionType,
    required String referralCode,
    required String country,
    required String countryCode,
  }) async {
    emit(AffiliateRegisterLoading());

    try {
      // Get device ID
      final deviceInfo = DeviceInfoPlugin();
      String deviceId = 'device-98765'; // Default fallback

      try {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id ?? 'device-98765';
      } catch (e) {
        appLog('Error getting device ID: $e');
      }

      final request = AffiliateRegisterRequestDto(
        commissionType: commissionType,
        confirmPassword: confirmPassword,
        country: country,
        countryCode: countryCode,
        deviceId: deviceId,
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: password,
        phoneNumber: '$countryCode$phoneNumber',
        referralCode: referralCode.isEmpty ? 'asdf' : referralCode,
        registrationChannel: 'WEB',
      );

      final response = await repository.registerAffiliate(request);

      if (response.isSuccess) {
        emit(AffiliateRegisterSuccess(response.statusMessage));
      } else {
        emit(AffiliateRegisterError(response.statusMessage));
      }
    } catch (e) {
      emit(AffiliateRegisterError('Registration failed. Please try again.'));
    }
  }
}
