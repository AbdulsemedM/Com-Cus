import 'dart:convert';

import 'package:commercepal/app/data/network/api_provider.dart';
import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/core/cart-core/dao/cart_dao.dart';
import 'package:commercepal/core/cart-core/domain/cart_item.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/otp_payments/data/otp_payment_repo_imp.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/cart-core/dao/cart_dao.dart';

class EPGPayment extends StatefulWidget {
  static const routeName = "/epg_payment";

  const EPGPayment({super.key});

  @override
  State<EPGPayment> createState() => _EPGPaymentState();
}

class _EPGPaymentState extends State<EPGPayment> {
  final GlobalKey<FormState> myKey = GlobalKey();
  String? pNumber;
  var loading = false;
  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "EPG Pay",
          style: TextStyle(fontSize: sWidth * 0.05),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
                key: myKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Phone Number"),
                          ),
                        ],
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          setState(() {
                            pNumber = value;
                          });
                        },
                        validator: (value) {
                          // Define your regular expressions
                          var regExp1 = RegExp(r'^0\d{9}$');
                          var regExp2 = RegExp(r'^\+251\d{9}$');
                          var regExp3 = RegExp(r'^\251\d{9}$');

                          // Check if the entered value matches either expression
                          if (!(regExp1.hasMatch(value!) ||
                              regExp3.hasMatch(value) ||
                              regExp2.hasMatch(value))) {
                            return 'Enter a valid mobile number';
                          }

                          // Validation passed
                          return null;
                        },
                      ),
                      SizedBox(
                        height: sHeight * 0.04,
                      ),
                      loading
                          ? const CircularProgressIndicator(
                              color: AppColors.colorPrimaryDark,
                            )
                          : SizedBox(
                              width: sWidth,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (myKey.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    var regExp1 = RegExp(r'^0\d{9}$');
                                    var regExp2 = RegExp(r'^\+251\d{9}$');
                                    if (regExp1.hasMatch(pNumber!)) {
                                      pNumber = pNumber!
                                          .replaceFirst(RegExp('^0'), '251');
                                      print(pNumber);
                                    } else if (regExp2.hasMatch(pNumber!)) {
                                      pNumber = pNumber!
                                          .replaceFirst(RegExp(r'^\+'), '');
                                      print(pNumber);
                                    }
                                  }
                                },
                                child: const Text("Submit"),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.colorPrimaryDark),
                              ),
                            )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Future<bool> sendPassword({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        bool isit = await hasUserSwitchedToBusiness();
        final orderRef = await prefsData.readData("order_ref");
        Map<String, dynamic> payload = {
          "ServiceCode": "CHECKOUT",
          "PaymentType": "EPG",
          "PaymentMode": "EPG",
          "UserType": isit ? "C" : "B",
          "PhoneNumber": pNumber,
          "OrderRef": orderRef,
          "Currency": "ETB"
        };
        print(payload);

        final response = await http.post(
          Uri.https(
            "api.commercepal.com:2095",
            "/payment/v1/request",
          ),
          body: jsonEncode(payload),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("epg_done", "yes");
          setState(() {
            loading = false;
          });
          return true;
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await sendPassword(retryCount: retryCount + 1);
          } else {
            // Retry limit reached, handle accordingly
            setState(() {
              loading = false;
            });
            return false;
          }
        }
        return false;
      }
      return false;
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
      // Handle other exceptions
      return false;
    }
  }

  Future<bool> hasUserSwitchedToBusiness() async {
    try {
      final prefsData = getIt<PrefsData>();
      final currentSelection =
          await prefsData.readData(PrefsKeys.userBusinessAcc.name);
      return currentSelection == "YES";
    } catch (e) {
      rethrow;
    }
  }
}
