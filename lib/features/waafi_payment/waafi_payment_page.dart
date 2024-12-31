import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/app/utils/string_utils.dart';
import 'package:commercepal/core/cart-core/dao/cart_dao.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/core/widgets/input_decorations.dart';
import 'package:commercepal/features/dashboard/dashboard_page.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phone_number/phone_number.dart';

class WaafiPaymentPage extends StatefulWidget {
  const WaafiPaymentPage({super.key});

  @override
  State<WaafiPaymentPage> createState() => _WaafiPaymentPageState();
}

class _WaafiPaymentPageState extends State<WaafiPaymentPage> {
  List<String> _instructions = [];
  Country? _selectedCountry;
  // String? _cashType;
  String? _cashTypeName;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!mounted) return;

    final Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
    // _cashType = args?['cash_type'];
    _cashTypeName = args?['cash_type_name'];
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
                              showCountryPicker(
                                context: context,
                                showPhoneCode: true,
                                searchAutofocus: true,
                                onSelect: (Country country) {
                                  setState(() {
                                    _selectedCountry = country;
                                  });
                                },
                                countryListTheme: CountryListThemeData(
                                  flagSize: 25,
                                  backgroundColor: Colors.white,
                                  textStyle: const TextStyle(fontSize: 16),
                                  bottomSheetHeight: 500,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                  ),
                                  inputDecoration: InputDecoration(
                                    labelText: 'Search',
                                    hintText: 'Start typing to search',
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: const Color(0xFF8C98A8)
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                  ),
                                ),
                              );
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
                                    try {
                                      // final  PhoneNumberUtils phoneNumberUtils;
                                      final isValid = await PhoneNumberUtil()
                                          .validate(
                                              _selectedCountry!.phoneCode +
                                                  pNumber!,
                                              regionCode: _selectedCountry!
                                                  .countryCode);
                                      if (_cashTypeName == "EVC Plus") {
                                        final fullNumber =
                                            _selectedCountry!.phoneCode +
                                                pNumber!;
                                        if (!fullNumber.startsWith("25261")) {
                                          displaySnack(context,
                                              'Please enter a valid EVC Plus number starting with +25261');
                                          setState(() {
                                            loading = false;
                                          });
                                          return;
                                        }
                                      } else if (_cashTypeName == "Zaad") {
                                        final fullNumber =
                                            _selectedCountry!.phoneCode +
                                                pNumber!;
                                        if (!fullNumber.startsWith("25263")) {
                                          displaySnack(context,
                                              'Please enter a valid Zaad number starting with +25263');
                                          setState(() {
                                            loading = false;
                                          });
                                          return;
                                        }
                                      } else if (_cashTypeName == "Sahal") {
                                        final fullNumber =
                                            _selectedCountry!.phoneCode +
                                                pNumber!;
                                        if (!fullNumber.startsWith("25290")) {
                                          displaySnack(context,
                                              'Please enter a valid Sahal number starting with +25290');
                                          setState(() {
                                            loading = false;
                                          });
                                          return;
                                        }
                                      } else if (_cashTypeName ==
                                          "Waafi Djibouti") {
                                        final fullNumber =
                                            _selectedCountry!.phoneCode +
                                                pNumber!;
                                        if (!fullNumber.startsWith("25377")) {
                                          displaySnack(context,
                                              'Please enter a valid Waafi Djibouti number starting with +25377');
                                          setState(() {
                                            loading = false;
                                          });
                                          return;
                                        }
                                      } else if (_cashTypeName ==
                                          "Waafi International") {
                                        final fullNumber =
                                            _selectedCountry!.phoneCode +
                                                pNumber!;
                                        if (!fullNumber.startsWith("97150")) {
                                          displaySnack(context,
                                              'Please enter a valid Waafi International number starting with +97150');
                                          setState(() {
                                            loading = false;
                                          });
                                          return;
                                        }
                                      }
                                      if (!isValid) {
                                        displaySnack(context,
                                            'Invalid phone number format');
                                        setState(() {
                                          loading = false;
                                        });
                                        return;
                                      } else {
                                        bool done = await sendData(
                                            phoneNumber:
                                                _selectedCountry!.phoneCode +
                                                    pNumber!);
                                        if (done) {
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
          "PaymentType": "WAAFIPAY",
          "PaymentMode": "MOBILE_MONEY",
          "UserType": isit ? "C" : "B",
          "OrderRef": orderRef,
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
}
