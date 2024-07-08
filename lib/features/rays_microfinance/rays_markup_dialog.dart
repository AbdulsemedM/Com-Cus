import 'dart:convert';
import 'dart:io';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/dashboard/dashboard_page.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RaysMarkupDialog extends StatefulWidget {
  final String period;
  final String amountAfter;
  final String markUp;
  final String responseDescription;
  final String amountBefore;

  const RaysMarkupDialog(
      {super.key,
      required this.period,
      required this.amountAfter,
      required this.markUp,
      required this.responseDescription,
      required this.amountBefore});

  @override
  _RaysMarkupDialogState createState() => _RaysMarkupDialogState();
}

class _RaysMarkupDialogState extends State<RaysMarkupDialog> {
  var loading = false;
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Confirm Rays Loan',
        style: TextStyle(fontSize: 15),
      ),
      actions: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      final body = {
                        "phoneNumber": phoneNumberController.text,
                        "channel": Platform.isIOS ? "IOS" : "ANDROID"
                        // "email": email // incase for facebook
                      };
                      final body1 = {
                        // "phoneNumber": phoneNumberController.text,
                        "email": phoneNumberController.text,
                        "channel": Platform.isIOS ? "IOS" : "ANDROID"
                        // "email": email // incase for facebook
                      };
                      print(body);
                      try {
                        final prefsData = getIt<PrefsData>();
                        final isUserLoggedIn =
                            await prefsData.contains(PrefsKeys.userToken.name);
                        if (isUserLoggedIn) {
                          final token = await prefsData
                              .readData(PrefsKeys.userToken.name);
                          final response = await http.post(
                            Uri.https("api.commercepal.com:2096",
                                "/prime/api/v1/oauth2/follow-up"),
                            body: jsonEncode(body),
                            headers: <String, String>{
                              "Authorization": "Bearer $token",
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                          );
                          var data = jsonDecode(response.body);
                          print(data);
                          if (data['statusCode'] == '000') {
                            displaySnack(
                                context, "Loan provided successfully.");
                            Navigator.pushReplacementNamed(
                                context, DashboardPage.routeName);
                            setState(() {
                              loading = false;
                            });
                          } else {
                            displaySnack(context, data['statusMessage']);
                            setState(() {
                              loading = false;
                            });
                          }
                        }
                      } catch (e) {
                        var message = e.toString();
                        displaySnack(context, message);
                      } finally {
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    child: loading
                        ? CircularProgressIndicator(
                            color: AppColors.colorPrimaryDark,
                          )
                        : Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
