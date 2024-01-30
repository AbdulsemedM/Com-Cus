import 'dart:convert';

// import 'package:commercepal/app/data/network/api_provider.dart';
import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
// import 'package:commercepal/core/cart-core/dao/cart_dao.dart';
// import 'package:commercepal/core/cart-core/domain/cart_item.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
// import 'package:commercepal/features/otp_payments/data/otp_payment_repo_imp.dart';
// import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import '../../../core/cart-core/dao/cart_dao.dart';

class CBEBirrPayment extends StatefulWidget {
  static const routeName = "/cbebirr_payment";

  const CBEBirrPayment({super.key});

  @override
  State<CBEBirrPayment> createState() => _CBEBirrPaymentState();
}

class _CBEBirrPaymentState extends State<CBEBirrPayment> {
  @override
  void initState() {
    super.initState();
    fetchHints();
  }

  void fetchHints() async {
    setState(() {
      loading = true;
    });

    physicalAddressHintFuture = Translations.translatedText(
        "Enter your phone number below", GlobalStrings.getGlobalString());
    // subcityHint = Translations.translatedText(
    //     "Sub city", GlobalStrings.getGlobalString());
    // addAddHint = Translations.translatedText(
    //     "Add Address", GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    pHint = await physicalAddressHintFuture;
    // cHint = await subcityHint;
    // aHint = await addAddHint;
    // print("herrerererere");
    // print(pHint);
    // print(cHint);

    setState(() {
      loading = false;
    });
  }

  var physicalAddressHintFuture;
  // var subcityHint;
  // var addAddHint;
  String pHint = '';
  // String cHint = '';
  // String aHint = '';
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
          "CBE BIRR Pay",
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
                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child:
                                  loading ? Text("Loading...") : Text(pHint)),
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
                                    await sendData();
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

  Future<bool> sendData({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      print(isUserLoggedIn);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        bool isit = await hasUserSwitchedToBusiness();
        final orderRef = await prefsData.readData("order_ref");
        print(orderRef);
        Map<String, dynamic> payload = {
          "ServiceCode": "CHECKOUT",
          "PaymentType": "CBE-BIRR",
          "PaymentMode": "CBE-BIRR",
          "UserType": isit ? "C" : "B",
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
          print(data['PaymentUrl']);
          setState(() {
            loading = false;
          });
          launchUrl(data['PaymentUrl']);
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

  void launchUrl(String myUrl) async {
    try {
      String url = myUrl;

      // if (await canLaunch(url)) {
      await launch(url);
      // } else {
      // print("Could not launch $url");
      // }
    } catch (e) {
      print(e.toString());
    }
  }
}
