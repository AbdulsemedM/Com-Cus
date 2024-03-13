import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/cart-core/bloc/cart_core_cubit.dart';
import 'package:commercepal/core/cart-core/domain/cart_item.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MerchantBids extends StatefulWidget {
  // final String bidId;
  final String specialOrderId;
  const MerchantBids({required this.specialOrderId, super.key});

  @override
  State<MerchantBids> createState() => _MerchantBidsState();
}

class BidData {
  final String bidId;
  final String offerDetails;
  final String offerExpirationDate;
  final String offerPrice;
  BidData(
      {required this.bidId,
      required this.offerDetails,
      required this.offerExpirationDate,
      required this.offerPrice});
}

class _MerchantBidsState extends State<MerchantBids> {
  var loading = false;
  List<BidData> myBids = [];
  @override
  void initState() {
    super.initState();
    fetchSpecialBids();
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(title: Text("Merchant Bids")),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: sHeight * 0.9,
              child: !loading && myBids.isEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Center(child: Text("No bids found"))],
                    )
                  : loading && myBids.isEmpty
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: CircularProgressIndicator(
                                color: AppColors.colorPrimaryDark,
                              ),
                            ),
                            Text("Fetching Bids")
                          ],
                        )
                      : SizedBox(
                          height: sHeight * 0.5,
                          child: ListView.builder(
                              itemCount: myBids.length,
                              itemBuilder: (BuildContext, index) {
                                return GestureDetector(
                                  onTap: () {
                                    editModal(myBids[index]);
                                  },
                                  child: Card(
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
                                                Text(
                                                    myBids[index].offerDetails),
                                                // Padding(
                                                //   padding: const EdgeInsets.all(8.0),
                                                //   child: Text(
                                                //       myBids[index].offerPrice,
                                                //       style: TextStyle(
                                                //           fontSize: sWidth * 0.02)),
                                                // ),
                                                // Text(myBids[index].offerPrice,
                                                //     style: TextStyle(
                                                //         fontSize: sWidth * 0.03)),
                                              ],
                                            ),
                                            Text(
                                                "${myBids[index].offerPrice} ETB",
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
                                            'Offer expires on ${DateFormat('dd MMM,').format(DateTime.parse(myBids[index].offerExpirationDate))}',
                                            style: TextStyle(
                                                fontSize: sWidth * 0.03))
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
            )
          ],
        ),
      )),
    );
  }

  Future<void> fetchSpecialBids() async {
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
            "/prime/api/v1/special-orders/merchant-bids",
            {'specialProductOrderId': widget.specialOrderId},
          ),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        print(widget.specialOrderId);
        var datas = jsonDecode(response.body);
        print(datas);
        if (datas['statusCode'] == "000") {
          myBids.clear();
          for (var i in datas['data']) {
            myBids.add(BidData(
              offerPrice: i['offerPrice'].toString() ?? '0',
              offerExpirationDate: i['offerExpirationDate'] ?? '',
              offerDetails: i['offerDetails'] ?? '',
              bidId: i['bidId'].toString() ?? '0',
            ));
          }
          // if (myBids.isEmpty) {
          //   throw 'No special orders found';
          // }
          print(myBids.length);
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

  void editModal(BidData allBids) {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    var loading1 = false;
    // bool selectedProxy = allMember.proxy;
    // print(selectedProxy);
    // fullNameController.text = allMember.fullName;
    // phoneNumberController.text = allMember.phoneNumber;
    String? _validateField(String? value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      }
      return null;
    }

    showDialog(
      context: context, // Pass the BuildContext to showDialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Accept Bid'), // Set your dialog title
          content: const Text('Do you want to accept this bid?'),
          // content: Text(allMember.fullName), // Set your dialog content
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 2, 0, 8),
              child: TextFormField(
                validator: _validateField,
                controller: fullNameController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: AppColors.colorPrimaryDark),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: AppColors.colorPrimaryDark),
                  ),
                  labelText: "Feed-back",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                validator: _validateField,
                controller: phoneNumberController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: AppColors.colorPrimaryDark),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: AppColors.colorPrimaryDark),
                  ),
                  labelText: "Additional Note",
                ),
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    if (fullNameController.text.isEmpty) {
                      displaySnack(context, "feedback is mandatory");
                    } else if (phoneNumberController.text.isEmpty) {
                      displaySnack(context, "Additional note is neccessary");
                    } else {
                      setState(() {
                        loading = true;
                      });
                      final body = {
                        "bidId": int.parse(allBids.bidId),
                        "specialOrderId": int.parse(widget.specialOrderId),
                        "isSelected": 1,
                        "customerFeedback": fullNameController.text,
                        "additionalNote": phoneNumberController.text
                      };
                      print(body);
                      try {
                        final prefsData = getIt<PrefsData>();
                        final isUserLoggedIn =
                            await prefsData.contains(PrefsKeys.userToken.name);
                        if (isUserLoggedIn) {
                          final token = await prefsData
                              .readData(PrefsKeys.userToken.name);
                          final response = await http.post(
                              Uri.https("api.commercepal.com:2096",
                                  "prime/api/v1/special-orders/bid/respond-by-customer"),
                              body: jsonEncode(body),
                              headers: <String, String>{
                                "Authorization": "Bearer $token"
                              });
                          // print(response.body);
                          var data = jsonDecode(response.body);
                          print(data);

                          if (data['statusCode'] == '000') {
                            var unitPrice = data['data']['unitPrice'];
                            var quantity = data['data']['quantity'];
                            var productImage = data['data']['productImage'];
                            var unique_id = data['data']['unique_id'];
                            int productId = data['data']['productId'];
                            var totalPrice = data['data']['totalPrice'];
                            var subProductId = data['data']['subProductId'];

                            CartItem myItem = CartItem(
                                productId: productId,
                                name: "Special Order",
                                image: productImage,
                                description: '-',
                                price: totalPrice.toString(),
                                currency: "ETB",
                                subProductId: subProductId,
                                quantity: quantity);
                            context.read<CartCoreCubit>().addCartItem(myItem);
                            debugPrint("added successfully");
                            displaySnack(
                                context, "Special order added to cart");

                            Navigator.pop(context);
                            fetchSpecialBids();
                            setState(() {
                              loading = false;
                            });
                            // return true;
                          } else {
                            setState(() {
                              loading = false;
                            });
                          }
                        }
                      } catch (e) {
                        var message = e.toString();
                        'Please check your network connection';
                        displaySnack(context, message);
                      } finally {
                        setState(() {
                          loading = false;
                        });
                      }
                    }
                  },
                  child: loading1
                      ? const CircularProgressIndicator(
                          color: Colors.orange,
                        )
                      : Text(
                          'Accept',
                        ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"))
              ],
            ),
          ],
        );
      },
    );
  }
}
