import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/string_utils.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Edahab extends StatefulWidget {
  const Edahab({super.key});

  @override
  State<Edahab> createState() => _EdahabState();
}

class _EdahabState extends State<Edahab> {
  List<String> _instructions = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args['payment_instruction'] != null) {
      _instructions =
          (args['payment_instruction'] as String).convertStringToList('data');
      setState(() {});
    }
  }

  void fetchHints() async {
    setState(() {
      loading = true;
    });

    physicalAddressHintFuture = Translations.translatedText(
        "Enter your phone number below", GlobalStrings.getGlobalString());
    pHint = await physicalAddressHintFuture;

    setState(() {
      loading = false;
    });
  }

  var physicalAddressHintFuture;
  String pHint = '';
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

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "eDahab",
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
                          var regExp1 = RegExp(r'^65\d{7}$');
                          var regExp2 = RegExp(r'^\66\d{7}$');
                          var regExp3 = RegExp(r'^\62\d{7}$');
                          var regExp4 = RegExp(r'^\76\d{7}$');

                          // Check if the entered value matches either expression
                          if (!(regExp1.hasMatch(value!) ||
                              regExp3.hasMatch(value) ||
                              regExp4.hasMatch(value) ||
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
                                      // print(pNumber);
                                    } else if (regExp2.hasMatch(pNumber!)) {
                                      pNumber = pNumber!
                                          .replaceFirst(RegExp(r'^\+'), '');
                                      // print(pNumber);
                                    }
                                    // final prefsData = getIt<PrefsData>();
                                    // final isUserLoggedIn = await prefsData
                                    //     .contains(PrefsKeys.userToken.name);
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

  Future<bool> sendData({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      // print(isUserLoggedIn);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        bool isit = await hasUserSwitchedToBusiness();
        final orderRef = await prefsData.readData("order_ref");
        // print(orderRef);
        Map<String, dynamic> payload = {
          "ServiceCode": "CHECKOUT",
          "PaymentType": "CBE-BIRR",
          "PaymentMode": "CBE-BIRR",
          "UserType": isit ? "C" : "B",
          "OrderRef": orderRef,
          "Currency": "ETB"
        };
        // print(payload);

        final response = await http.post(
          Uri.https(
            "pay.commercepal.com",
            "/payment/v1/request",
          ),
          body: jsonEncode(payload),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        // print(data);

        if (data['statusCode'] == '000') {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("epg_done", "yes");
          // print(data['PaymentUrl']);
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
