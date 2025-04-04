import 'package:commercepal/app/data/network/api_provider.dart';
import 'package:commercepal/app/data/network/end_points.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/features/cash_payment/domain/cash_payment_repo.dart';
import 'package:injectable/injectable.dart';
import 'dart:convert';

import '../../../core/cart-core/dao/cart_dao.dart';
import '../../../core/session/domain/session_repo.dart';

@Injectable(as: CashPaymentRepo)
class CashPaymentRepoImpl implements CashPaymentRepo {
  final ApiProvider apiProvider;
  final PrefsData prefsData;
  final CartDao cartDao;
  final SessionRepo sessionRepo;

  CashPaymentRepoImpl(
      this.apiProvider, this.prefsData, this.cartDao, this.sessionRepo);

  @override
  Future<String> cashCheckOut(String phoneNumber, String cashType) async {
    try {
      final orderRef = await prefsData.readData("order_ref");
      final isUserBusiness = await sessionRepo.hasUserSwitchedToBusiness();

      final payLoad = {
        "PaymentType": cashType == "COOPAY_EBIRR"
            ? "COOPAY_EBIRR"
            : cashType == "KAAFI_EBIRR"
                ? "KAAFI_EBIRR"
                : _getCashType(cashType),
        "PaymentMode": cashType == "COOPAY_EBIRR" || cashType == "KAAFI_EBIRR"
            ? "MOBILE_MONEY"
            : _getCashType(cashType),
        "UserType": isUserBusiness ? "B" : "C",
        "PhoneNumber": phoneNumber,
        "OrderRef": orderRef,
        "ServiceCode": "CHECKOUT",
        "Currency": "ETB"
      };
      final response = await apiProvider.post(payLoad, EndPoints.pay.url);
      // clear cart
      await cartDao.nuke();
      if (cashType == "HELLO_CASH") {
        return response['TransRef'];
      } else if (_getCashType(cashType) == "AGENT-CASH") {
        final jsonString = jsonEncode(response);
        return jsonString;
      } else {
        return "Order placed successfully";
      }
    } catch (e) {
      rethrow;
    }
  }

  String _getCashType(String type) {
    switch (type) {
      case 'HELLO_CASH':
        return 'HELLO-CASH';
      case 'COOPAY_EBIRR':
        return 'COOPAY_EBIRR';
      default:
        return 'AGENT-CASH';
    }
  }

  @override
  Future<String> validateHelloCashPayment(String transactionRef) async {
    try {
      final orderRef = await prefsData.readData("order_ref");
      final isUserBusiness = await sessionRepo.hasUserSwitchedToBusiness();

      final payload = {
        "ServiceCode": "HELLO-CASH-CONFIRM-PAYMENT",
        "UserType": isUserBusiness ? "B" : "C",
        "OrderRef": orderRef,
        "TransRef": transactionRef
      };

      final response = await apiProvider.post(payload, EndPoints.pay.url);
      if (response['statusCode'] == '000') {
        return response['statusMessage'];
      } else {
        throw response['statusMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
