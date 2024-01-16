import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core-phonenumber/phone_number_utils.dart';
import '../../domain/otp_payment_repo.dart';
import 'otp_payment_state.dart';

@injectable
class OtpPaymentCubit extends Cubit<OtpPaymentState> {
  final OtpPaymentRepo OtpPayRepo;
  final PhoneNumberUtils phoneNumberUtil;

  String? _name;
  String? _transRef;

  OtpPaymentCubit(this.OtpPayRepo, this.phoneNumberUtil)
      : super(const OtpPaymentState.init());

  // void confirmUser(String phoneNumber, String paymentType) async {
  //   try {
  //     emit(const OtpPaymentState.loading());
  //     final response = await OtpPayRepo.accountLookUp(
  //         phoneNumber, getPaymentType(paymentType));
  //     _name = response;
  //     emit(OtpPaymentState.confirmation(response));
  //   } catch (e) {
  //     emit(OtpPaymentState.error(e.toString()));
  //   }
  // }

  void checkOut(String phoneNumber, String paymentType) async {
    try {
      emit(const OtpPaymentState.loading());
      final response =
          await OtpPayRepo.paymentCheckOut(phoneNumber, paymentType);
      _transRef = response;
      emit(const OtpPaymentState.otp());
    } catch (e) {
      emit(OtpPaymentState.error(e.toString()));
    }
  }

  void submitRequest(
      String? phoneNumber, String? otp, String paymentType) async {
    try {
      emit(const OtpPaymentState.loading());
      final isPhonenumberValida =
          await phoneNumberUtil.validateMobileApi(phoneNumber!, "ET");
      if (isPhonenumberValida == false) {
        throw 'Phone number format is invalid';
      }
      if (getPaymentType(paymentType) == "EPG") {
        emit(const OtpPaymentState.loading());
        emit(OtpPaymentState.redirect(phoneNumber));
      } else {
        final parsePhoneNumber =
            await phoneNumberUtil.passPhoneToIso(phoneNumber, 'ET');
        // if (_name == null) {
        //   confirmUser(parsePhoneNumber!, paymentType);
        // } else 
        if (_transRef == null) {
          checkOut(parsePhoneNumber!, paymentType);
        } else {
          completeOrder(otp, paymentType);
        }
      }
    } catch (e) {
      emit(OtpPaymentState.error(e.toString()));
    }
  }

  void completeOrder(String? otp, String paymentType) async {
    try {
      emit(const OtpPaymentState.loading());
      final response = await OtpPayRepo.confirmPaymentCheckOut(
          _transRef!, otp!);
      emit(OtpPaymentState.success(response));
    } catch (e) {
      emit(OtpPaymentState.error(e.toString()));
    }
  }
}

String getPaymentType(String paymentType) {
  if (paymentType.contains('AMOLE')){
    return 'AMOLE';
  } else if(paymentType.contains('EPG')){
    return 'EPG';
  }else{
    return 'AGENT-CASH';
  }
}
