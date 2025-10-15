import 'dart:convert';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/features/forgot_password/verify_otp.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:phone_number/phone_number.dart';
import 'package:commercepal/app/utils/logger.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? emailAddress;
  var loading = false;
  String message = '';
  bool isPhoneMode = true;
  Country selectedCountry = Country(
    phoneCode: "251",
    countryCode: "ET",
    e164Sc: 251,
    geographic: true,
    level: 1,
    name: "Ethiopia",
    example: "912345678",
    displayName: "Ethiopia (ET) [+251]",
    displayNameNoCountryCode: "Ethiopia (ET)",
    e164Key: "251-ET-0",
  );
  // Using PhoneNumberUtils.instance instead of instantiating abstract class

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: sHeight * 0.25,
              child:
                  const Image(image: AssetImage("assets/images/app_icon.png")),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Forgot Password")],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: true, label: Text('Phone')),
                      ButtonSegment(value: false, label: Text('Email')),
                    ],
                    selected: {isPhoneMode},
                    onSelectionChanged: (Set<bool> newSelection) {
                      setState(() {
                        isPhoneMode = newSelection.first;
                        emailAddress = null;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4),
                      child: Text(
                        isPhoneMode ? "Phone Number" : "Email Address",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    if (isPhoneMode)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Country Selector
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    showCountryPicker(
                                      context: context,
                                      showPhoneCode: true,
                                      favorite: ['ET', "SO", "KE"],
                                      countryListTheme: CountryListThemeData(
                                        borderRadius: BorderRadius.circular(8),
                                        inputDecoration: InputDecoration(
                                          hintText: 'Search country',
                                          filled: true,
                                          fillColor: Colors.grey[100],
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      onSelect: (Country country) {
                                        setState(() {
                                          selectedCountry = country;
                                        });
                                      },
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down,
                                          color: Colors.black87),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Phone Input Field
                              Expanded(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value?.isEmpty == true) {
                                      return 'Phone number is required';
                                    }
                                    if (!(value!.startsWith("9") ||
                                        value.startsWith("7") ||
                                        value.startsWith("07") ||
                                        value.startsWith("09"))) {
                                      return "Please enter a valid phone number";
                                    }
                                    if ((value.length != 9 ||
                                        value.length != 10)) {
                                      return null;
                                    }
                                    return "Please enter a valid phone number";
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.startsWith("0")) {
                                        value = value.substring(1);
                                      }
                                      emailAddress =
                                          "+${selectedCountry.phoneCode}$value";
                                    });
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    errorBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                    hintText: "Enter phone number",
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    else
                      TextFormField(
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Email is required';
                          }
                          final emailRegExp =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegExp.hasMatch(value!)) {
                            return 'Enter a valid email address';
                          }

                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            emailAddress = value;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: "Enter your email address",
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: loading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.colorPrimaryDark),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      if (isPhoneMode) {
                                        final phoneNumber = emailAddress!
                                            .substring(selectedCountry
                                                    .phoneCode.length +
                                                1);
                                        try {
                                          // final  PhoneNumberUtils phoneNumberUtils;
                                          final isValid =
                                              await PhoneNumberUtil().validate(
                                                  selectedCountry.phoneCode +
                                                      phoneNumber,
                                                  regionCode: selectedCountry
                                                      .countryCode);
                                          // final isValid = await phoneNumberUtils
                                          //     .validateMobileApi(
                                          //   selectedCountry.phoneCode +
                                          //       phoneNumber,
                                          //   selectedCountry.countryCode,
                                          // );
                                          appLog(selectedCountry.phoneCode +
                                              phoneNumber);
                                          if (!isValid) {
                                            displaySnack(context,
                                                'Invalid phone number format');
                                            return;
                                          } else {
                                            bool done = await sendEmail(
                                                phoneNumber:
                                                    selectedCountry.phoneCode +
                                                        phoneNumber);
                                            if (done) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          VerifyOTP(
                                                            userName:
                                                                selectedCountry
                                                                        .phoneCode +
                                                                    phoneNumber,
                                                          )));
                                            } else {
                                              displaySnack(context, message);
                                            }
                                          }
                                        } catch (e) {
                                          appLog(e.toString());
                                          displaySnack(context,
                                              'Error validating phone number');
                                          return;
                                        }
                                      } else {
                                        bool done = await sendEmail();
                                        if (done) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VerifyOTP(
                                                        userName: emailAddress!,
                                                      )));
                                        } else {
                                          displaySnack(context, message);
                                        }
                                      }
                                    }
                                  },
                                  child: Text("Submit",
                                      style: TextStyle(color: Colors.white))),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Future<bool> sendEmail({String? phoneNumber, int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      Map<String, dynamic> payload = {
        "emailOrPhone": phoneNumber ?? emailAddress.toString(),
      };
      appLog(payload);

      final response = await http.post(
        Uri.https(
          "api.commercepal.com",
          "/api/v2/auth/password-reset/request",
        ),
        body: jsonEncode(payload),
        headers: <String, String>{'Content-Type': 'application/json'},
        // headers: <String, String>{"Authorization": "Bearer $token"},
      );

      var data = jsonDecode(response.body);
      appLog(data);

      if (data['statusCode'] == '000') {
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
          await sendEmail(phoneNumber: phoneNumber, retryCount: retryCount + 1);
        } else {
          // Retry limit reached, handle accordingly
          setState(() {
            message = data['statusMessage'];
            loading = false;
          });
          return false;
        }
        return false;
      }
    } catch (e) {
      appLog(e.toString());
      setState(() {
        loading = false;
      });
      // Handle other exceptions
      return false;
    }
  }
}
