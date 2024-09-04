import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/features/merchants/merchant_product_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AboutMerchant extends StatefulWidget {
  final String id;
  const AboutMerchant({super.key, required this.id});

  @override
  State<AboutMerchant> createState() => _AboutMerchantState();
}

class _AboutMerchantState extends State<AboutMerchant> {
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  var loading = false;
  MerchantProf? myMerchant;
  @override
  Widget build(BuildContext context) {
    return myMerchant == null && loading
        ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.colorAccent,
            ),
          )
        : myMerchant == null && !loading
            ? const Center(
                child: Text("Merchant data not found"),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                          "Merchant or Business name: ${myMerchant!.merchantName}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                          "Business Phone Number: ${myMerchant!.businessPhoneNumber}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Business City: ${myMerchant!.cityName}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                          "Business Address: ${myMerchant!.physicalAddress != "" ? myMerchant!.physicalAddress : "-"}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Shop Image:"),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            height: 120,
                            placeholder: (_, __) => Container(
                              color: AppColors.bg1,
                            ),
                            errorWidget: (_, __, ___) => Stack(
                              children: [
                                Image.asset(
                                  'assets/images/shop_image.jpg',
                                  fit: BoxFit.fill,
                                  height: 120,
                                  width: double.infinity,
                                ),
                                Container(
                                  color: Colors.white.withOpacity(0.8),
                                  height: 120,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text(
                                    myMerchant!.businessPhoneNumber, // Replace with your phone number
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            imageUrl: myMerchant!.shopImage,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }

  Future<void> fetchProducts() async {
    try {
      setState(() {
        loading = true;
      });
      final response = await http.get(
        Uri.https(
          "api.commercepal.com:2096",
          "/prime/api/v1/merchant/${widget.id}/products",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('herererererinabout');
      var datas = jsonDecode(response.body);
      print(datas);
      if (datas['statusCode'] == "000") {
        print("hereare");
        // setState(() {
        //   for (var i in datas['data']['products']) {
        //     myMerchantProducts.add(MerchantProds(
        //       productId: i['ProductId'].toString(),
        //       subProductId: i['subProductId'].toString(),
        //       minOrder: i['minOrder'].toString(),
        //       maxOrder: i['maxOrder'].toString(),
        //       isOnFlashSale: i['isOnFlashSale'].toString(),
        //       productName: i['productName'].toString(),
        //       unique_id: i['unique_id'].toString(),
        //       mobileThumbnail: i['mobileImage'].toString(),
        //       actualPrice: i['actualPrice'].toString(),
        //       discountDescription: i['discountDescription'].toString(),
        //       productRating: i['productRating'].toString(),
        //     ));
        //     // if (myOrders.isEmpty) {
        //     //   throw 'No special orders found';
        //   }
        // });
        // print(myMerchantProducts.length);
        setState(() {
          myMerchant = MerchantProf(
              merchantName: datas['data']['merchantAbout']['merchantName'],
              businessPhoneNumber: datas['data']['merchantAbout']
                  ['businessPhoneNumber'],
              cityName: datas['data']['merchantAbout']['cityName'],
              physicalAddress: datas['data']['merchantAbout']
                  ['physicalAddress'],
              shopImage: datas['data']['merchantAbout']['shopImage']);
        });
        print(myMerchant!.merchantName);
        setState(() {
          loading = false;
        });
      } else {
        throw datas['statusDescription'] ?? 'Error fetching special orders';
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
