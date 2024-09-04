import 'dart:convert';
import 'dart:developer';

import 'package:commercepal/app/data/network/api_provider.dart';
import 'package:commercepal/app/data/network/end_points.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

import '../../../core/cart-core/dao/cart_dao.dart';
import '../../../core/data/prefs_data.dart';
import '../../../core/session/domain/session_repo.dart';
import '../domain/otp_payment_repo.dart';

@Injectable(as: OtpPaymentRepo)
class OtpPaymentRepoImp implements OtpPaymentRepo {
  final ApiProvider apiProvider;
  final PrefsData prefsData;
  final CartDao cartDao;
  final SessionRepo sessionRepo;

  OtpPaymentRepoImp(
      this.apiProvider, this.prefsData, this.cartDao, this.sessionRepo);

  @override
  Future<String> accountLookUp(String phoneNumber, String serviceCode) async {
    try {
      final isUserBusiness = await sessionRepo.hasUserSwitchedToBusiness();
      final payLoad = {
        "UserType": isUserBusiness ? "B" : "C",
        "ServiceCode": serviceCode,
        "PhoneNumber": phoneNumber
      };
      final response = await apiProvider.post(payLoad, EndPoints.pay.url);
      if (response['statusCode'] == '000') {
        final resObject = jsonDecode(response);
        if (resObject["customerName"] == null) {
          throw 'Unable to verify phone number';
        }
        return resObject["customerName"]!;
      } else {
        throw response['statusDescription'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> paymentCheckOut(
      String phoneNumber, String paymentMethod) async {
    try {
      final isUserBusiness = await sessionRepo.hasUserSwitchedToBusiness();
      final orderRef = await prefsData.readData("order_ref");
      final payLoad = {
        "ServiceCode": "CHECKOUT",
        "PaymentType": getPaymentType(paymentMethod),
        "PaymentMode": getPaymentType(paymentMethod),
        "UserType": isUserBusiness ? "B" : "C",
        "PhoneNumber": phoneNumber,
        "OrderRef": orderRef,
        "Currency": "ETB"
      };

      final response = await apiProvider.post(payLoad, EndPoints.pay.url);
      if (response['statusCode'] == '000') {
        if (response["TransRef"] == null) {
          throw 'Unable to get transaction ref! Try again';
        }
        return response['TransRef']!;
      } else {
        throw response['statusDescription'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> confirmPaymentCheckOut(String transRef, String otp) async {
    try {
      final payLoad = {"TransRef": transRef, "OTP":otp};

      // Uri url = Uri.parse(EndPoints.amole.url);
      // print(url);

      // String token = PrefsKeys.userToken.name;
      // Map<String, String> header = {
      //   'Authorization': 'Bearer $token',
      // };
      final response = await apiProvider.post(
          payLoad, EndPoints.amole.url);
      if (response != null) {
        if (response['statusCode'] == '000') {
          await cartDao.nuke();

          return 'Order successfully placed';
        } else {
          throw response['statusDescription'];
        }
      } else {
        throw Exception(response['statusDescription']);
      }
    } catch (e) {
      rethrow;
    }
  }
}

String getPaymentType(String paymentType) {
  switch (paymentType) {
    case 'AMOLE':
      return 'AMOLE';
    case 'EPG':
      return 'EPG';
    default:
      return 'AGENT-CASH';
  }
}
