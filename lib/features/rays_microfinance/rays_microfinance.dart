import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/dashboard/dashboard_page.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RaysMicrofinance extends StatefulWidget {
  static const routeName = "/rays_microfinance_payment";
  const RaysMicrofinance({super.key});

  @override
  State<RaysMicrofinance> createState() => _RaysMicrofinanceState();
}

class RaysMarkup {
  final String RepaymentMonth;
  final String Markup;
  RaysMarkup({required this.RepaymentMonth, required this.Markup});
}

class _RaysMicrofinanceState extends State<RaysMicrofinance> {
  String? period1;
  String? amountAfter1;
  String? markUp1;
  String? responseDescription1;
  String? amountBefore1;
  @override
  void initState() {
    super.initState();
    fetchHints();
    fetchRaysMarkup();
  }

  String extractNumber(String input) {
    final RegExp regex = RegExp(r'[\d,]+(\.\d+)?');
    final Match? match = regex.firstMatch(input);
    if (match != null) {
      return match.group(0)!.replaceAll(',', '');
    }
    return '';
  }

  String extractNumber1(String input) {
    final RegExp regex = RegExp(r'\d+');
    final Match? match = regex.firstMatch(input);
    if (match != null) {
      return match.group(0)!;
    }
    return '';
  }

  String totalRaysPrice = "";
  void fetchHints() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    totalRaysPrice = extractNumber(prefs.getString("newTotalPrice") ??
        prefs.getString("myRayTotalPrice")!);
    print("here is the total ${extractNumber(totalRaysPrice)}");
    setState(() {
      loading1 = true;
    });

    physicalAddressHintFuture = Translations.translatedText(
        "Enter your phone number below", GlobalStrings.getGlobalString());
    subcityHint = Translations.translatedText(
        "Enter the OTP we just sent to your phone",
        GlobalStrings.getGlobalString());
    addAddHint =
        Translations.translatedText("Submit", GlobalStrings.getGlobalString());
    dbHint =
        Translations.translatedText("Verify", GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    pHint = await physicalAddressHintFuture;
    cHint = await subcityHint;
    aHint = await addAddHint;
    bHint = await dbHint;
    // print("herrerererere");
    // print(pHint);
    // print(cHint);

    setState(() {
      loading1 = false;
    });
  }

  var physicalAddressHintFuture;
  var subcityHint;
  var addAddHint;
  var dbHint;
  String pHint = '';
  String cHint = '';
  String aHint = '';
  String bHint = '';
  GlobalKey<FormState> myForm = GlobalKey();
  final TextEditingController pNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  var loading = false;
  var loading1 = false;
  String? loanRef;
  String? message;
  String? pNumber;
  String? transRef;
  String? markup;
  String? period;
  String? totalRepaymentAmount;
  List<RaysMarkup> myMarkups = [];
  String? myMarkup;
  RaysMarkup? selectedMarkups;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rays Microfinance"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Column(
            children: [
              Form(
                key: myForm,
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text("Select Markup"),
                        ),
                      ],
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: AppColors.greyColor,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      items: myMarkups.map((RaysMarkup m) {
                        return DropdownMenuItem<String>(
                          value: m.Markup,
                          child: Row(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "${m.RepaymentMonth} month with  ",
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                  // SizedBox(
                                  //   width: 30,
                                  // ),
                                  Text(
                                    "${m.Markup.toString()} Markup",
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          myMarkup = value;
                          if (value != null) {
                            // Find the selected markup entity and add it to the list
                            selectedMarkups = myMarkups.firstWhere(
                              (markup) =>
                                  markup.Markup ==
                                  value, // Provide a default value if no match is found
                            );
                            print(selectedMarkups!.RepaymentMonth);
                            sendData1();
                            // selectedMarkups.add(selectedMarkup);
                          }
                        });
                      },
                      value:
                          myMarkup, // Pass the selected value to the dropdown
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Loan Markup is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (markUp1 != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Your loan markup value is $markUp1 ETB."),
                      ),
                    if (markUp1 != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Your loan repayment period is $period1."),
                      ),
                    if (markUp1 != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                            "Your previous repayment amount was $amountBefore1 ETB."),
                      ),
                    if (markUp1 != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                            "The new repayment amount is $amountAfter1 ETB."),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: loading1
                                ? const Text("Loading...")
                                : Text(pHint)),
                      ],
                    ),
                    TextFormField(
                      controller: pNumberController,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.greyColor,
                          focusedBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none),
                      keyboardType: TextInputType.phone,
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
                  ],
                ),
              ),
              // if (loanRef != null)
              //   Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 8.0),
              //     child: Text("Your loan markup value is $markup ETB."),
              //   ),
              // if (loanRef != null)
              //   Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 8.0),
              //     child: Text("Your loan repayment period is $period."),
              //   ),
              // if (loanRef != null)
              //   Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 8.0),
              //     child: Text(
              //         "The total repayment amount is $totalRepaymentAmount ETB."),
              //   ),
              if (loanRef != null)
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child:
                            loading1 ? const Text("Loading...") : Text(cHint)),
                  ],
                ),
              if (loanRef != null)
                TextFormField(
                  controller: otpController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.greyColor,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none),
                  keyboardType: TextInputType.text,
                ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              if (loanRef == null)
                loading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (loanRef == null) {
                                if (myForm.currentState!.validate()) {
                                  pNumber = pNumberController.text;
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
                                  bool done = await sendData();
                                  if (done) {
                                    displaySnack(context, message!);
                                  } else {
                                    displaySnack(context, message!);
                                  }
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.colorPrimaryDark),
                            child: loading
                                ? const Text('...')
                                : Text(
                                    aHint,
                                    style: TextStyle(color: Colors.white),
                                  )),
                      ),
              if (loanRef != null)
                loading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (loanRef != null) {
                                String? otp = otpController.text;
                                bool done = await verifyData();
                                if (done) {
                                  displaySnack(context, message!);
                                  Navigator.popAndPushNamed(
                                      context, DashboardPage.routeName);
                                } else {
                                  displaySnack(context, message!);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.colorPrimaryDark),
                            child: loading
                                ? const Text('...')
                                : Text(
                                    bHint,
                                    style: TextStyle(color: Colors.white),
                                  )),
                      )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> sendData1({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      print('hereweare');
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      print(isUserLoggedIn);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        print(totalRaysPrice);
        Map<String, dynamic> payload = {
          "amount": double.parse(totalRaysPrice),
          "period": selectedMarkups!.RepaymentMonth
        };
        print(payload);

        final response = await http.post(
            Uri.https("api.commercepal.com:2087",
                "/api/v1/financial/payment/rays/calculate-mark"),
            body: jsonEncode(payload),
            headers: <String, String>{"Authorization": "Bearer $token"});
        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          setState(() {
            period1 = data['period'].toString();
            amountAfter1 = data['amountAfter'].toString() ?? '';
            markUp1 = data['markUp'].toString();
            amountBefore1 = data['amountBefore'].toString();
            loading = false;
          });
          // print(transRef);
          return true;
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await sendData(retryCount: retryCount + 1);
          } else {
            // Retry limit reached, handle accordingly
            setState(() {
              message = "Please try again later";
              loading = false;
            });
            return false;
          }
          setState(() {
            message = "Please try again later";
            loading = false;
          });
        }
        return false;
      }
      return false;
    } catch (e) {
      message = e.toString();
      print(e.toString());
      setState(() {
        loading = false;
      });
      // Handle other exceptions
      return false;
    }
  }

  Future<bool> sendData({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      print('hereweare');
      // final SharedPreferences prefs = await SharedPreferences.getInstance();
      // String? amount = prefs.getString("rays")!;
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      print(isUserLoggedIn);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final orderRef = await prefsData.readData("order_ref");
        // print(token);
        Map<String, dynamic> payload = {
          "ServiceCode": "LOAN-REQUEST",
          "PaymentType": "FINANCIAL_RAYS_MFI",
          "PaymentMode": "FINANCIAL_RAYS_MFI",
          "PhoneNumber": pNumber,
          "UserType": "B",
          "LoanType": "COL",
          "OrderRef": orderRef,
          "Currency": "ETB",
          "Markup": int.parse(extractNumber1(selectedMarkups!.Markup)),
          "RepaymentMonth": selectedMarkups!.RepaymentMonth,
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
          setState(() {
            loanRef = data['LoanRef'];
            message = data['statusMessage'] ?? '';
            transRef = data['TransRef'];
            period = data['loanPeriod'];
            markup = data['loanMarkup'];
            totalRepaymentAmount = data['totalRepaymentAmount'];
            loading = false;
          });
          // print(transRef);
          return true;
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await sendData(retryCount: retryCount + 1);
          } else {
            // Retry limit reached, handle accordingly
            setState(() {
              message = data['statusMessage'] ?? "please try again later";
              loading = false;
            });
            return false;
          }
          setState(() {
            message = data['statusMessage'] ?? "please try again later";
            loading = false;
          });
        }
        return false;
      }
      return false;
    } catch (e) {
      message = e.toString();
      print(e.toString());
      setState(() {
        loading = false;
      });
      // Handle other exceptions
      return false;
    }
  }

  Future<bool> verifyData({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      print('hereweare');
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      print(isUserLoggedIn);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        Map<String, dynamic> payload = {
          "LoanRef": loanRef,
          "otp": otpController.text,
          "TransRef": transRef,
        };
        print(payload);

        final response = await http.post(
          Uri.https(
            "api.commercepal.com:2095",
            "/payment/v1/rays/confirm",
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
            message = data['statusMessage'] ?? '';
            loading = false;
          });
          return true;
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await verifyData(retryCount: retryCount + 1);
          } else {
            // Retry limit reached, handle accordingly
            setState(() {
              message = data['statusDescription'] ?? "Please try again later";
              loading = false;
            });
            return false;
          }
        }
        return false;
      }
      return false;
    } catch (e) {
      message = e.toString();
      print(e.toString());
      setState(() {
        loading = false;
      });
      // Handle other exceptions
      return false;
    }
  }

  Future<void> fetchRaysMarkup() async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      print(isUserLoggedIn);
      if (isUserLoggedIn) {
        final response = await http.get(
          Uri.https(
            "api.commercepal.com:2087",
            "/api/v1/financial/payment/rays/markups",
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        print('hererererer');
        var datas = jsonDecode(response.body);
        print(datas);
        if (response.statusCode == 200) {
          for (var i in datas) {
            myMarkups.add(RaysMarkup(
              Markup: i['markup'].toString(),
              RepaymentMonth: i['month'].toString(),
            ));

            // if (myOrders.isEmpty) {
            //   throw 'No special orders found';
          }
          print("MyMarkups");
          print(myMarkups.length);
        } else {
          throw datas['statusDescription'] ?? 'Error fetching special orders';
        }
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
