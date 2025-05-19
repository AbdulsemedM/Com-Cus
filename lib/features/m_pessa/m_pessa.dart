import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/app/utils/string_utils.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/core/widgets/input_decorations.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class M_Pessa extends StatefulWidget {
  const M_Pessa({super.key});

  @override
  State<M_Pessa> createState() => _M_PessaState();
}

class _M_PessaState extends State<M_Pessa> {
  List<String> _instructions = [];
  final Country? _selectedCountry = Country(
    name: "Ethiopia",
    countryCode: "ET",
    phoneCode: "251",
    e164Key: "251",
    e164Sc: 251,
    geographic: true,
    level: 1,
    example: "251911111111",
    displayName: "Ethiopia",
    displayNameNoCountryCode: "Ethiopia",
  );
  @override
  void initState() {
    super.initState();
    fetchHints();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!mounted) return;

    final Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args?['payment_instruction'] != null) {
      _instructions =
          (args!['payment_instruction'] as String).convertStringToList('data');
      setState(() {});
    }
  }

  void fetchHints() async {
    if (!mounted) return;

    setState(() {
      loading = true;
    });

    try {
      physicalAddressHintFuture = Translations.translatedText(
          "Enter your phone number below", GlobalStrings.getGlobalString());
      pHint = await physicalAddressHintFuture;
    } catch (e) {
      print('Error fetching hints: $e');
      pHint = "Enter your phone number below"; // Fallback text
    }

    if (!mounted) return;
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
          "M-Pessa",
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
                      const Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text("Enter your phone number below")),
                        ],
                      ),
                      Row(children: [
                        // Country selector
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            onTap: () {
                              // showCountryPicker(
                              //   context: context,
                              //   showPhoneCode: true,
                              //   searchAutofocus: true,
                              //   onSelect: (Country country) {
                              //     setState(() {
                              //       _selectedCountry = country;
                              //     });
                              //   },
                              //   countryListTheme: CountryListThemeData(
                              //     flagSize: 25,
                              //     backgroundColor: Colors.white,
                              //     textStyle: const TextStyle(fontSize: 16),
                              //     bottomSheetHeight: 500,
                              //     borderRadius: const BorderRadius.only(
                              //       topLeft: Radius.circular(20.0),
                              //       topRight: Radius.circular(20.0),
                              //     ),
                              //     inputDecoration: InputDecoration(
                              //       labelText: 'Search',
                              //       hintText: 'Start typing to search',
                              //       prefixIcon: const Icon(Icons.search),
                              //       border: OutlineInputBorder(
                              //         borderSide: BorderSide(
                              //           color: const Color(0xFF8C98A8)
                              //               .withOpacity(0.2),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_selectedCountry != null) ...[
                                    Text(_selectedCountry!.flagEmoji),
                                    const SizedBox(width: 8),
                                    Text('+${_selectedCountry!.phoneCode}'),
                                  ] else
                                    const Text('🏳️ +?'),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Phone number input field
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            validator: (v) {
                              if (v?.isEmpty == true) {
                                return "Phone number is required";
                              }
                              if (_selectedCountry == null) {
                                return "Please select country";
                              }
                              if (v?.length != 9) {
                                return "Phone number must be 9 digits";
                              }
                              if (v?.startsWith('7') != true) {
                                return "Phone number must start with 7";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              setState(() {
                                pNumber = value;
                                final completePhoneNumber =
                                    '${_selectedCountry?.phoneCode}$pNumber';
                                print(
                                    "completePhoneNumber: $completePhoneNumber");
                              });
                            },
                            decoration: buildInputDecoration("Phone number"),
                          ),
                        ),
                      ]),
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
                                    var regExp2 = RegExp(r'^\+');
                                    if (regExp2.hasMatch(pNumber!)) {
                                      pNumber = pNumber!
                                          .replaceFirst(RegExp(r'^\+'), '');
                                    }
                                    if (pNumber!.startsWith('7') == true) {
                                      pNumber = _selectedCountry!.phoneCode +
                                          pNumber!;
                                    }
                                    // final prefsData = getIt<PrefsData>();
                                    // final isUserLoggedIn = await prefsData
                                    //     .contains(PrefsKeys.userToken.name);
                                    print(pNumber);
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
          "PaymentType": "M_PESA",
          "PaymentMode": "M_PESA",
          "UserType": isit ? "C" : "B",
          "OrderRef": orderRef,
          "Currency": "ETB",
          "PhoneNumber": pNumber
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
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("epg_done", "yes");
          // print(data['PaymentUrl']);
          setState(() {
            loading = false;
          });
          // launchUrl(data['PaymentUrl']);
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
            displaySnack(context, data['statusMessage']);
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
