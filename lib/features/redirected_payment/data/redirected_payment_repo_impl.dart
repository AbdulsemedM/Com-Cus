import 'dart:convert';

import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/redirected_payment/domain/redirected_payment_repo.dart';
import 'package:injectable/injectable.dart';

import '../../../app/data/network/api_provider.dart';
import '../../../app/data/network/end_points.dart';
import '../../../core/cart-core/dao/cart_dao.dart';
import '../../../core/data/prefs_data.dart';
import '../../../core/session/domain/session_repo.dart';
import 'redirect_payment_model.dart';

@Injectable(as: RedirectedPaymentRepo)
class RedirectedPaymentRepoImp implements RedirectedPaymentRepo {
  final ApiProvider apiProvider;
  final PrefsData prefsData;
  final CartDao cartDao;
  final SessionRepo sessionRepo;

  RedirectedPaymentRepoImp(
      {required this.apiProvider,
      required this.prefsData,
      required this.cartDao,
      required this.sessionRepo});

  @override
  Future<String> getPaymentApi(String cashType, phone) async {
    try {
      if (_getCashType(cashType).contains('TELE-BIRR')) {
        return getTeleBirrPaymentApi(cashType, phone);
      } else if (_getCashType(cashType).contains('EPG')) {
        return getEpgPaymentApi(cashType, phone);
      } else {
        throw "Can't processed with the payment";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getEpgPaymentApi(String cashType, phone) async {
    try {
      final orderRef = await prefsData.readData("order_ref");
      // final phone = await prefsData.readData(PrefsKeys.user.)
      final isUserBusiness = await sessionRepo.hasUserSwitchedToBusiness();
      print('cash type $_getCashType(cashType)');
      var payLoad = {
        "ServiceCode": "CHECKOUT",
        "PaymentType": "EPG",
        "PaymentMode": "EPG",
        "UserType": isUserBusiness ? "B" : "C",
        "PhoneNumber": phone,
        "OrderRef": orderRef,
        "Currency": "ETB"
      };
      final response = await apiProvider.post(payLoad, EndPoints.pay.url);
      if (response['statusCode'] == '000') {
        final resObject = EpgResponse.fromJson(response);
        if (resObject.transRef == null) {
          throw 'Unable to get transaction ref! Try again';
        }
        return resObject.paymentUrl!;
      } else {
        throw response['statusDescription'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getTeleBirrPaymentApi(String cashType, phone) async {
    try {
      final orderRef = await prefsData.readData("order_ref");
      final isUserBusiness = await sessionRepo.hasUserSwitchedToBusiness();
      print('cash type $_getCashType(cashType)');

      var payLoad = {
        "PaymentType": _getCashType(cashType),
        "PaymentMode": _getCashType(cashType),
        "UserType": isUserBusiness ? "B" : "C",
        "OrderRef": orderRef,
        "ServiceCode": "CHECKOUT",
        "Currency": "ETB"
      };
      final response = await apiProvider.post(payLoad, EndPoints.pay.url);
      if (response['statusCode'] == '000') {
        if (response['transRef'] == null) {
          throw 'Unable to get transaction ref! Try again';
        }
        return response["paymentUrl"]!;
      } else {
        throw response['statusDescription'];
      }
    } catch (e) {
      rethrow;
    }
  }

  String _getCashType(String type) {
    if (type.contains('TELE-BIRR')) {
      return 'TELE-BIRR';
    } else if (type.contains('EPG')) {
      return 'EPG';
    } else {
      return 'AGENT-CASH';
    }
  }
}
