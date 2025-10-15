import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/core/widgets/app_button.dart';
import 'package:commercepal/features/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:commercepal/app/utils/logger.dart';

class CommercepalCoinsCheckout extends StatefulWidget {
  const CommercepalCoinsCheckout({super.key});

  @override
  State<CommercepalCoinsCheckout> createState() =>
      _CommercepalCoinsCheckoutState();
}

class _CommercepalCoinsCheckoutState extends State<CommercepalCoinsCheckout> {
  @override
  void initState() {
    super.initState();
    fetchFloatingBalance();
  }

  var loading = false;
  String? balance;
  String? message;
  @override
  Widget build(BuildContext context) {
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Commercepal coins Checkout",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    "Balance",
                    style: TextStyle(fontSize: sWidth * 0.05),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("${balance ?? 0}",
                      style: TextStyle(fontSize: sWidth * 0.06)),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AppButtonWidget(
                  isLoading: loading,
                  onClick: () async {
                    var done = await checkout();
                    if (done) {
                      displaySnack(context, message!);
                      Navigator.popAndPushNamed(
                          context, DashboardPage.routeName);
                    } else {
                      displaySnack(context, message!);
                    }
                  },
                  text: "Pay Now",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchFloatingBalance({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.get(
          Uri.https(
            "pay.commercepal.com",
            "/prime/api/v1/customer/accounts/commission-balance",
          ),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);

        if (data['statusCode'] == '000') {
          setState(() {
            balance = data['balance'].toString();
            loading = false;
          });
        } else {
          if (retryCount < 5) {
            await Future.delayed(Duration(seconds: retryCount++));
            await fetchFloatingBalance(retryCount: retryCount + 1);
          } else {
            setState(() {
              loading = true;
            });
          }
        }
      }
    } catch (e) {
      setState(() {
        loading = true;
      });
      appLog(e.toString());

      // Handle other exceptions
    }
  }

  Future<bool> checkout() async {
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
          "PaymentType": "COMMISSION-CHECKOUT",
          "PaymentMode": "COMMISSION-CHECKOUT",
          "UserType": isit ? "C" : "B",
          "OrderRef": orderRef,
          "Currency": "ETB"
        };
        // appLog(payload);

        final response = await http.post(
          Uri.https(
            "pay.commercepal.com",
            "/payment/v1/request",
          ),
          body: jsonEncode(payload),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        // appLog(data);

        if (data['statusCode'] == '000') {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("epg_done", "yes");
          setState(() {
            message = data['statusMessage'];
            loading = false;
          });
          return true;
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          // if (retryCount < 5) {
          //   // Retry after num + 1 seconds
          //   await Future.delayed(Duration(seconds: retryCount++));
          //   // Call the function again with an increased retryCount
          //   await checkout(retryCount: retryCount + 1);
          // } else {
          // Retry limit reached, handle accordingly
          setState(() {
            message = data['statusMessage'];
            loading = false;
          });
          return false;
          // }
        }
        // return false;
      }
      return false;
    } catch (e) {
      appLog(e.toString());
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
