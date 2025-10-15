import 'package:bloc/bloc.dart';
import 'package:commercepal/features/login/presentation/bloc/login_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core-phonenumber/phone_number_utils.dart';
import '../../domain/login_repository.dart';
import 'package:commercepal/app/utils/logger.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginRepository loginRepository;
  final PhoneNumberUtils phoneNumberUtils;

  LoginCubit(this.loginRepository, this.phoneNumberUtils)
      : super(const LoginState.init());

  void loginUser(String emailOrPhone, String pass) async {
    try {
      emit(const LoginState.loading());

      // validate email/phone
      final isEmailValid = await phoneNumberUtils.validateEmail(emailOrPhone);
      final isPhoneNumberValid =
          await phoneNumberUtils.validateMobileApi(emailOrPhone, 'ET');
      if (isEmailValid == false && isPhoneNumberValid == false) {
        throw 'Please enter a valid email or phone number.';
      }

      // if its a phone number, use the formatted one
      if (isPhoneNumberValid == true) {
        emailOrPhone =
            (await phoneNumberUtils.passPhoneToIso(emailOrPhone, "ET"))!;
      }
      appLog("emailOrPhone");
      appLog(emailOrPhone);
      final authResponse = await loginRepository.login(emailOrPhone, pass);
      appLog("hereistheauth");
      appLog(authResponse.isPhoneProvided);
      if (authResponse.isPhoneProvided == 0) {
        appLog("emmited");
        emit(const LoginState.providePhone('phone'));
        return;
      }
      if (authResponse.isEmailProvided == 0) {
        appLog("emmited");
        emit(const LoginState.providePhone('email'));
        return;
      }
      if (authResponse.changePin == 0 && authResponse.isPhoneProvided == 1) {
        emit(LoginState.setPin(authResponse.phoneNumber!));
        return;
      }
      appLog("hereistheauth1");
      emit(const LoginState.success("Success"));
    } catch (e) {
      emit(LoginState.error(e.toString()));
      appLog("isithere");
      appLog(e.toString());
    }
  }
}
