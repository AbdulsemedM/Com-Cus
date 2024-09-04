import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoinTransfer extends StatefulWidget {
  const CoinTransfer({super.key});

  @override
  State<CoinTransfer> createState() => _CoinTransferState();
}

class _CoinTransferState extends State<CoinTransfer> {
  TextEditingController pNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> myKey = GlobalKey();
  var loading = false;
  var message;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            "You can transfer CommercePal coins to friends and family.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: myKey,
            child: Column(
              children: [
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Email or Phone Number"),
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
                  keyboardType: TextInputType.emailAddress,
                  controller: pNumberController,
                  validator: (value) {
                    // Define your regular expressions
                    var regExp1 = RegExp(r'^0\d{9}$');
                    var regExp2 = RegExp(r'^\+251\d{9}$');
                    var regExp3 = RegExp(r'^\251\d{9}$');
                    final RegExp emailRegex = RegExp(
                      r'^[\w-]+(\.[\w-]+)*@(gmail\.com|yahoo\.com|hotmail\.com|outlook\.com|icloud\.com)$',
                    );

                    // Check if the entered value matches either expression
                    if (!(regExp1.hasMatch(value!) ||
                        regExp3.hasMatch(value) ||
                        regExp2.hasMatch(value) ||
                        emailRegex.hasMatch(value))) {
                      return 'Enter a valid mobile number or email';
                    }

                    // Validation passed
                    return null;
                  },
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Coin amount"),
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
                  keyboardType: TextInputType.number,
                  controller: amountController,
                  validator: (value) {
                    // Define your regular expressions

                    // Check if the entered value matches either expression
                    if (value!.isEmpty == true) {
                      return 'Amount is required';
                    }

                    // Validation passed
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AppButtonWidget(
                    isLoading: loading,
                    onClick: () async {
                      if (myKey.currentState!.validate()) {
                        var pNumber = pNumberController.text;
                        setState(() {
                          loading = true;
                        });
                        var regExp1 = RegExp(r'^0\d{9}$');
                        var regExp2 = RegExp(r'^\+251\d{9}$');
                        if (regExp1.hasMatch(pNumberController.text)) {
                          pNumber = pNumberController.text
                              .replaceFirst(RegExp('^0'), '251');
                          print(pNumber);
                        } else if (regExp2.hasMatch(pNumberController.text)) {
                          pNumber = pNumberController.text
                              .replaceFirst(RegExp(r'^\+'), '');
                          print(pNumber);
                        }
                        var done = await submitForm(pNumber);
                        if (done) {
                          displaySnack(context, "Coin transfered successfully");
                          Navigator.pop(context, true);
                        } else {
                          displaySnack(context, message);
                        }
                      }
                    },
                    text: "Transfer",
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Future<bool> submitForm(String pNumber) async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final orderRef = await prefsData.readData("order_ref");
        Map<String, dynamic> payload = {
          "amount": amountController.text,
          "receiverContact": pNumber
        };
        print(payload);

        final response = await http.post(
          Uri.https(
            "api.commercepal.com:2095",
            "/prime/api/v1/customer/accounts/transfer-balance",
          ),
          body: jsonEncode(payload),
          headers: <String, String>{
            "Authorization": "Bearer $token",
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          setState(() {
            loading = false;
          });
          return true;
          // Handle the case when statusCode is '000'
        } else {
          setState(() {
            message = data['statusMessage'];
            loading = false;
          });
          return false;
        }
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
}
