// <<<<<<< New-Providers
import 'dart:convert';
// <<<<<<< New-Providers
// =======
// =======
// >>>>>>> main
// import 'dart:convert';
// >>>>>>> main

import 'package:commercepal/app/data/network/api_provider.dart';
import 'package:commercepal/app/data/network/end_points.dart';
// import 'package:commercepal/app/di/injector.dart';
// import 'package:commercepal/core/data/prefs_data.dart';
// import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/payment/data/dto/payment_modes_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

import '../domain/payment_repo.dart';

@Injectable(as: PaymentRepo)
class PaymentRepoImpl implements PaymentRepo {
  final ApiProvider apiProvider;

  PaymentRepoImpl(this.apiProvider);

  @override
  Future<List<PaymentMethods>> fetchPaymentModes(String? currency) async {
    try {
      // final prefsData = getIt<PrefsData>();
      // final token = await prefsData.readData(PrefsKeys.userToken.name);
      // final data = await http.get(
      //     Uri.https("pay.commercepal.com", "/payment/v1/request"),
      //     headers: <String, String>{"Authorization": "Bearer $token"});
      // var response = jsonDecode(data.body);
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // final String currentCountry = prefs.getString("currency") ?? "";
      final response = await apiProvider.get(
          "${EndPoints.paymentModes.url}&currency=${currency!.trim() == "\$" ? "USD" : currency == "ETB" ? "ETB" : currency == "AED" ? "AED" : ""}");
      print("${EndPoints.paymentModes.url}?currency=$currency");
      if (response['statusCode'] == '000') {
// <<<<<<< New-Providers
        // print(response);
        // print("here we returned");
        // print(rObject);
// =======
//         print("response");
// >>>>>>> main
        final rObject = PaymentModesDto.fromJson(response);
        if (rObject.data?.paymentMethods?.isEmpty == true) {
          throw 'Payment modes not found';
        }
        // print(response);
        return rObject.data!.paymentMethods!;
      } else {
        throw response['statusDescription'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
