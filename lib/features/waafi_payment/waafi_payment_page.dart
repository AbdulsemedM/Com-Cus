import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/app/utils/string_utils.dart';
import 'package:commercepal/core/cart-core/dao/cart_dao.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
// import 'package:commercepal/core/widgets/input_decorations.dart';
import 'package:commercepal/features/dashboard/dashboard_page.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
// import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:phone_number/phone_number.dart';

class WaafiPaymentPage extends StatefulWidget {
  const WaafiPaymentPage({super.key});

  @override
  State<WaafiPaymentPage> createState() => _WaafiPaymentPageState();
}

class _WaafiPaymentPageState extends State<WaafiPaymentPage> {
  List<String> _instructions = [];
  // Country? _selectedCountry;
  // String? _cashType;
  String? _cashTypeName;
  String? currency;
  String? _prefixNumber;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!mounted) return;

    final Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
    // _cashType = args?['cash_type'];
    currency = args?['currency'];
    _cashTypeName = args?['cash_type_name'];

    // Set the prefix based on payment type
    _prefixNumber = _getPrefix(_cashTypeName);

    if (args?['payment_instruction'] != null) {
      _instructions =
          (args!['payment_instruction'] as String).convertStringToList('data');
      setState(() {});
    }
  }

  final GlobalKey<FormState> myKey = GlobalKey();
  String? pNumber;
  var loading = false;
  Widget _buildPaymentInstructions() {
    if (_instructions.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(cHint),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _instructions
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("- $e"),
                      ))
                  .toList(),
            )
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  String? _getPrefix(String? cashTypeName) {
    switch (cashTypeName) {
      case "EVC Plus":
        return "+25261";
      case "Zaad":
        return "+25263";
      case "Sahal":
        return "+25290";
      case "Waafi Djibouti":
        return "+25377";
      case "Waafi International":
        return "+97150";
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${_cashTypeName ?? "Waafi"} Payment",
          style: TextStyle(fontSize: sWidth * 0.05),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPaymentInstructions(),
            Form(
                key: myKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text("Enter your phone number below")),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 48,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(4)),
                            ),
                            child: Center(
                              child: Text(
                                _prefixNumber ?? "+?????",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              validator: (v) {
                                if (v?.isEmpty == true) {
                                  return "Phone number is required";
                                } else if (v!.length != 7) {
                                  return "Phone number must be 7 digits";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onChanged: (value) {
                                setState(() {
                                  pNumber = value;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: "1234567",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(4)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(4)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ],
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
                                    try {
                                      // final  PhoneNumberUtils phoneNumberUtils;
                                      // final isValid = await PhoneNumberUtil()
                                      //     .validate(
                                      //         _selectedCountry!.phoneCode +
                                      //             pNumber!,
                                      //         regionCode: _selectedCountry!
                                      //             .countryCode);
                                      // if (_cashTypeName == "EVC Plus") {
                                      //   final fullNumber =
                                      //       _selectedCountry!.phoneCode +
                                      //           pNumber!;
                                      //   if (!fullNumber.startsWith("25261")) {
                                      //     displaySnack(context,
                                      //         'Please enter a valid EVC Plus number starting with +25261');
                                      //     setState(() {
                                      //       loading = false;
                                      //     });
                                      //     return;
                                      //   }
                                      // } else if (_cashTypeName == "Zaad") {
                                      //   final fullNumber =
                                      //       _selectedCountry!.phoneCode +
                                      //           pNumber!;
                                      //   if (!fullNumber.startsWith("25263")) {
                                      //     displaySnack(context,
                                      //         'Please enter a valid Zaad number starting with +25263');
                                      //     setState(() {
                                      //       loading = false;
                                      //     });
                                      //     return;
                                      //   }
                                      // } else if (_cashTypeName == "Sahal") {
                                      //   final fullNumber =
                                      //       _selectedCountry!.phoneCode +
                                      //           pNumber!;
                                      //   if (!fullNumber.startsWith("25290")) {
                                      //     displaySnack(context,
                                      //         'Please enter a valid Sahal number starting with +25290');
                                      //     setState(() {
                                      //       loading = false;
                                      //     });
                                      //     return;
                                      //   }
                                      // } else if (_cashTypeName ==
                                      //     "Waafi Djibouti") {
                                      //   final fullNumber =
                                      //       _selectedCountry!.phoneCode +
                                      //           pNumber!;
                                      //   if (!fullNumber.startsWith("25377")) {
                                      //     displaySnack(context,
                                      //         'Please enter a valid Waafi Djibouti number starting with +25377');
                                      //     setState(() {
                                      //       loading = false;
                                      //     });
                                      //     return;
                                      //   }
                                      // } else if (_cashTypeName ==
                                      //     "Waafi International") {
                                      //   final fullNumber =
                                      //       _selectedCountry!.phoneCode +
                                      //           pNumber!;
                                      //   if (!fullNumber.startsWith("97150")) {
                                      //     displaySnack(context,
                                      //         'Please enter a valid Waafi International number starting with +97150');
                                      //     setState(() {
                                      //       loading = false;
                                      //     });
                                      //     return;
                                      //   }
                                      // }
                                      print(_prefixNumber!.replaceAll('+', '') +
                                          pNumber!);
                                      bool done = await sendData(
                                          phoneNumber: _prefixNumber!
                                                  .replaceAll('+', '') +
                                              pNumber!);
                                      if (done) {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                const AlertDialog(
                                                  title: Text("Payment"),
                                                  content: Text(
                                                      "Payment successful, please enter pin on the USSD screen to complete payment"),
                                                ));
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            DashboardPage.routeName,
                                            (route) => false);
                                      } else {
                                        setState(() {
                                          loading = false;
                                        });
                                        displaySnack(
                                            context, "Something went wrong");
                                      }
                                    } catch (e) {
                                      print(e.toString());
                                      displaySnack(context,
                                          'Error validating phone number');
                                      setState(() {
                                        loading = false;
                                      });
                                      return;
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.colorPrimaryDark),
                                child: FutureBuilder<String>(
                                  future: Translations.translatedText('Submit',
                                      GlobalStrings.getGlobalString()),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Text(
                                          "Loading..."); // Loading indicator while translating
                                    } else if (snapshot.hasError) {
                                      return Text(
                                        'Submit',
                                        style: TextStyle(color: Colors.white),
                                      );
                                    } else {
                                      return Text(
                                        snapshot.data ?? 'Submit',
                                        style: TextStyle(color: Colors.white),
                                      );
                                    }
                                  },
                                ),
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

  Future<bool> sendData({String? phoneNumber, int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      // print("phone number is $phoneNumber");
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      // print(isUserLoggedIn);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        // bool isit = await hasUserSwitchedToBusiness();
        final orderRef = await prefsData.readData("order_ref");
        // print(orderRef);
        Map<String, dynamic> payload = {
          "ServiceCode": "CHECKOUT",
          "PaymentType": "WAAFIPAY",
          "PaymentMode": "MOBILE_MONEY",
          "UserType": "C",
          "OrderRef": orderRef,
          // "Currency": currency ?? "USD",
          "Currency": "USD",
          "PhoneNumber": phoneNumber
        };
        print(payload);

        final response = await http.post(
          Uri.https(
            "pay.commercepal.com",
            "/payment/v1/request",
          ),
          body: jsonEncode(payload),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          final cartDao = getIt<CartDao>();
          await cartDao.nuke();
          print(data['PaymentUrl']);
          setState(() {
            loading = false;
          });
          // launchUrl(data['PaymentUrl']);
          return true;
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 1) {
            // Retry after num + 1 seconds
            // await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await sendData(
                phoneNumber: phoneNumber, retryCount: retryCount + 1);
          } else {
            // Retry limit reached, handle accordingly
            setState(() {
              loading = false;
            });
            displaySnack(context, data['statusMessage']);
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
