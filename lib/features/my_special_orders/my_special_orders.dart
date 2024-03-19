import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/my_special_orders/add_special_orders.dart';
import 'package:commercepal/features/my_special_orders/special_orders_merchant_bid.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NewSpecialOrders extends StatefulWidget {
  const NewSpecialOrders({super.key});

  @override
  State<NewSpecialOrders> createState() => _NewSpecialOrdersState();
}

class mySpecialOrders {
  final num status;
  final String requestDate;
  final String description;
  final String productName;
  final String imageOne;
  final int specialOrderId;
  final String linkToProduct;
  mySpecialOrders(
      {required this.status,
      required this.requestDate,
      required this.description,
      required this.productName,
      required this.imageOne,
      required this.specialOrderId,
      required this.linkToProduct});
}

class _NewSpecialOrdersState extends State<NewSpecialOrders> {
  var loading = false;
  List<mySpecialOrders> myOrders = [];
  @override
  void initState() {
    super.initState();
    fetchSpecialOrders();
    // _initOneSignal();
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    // var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: Translations.translatedText(
              "Special Orders", GlobalStrings.getGlobalString()),
          //  translatedText("Log Out", 'en', dropdownValue),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text(
                snapshot.data ?? 'Default Text',
              );
            } else {
              return Text(
                'Loading...',
              ); // Or any loading indicator
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddSpecialOrders()));
            },
            child: FutureBuilder<String>(
              future: Translations.translatedText(
                  "Add", GlobalStrings.getGlobalString()),
              //  translatedText("Log Out", 'en', dropdownValue),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(snapshot.data ?? 'Default Text',
                      style: TextStyle(color: AppColors.colorPrimaryDark));
                } else {
                  return Text('Loading...',
                      style: TextStyle(
                          color: AppColors
                              .colorPrimaryDark)); // Or any loading indicator
                }
              },
            ),
          )
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(children: [
          !loading && myOrders.isEmpty
              ? SizedBox(
                  height: sHeight * 0.9,
                  child: Column(
                    children: [
                      Center(
                        child: Center(child: Text('No speacial orders found.')),
                      ),
                    ],
                  ),
                )
              : loading && myOrders.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.colorPrimaryDark,
                      ),
                    )
                  : SizedBox(
                      height: sHeight * 0.9,
                      child: ListView.separated(
                        itemCount: myOrders.length,
                        separatorBuilder: (_, __) => const SizedBox(
                          height: 14,
                        ),
                        itemBuilder: (BuildContext context, int index) =>
                            GestureDetector(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => MerchantBids(
                                        specialOrderId: myOrders[index]
                                            .specialOrderId
                                            .toString()))));
                          },
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (myOrders[index].imageOne != null)
                                      CachedNetworkImage(
                                        imageUrl: myOrders[index].imageOne!,
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.fill,
                                        placeholder: (_, __) => Container(
                                          color: Colors.grey,
                                        ),
                                        errorWidget: (_, __, ___) => Container(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    if (myOrders[index].imageOne != null)
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    Text(
                                      myOrders[index].productName!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  myOrders[index].description!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  myOrders[index].linkToProduct!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    FutureBuilder<String>(
                                      future: Translations.translatedText(
                                          "Status: ",
                                          GlobalStrings.getGlobalString()),
                                      //  translatedText("Log Out", 'en', dropdownValue),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return Text(
                                            snapshot.data ?? 'Default Text',
                                          );
                                        } else {
                                          return Text(
                                            'Loading...',
                                          ); // Or any loading indicator
                                        }
                                      },
                                    ),
                                    Text(
                                      myOrders[index].status.toString() == '0'
                                          ? "Order placed successfully"
                                          : 'Order delivred successfully',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
        ]),
      )),
    );
  } 

  // Future<void> _initOneSignal() async {
  //   await OneSignal.shared.setAppId('c02d769f-6576-472a-8eb1-cd5d300e53b9');
  //   OneSignal.shared
  //       .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
  //     // Handle notification opened
  //   });

  //   // Retrieve the device token
  //   String deviceToken = await OneSignal.shared
  //       .getDeviceState()
  //       .then((value) => value?.userId ?? "");
  //   setState(() {
  //     String _deviceToken = deviceToken;
  //     debugPrint("here is the token");
  //     debugPrint(_deviceToken);
  //   });
  // }

  Future<void> fetchSpecialOrders() async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      print(isUserLoggedIn);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.get(
          Uri.https(
            "api.commercepal.com:2096",
            "/prime/api/v1/special-orders/my-requests",
          ),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        print('hererererer');
        var datas = jsonDecode(response.body);
        print(datas);
        if (datas['statusCode'] == "000") {
          for (var i in datas['data']) {
            if (i['status'] != 3) {
              myOrders.add(mySpecialOrders(
                  status: i['status'] ?? 0,
                  requestDate: i['requestDate'] ?? '',
                  description: i['description'] ?? '',
                  productName: i['productName'] ?? '',
                  imageOne: i['imageOne'] ?? '',
                  specialOrderId: i['specialOrderId'] ?? '',
                  linkToProduct: i['linkToProduct'] ?? ''));
            }
            // if (myOrders.isEmpty) {
            //   throw 'No special orders found';
          }
          print(myOrders.length);
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
