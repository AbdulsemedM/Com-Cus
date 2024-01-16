
import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_payment_state.freezed.dart';

@freezed
class OtpPaymentState with _$OtpPaymentState {
  const factory OtpPaymentState.init() = OtpPaymentStateInit;

  const factory OtpPaymentState.loading() = OtpPaymentStateLoading;

  const factory OtpPaymentState.error(String message) = OtpPaymentStateError;
  const factory OtpPaymentState.confirmation(String name) = OtpPaymentStateConfirmation;
  const factory OtpPaymentState.redirect(String? phone) = OtpPaymentStateRedirect;
  const factory OtpPaymentState.otp() = OtpPaymentStateOtp;
  const factory OtpPaymentState.success(String message) = OtpPaymentStateSuccess;

}
