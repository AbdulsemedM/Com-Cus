import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/dashboard/dashboard_page.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProvidePhoneNumberDialog extends StatefulWidget {
  final String provide;
  const ProvidePhoneNumberDialog({super.key, required this.provide});

  @override
  _ProvidePhoneNumberDialogState createState() =>
      _ProvidePhoneNumberDialogState();
}

class _ProvidePhoneNumberDialogState extends State<ProvidePhoneNumberDialog> {
  var loading = false;
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  final GlobalKey<FormState> _myForm = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent dialog from closing on back button press
        return false;
      },
      child: AlertDialog(
        title: Text(
          'Provide your ${widget.provide == "email" ? "email" : "phone number"}',
          style: TextStyle(fontSize: 15),
        ),
        actions: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _myForm,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 2, 0, 8),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (widget.provide == "email") {
                              return isEmailValid(value);
                            } else {
                              return isPhoneValid(value);
                            }
                          },
                          controller: phoneNumberController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(
                                12.0, 10.0, 12.0, 10.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: AppColors.colorPrimaryDark),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: AppColors.colorPrimaryDark),
                            ),
                            labelText: "Phone Number",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        if (!_myForm.currentState!.validate()) {
                          // Form validation failed
                          return;
                        }
                        setState(() {
                          loading = true;
                        });
                        final prefsData = getIt<PrefsData>();
                        // final isUserLoggedIn =
                        //     await prefsData.contains(PrefsKeys.userToken.name);
                        final token =
                            await prefsData.readData(PrefsKeys.userToken.name);

                        final jwt = JWT.decode(token!);
                        final email = jwt.payload['sub'];
                        var regExp1 = RegExp(r'^0\d{9}$');
                        var regExp2 = RegExp(r'^\+251\d{9}$');
                        if (regExp1.hasMatch(phoneNumberController.text)) {
                          phoneNumberController.text = phoneNumberController
                              .text
                              .replaceFirst(RegExp('^0'), '251');
                          print(phoneNumberController.text);
                        } else if (regExp2
                            .hasMatch(phoneNumberController.text)) {
                          phoneNumberController.text = phoneNumberController
                              .text
                              .replaceFirst(RegExp(r'^\+'), '');
                          print(phoneNumberController.text);
                        }
                        final body = {
                          "phoneNumber": phoneNumberController.text,
                          // "email": email // incase for facebook
                        };
                        final body1 = {
                          // "phoneNumber": phoneNumberController.text,
                          "email": phoneNumberController.text,
                          // "email": email // incase for facebook
                        };
                        print(body);
                        try {
                          final prefsData = getIt<PrefsData>();
                          final isUserLoggedIn = await prefsData
                              .contains(PrefsKeys.userToken.name);
                          if (isUserLoggedIn) {
                            final token = await prefsData
                                .readData(PrefsKeys.userToken.name);
                            final response = await http.post(
                              Uri.https("api.commercepal.com:2096",
                                  "/prime/api/v1/oauth2/follow-up"),
                              body: jsonEncode(
                                  widget.provide == "email" ? body1 : body),
                              headers: <String, String>{
                                "Authorization": "Bearer $token",
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                              },
                            );
                            var data = jsonDecode(response.body);
                            print(data);
                            if (data['statusCode'] == '000') {
                              displaySnack(context,
                                  "${widget.provide == "email" ? "Email" : "Phone Number"} provided successfully.");
                              Navigator.pushNamed(
                                  context, DashboardPage.routeName);
                              Navigator.pop(context, true);
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
      ),
    );
  }

  String? isEmailValid(value) {
    final RegExp emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@(gmail\.com|yahoo\.com|hotmail\.com|outlook\.com|icloud\.com)$');
    if (value?.isEmpty == true) {
      return 'Email is required';
    } else if (!emailRegex.hasMatch(value)) {
      if (emailRegex.hasMatch(value)) return 'Please enter a valid email';
    }
    return null;
  }

  String? isPhoneValid(value) {
    {
      // Define your regular expressions
      var regExp1 = RegExp(r'^0\d{9}$');
      var regExp2 = RegExp(r'^\+251\d{9}$');
      var regExp3 = RegExp(r'^\251\d{9}$');
      if (value.isEmpty == true) {
        return 'Phone number is required';
      }
      // Check if the entered value matches either expression
      if (!(regExp1.hasMatch(value!) ||
          regExp3.hasMatch(value) ||
          regExp2.hasMatch(value))) {
        return 'Enter a valid mobile number';
      }

      // Validation passed
      return null;
    }
  }
}
