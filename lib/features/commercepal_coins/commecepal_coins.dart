import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/commercepal_coins/withdraw_coins_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CommecepalCoins extends StatefulWidget {
  const CommecepalCoins({super.key});

  @override
  State<CommecepalCoins> createState() => _CommecepalCoinsState();
}

class WalletTransactionData {
  final String Narration;
  final String TransDate;
  final String Currency;
  final String TransRef;
  final String Amount;
  final String TransType;
  WalletTransactionData(
      {required this.Narration,
      required this.Currency,
      required this.Amount,
      required this.TransDate,
      required this.TransType,
      required this.TransRef});
}

class _CommecepalCoinsState extends State<CommecepalCoins> {
  var loading = false;
  String? balance;
  List<WalletTransactionData> trnxs = [];
  @override
  void initState() {
    super.initState();
    fetchTrnxsdata();
    fetchFloatingBalance();
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      body: Stack(children: [
        SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: sWidth * 1,
                decoration: const BoxDecoration(color: AppColors.greyColor),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Floating Balance",
                          style: TextStyle(fontSize: sWidth * 0.04)),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "Balance",
                  style: TextStyle(fontSize: sWidth * 0.05),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text("${balance ?? 0}",
                    style: TextStyle(fontSize: sWidth * 0.06)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  width: sWidth * 1,
                  decoration: const BoxDecoration(color: AppColors.greyColor),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Transactions",
                            style: TextStyle(fontSize: sWidth * 0.04)),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: sHeight * 0.75,
                child: loading && trnxs.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CircularProgressIndicator(
                              color: AppColors.colorPrimaryDark,
                            ),
                          ),
                          Text("Fetching Transactions")
                        ],
                      )
                    : SizedBox(
                        height: sHeight * 0.5,
                        child: ListView.builder(
                            itemCount: trnxs.length,
                            itemBuilder: (BuildContext, index) {
                              return Card(
                                shadowColor: AppColors.colorAccent,
                                elevation: 2,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(trnxs[index].TransRef),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  trnxs[index].TransType,
                                                  style: TextStyle(
                                                      fontSize: sWidth * 0.02)),
                                            ),
                                            Text(trnxs[index].Narration,
                                                style: TextStyle(
                                                    fontSize: sWidth * 0.03)),
                                          ],
                                        ),
                                        Text(
                                            "${trnxs[index].Amount} ${trnxs[index].Currency}",
                                            style: TextStyle(
                                                fontSize: sWidth * 0.04,
                                                color: AppColors.purple)),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Divider(
                                        thickness: sHeight * 0.001,
                                      ),
                                    ),
                                    Text(
                                        DateFormat('dd MMM, HH:mm').format(
                                            DateTime.parse(
                                                trnxs[index].TransDate)),
                                        style:
                                            TextStyle(fontSize: sWidth * 0.03))
                                  ],
                                ),
                              );
                            }),
                      ),
              )
            ],
          ),
        )),
        Positioned(
          bottom: sHeight * 0.01,
          right: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorPrimaryDark),
              onPressed: () {
                var result = Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WithdrawCoinsPage()));
                if (result != null) {
                  fetchFloatingBalance();
                  fetchTrnxsdata();
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.wallet_rounded,
                    color: AppColors.bg1,
                  ),
                  Text(
                    'Withdraw',
                    style: TextStyle(
                      color: AppColors.bg1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> fetchTrnxsdata({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.get(
          Uri.https(
            "api.commercepal.com:2095",
            "/prime/api/v1/customer/accounts/commission-transactions",
            {"pageNumber": '20'},
          ),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        // print(data);

        if (data['Status'] == '000') {
          setState(() {
            for (var datas in data['data']) {
              trnxs.add(WalletTransactionData(
                  TransType: datas['TransType'],
                  TransRef: datas['TransRef'],
                  Amount: datas['Amount'].toString(),
                  Currency: datas['Currency'],
                  Narration: datas['Narration'],
                  TransDate: datas['TransDate']));
            }
            loading = false;
          });
          print(trnxs.length);
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await fetchTrnxsdata(retryCount: retryCount + 1);
          } else {
            // Retry limit reached, handle accordingly
            setState(() {
              loading = false;
            });
          }
        }
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
      // Handle other exceptions
    }
  }

  Future<void> fetchFloatingBalance({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.get(
          Uri.https(
            "api.commercepal.com:2095",
            "/prime/api/v1/customer/accounts/commission-balance",
          ),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        // print(data);

        if (data['statusCode'] == '000') {
          setState(() {
            balance = data['balance'].toString();
            loading = false;
          });
          // Handle the case when statusCode is '000'
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await fetchFloatingBalance(retryCount: retryCount + 1);
          } else {
            setState(() {
              loading = true;
            });
            // Retry limit reached, handle accordingly
          }
        }
      }
    } catch (e) {
      setState(() {
        loading = true;
      });
      print(e.toString());

      // Handle other exceptions
    }
  }
}
