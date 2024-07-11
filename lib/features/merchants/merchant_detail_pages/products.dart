import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/cart-core/bloc/cart_core_cubit.dart';
import 'package:commercepal/core/cart-core/domain/cart_item.dart';
import 'package:commercepal/features/merchants/merchant_product_page.dart';
import 'package:commercepal/features/selected_product/presentation/selected_product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rate_in_stars/rate_in_stars.dart';
import 'package:http/http.dart' as http;

class MerchantProducts extends StatefulWidget {
  final String id;
  final List<MerchantProds>? products;
  const MerchantProducts({super.key, required this.id, this.products});

  @override
  State<MerchantProducts> createState() => _MerchantProductsState();
}

class _MerchantProductsState extends State<MerchantProducts> {
  var loading = false;
  List<MerchantProds> myMerchantProducts = [];
  MerchantProf? myMerchant;
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height;
    var sWidth = MediaQuery.of(context).size.width;
    return myMerchantProducts.isEmpty && loading
        ? const Padding(
            padding: EdgeInsets.fromLTRB(8.0, 20, 8, 5),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.colorAccent,
              ),
            ),
          )
        : myMerchantProducts.isEmpty && !loading
            ? const Padding(
                padding: EdgeInsets.fromLTRB(8.0, 20, 8, 5),
                child: Center(
                  child: Text("No products found."),
                ),
              )
            : Column(
                children: [
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
                                  myMerchant!
                                      .businessPhoneNumber, // Replace with your phone number
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
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return SizedBox(
                        height: sHeight * 0.65,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: sHeight > 900 ? 1 : 0.5,
                                crossAxisCount:
                                    2, // Number of columns in the grid
                                crossAxisSpacing:
                                    2.0, // Spacing between columns
                                mainAxisSpacing: 5, // Spacing between rows
                              ),
                              itemCount: myMerchantProducts.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, SelectedProductPage.routeName,
                                        arguments: {
                                          "p_id": int.parse(
                                              myMerchantProducts[index]
                                                  .productId)
                                        });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      height: sHeight * 0.4,
                                      width: sWidth * 0.5,
                                      decoration: const BoxDecoration(
                                        color: AppColors.greyColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 4, 0, 4),
                                            child: Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(12),
                                                        topRight:
                                                            Radius.circular(
                                                                12)),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  height: 120,
                                                  placeholder: (_, __) =>
                                                      Container(
                                                    color: AppColors.bg1,
                                                  ),
                                                  errorWidget: (_, __, ___) =>
                                                      Container(
                                                    color: Colors.grey,
                                                  ),
                                                  imageUrl:
                                                      myMerchantProducts[index]
                                                          .mobileThumbnail,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: Text(
                                              myMerchantProducts[index]
                                                  .productName,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall
                                                  ?.copyWith(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                          ),
                                          // Row(
                                          //   children: [
                                          //     Padding(
                                          //       padding:
                                          //           const EdgeInsets.only(
                                          //               left: 8.0,
                                          //               right: 8.0,
                                          //               top: 8,
                                          //               bottom: 8),
                                          //       child: Text(
                                          //         "Old Price",
                                          //         maxLines: 2,
                                          //         overflow:
                                          //             TextOverflow.ellipsis,
                                          //         style: Theme.of(context)
                                          //             .textTheme
                                          //             .displaySmall
                                          //             ?.copyWith(
                                          //                 fontSize: 14.sp,
                                          //                 fontWeight:
                                          //                     FontWeight
                                          //                         .normal),
                                          //       ),
                                          //     ),
                                          //     Padding(
                                          //       padding:
                                          //           const EdgeInsets.only(
                                          //               left: 8.0,
                                          //               right: 8.0,
                                          //               top: 8,
                                          //               bottom: 8),
                                          //       child: Text(
                                          //         "${myMerchantProducts[index].actualPrice} ETB",
                                          //         maxLines: 2,
                                          //         overflow:
                                          //             TextOverflow.ellipsis,
                                          //         style: Theme.of(context)
                                          //             .textTheme
                                          //             .displaySmall
                                          //             ?.copyWith(
                                          //                 decoration:
                                          //                     TextDecoration
                                          //                         .lineThrough,
                                          //                 fontSize: 14.sp,
                                          //                 fontWeight:
                                          //                     FontWeight
                                          //                         .normal),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                    top: 8,
                                                    bottom: 8),
                                                child: Text(
                                                  "Price",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall
                                                      ?.copyWith(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                    top: 8,
                                                    bottom: 8),
                                                child: Text(
                                                  "${myMerchantProducts[index].actualPrice} ETB",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall
                                                      ?.copyWith(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                    top: 8,
                                                    bottom: 8),
                                                child: Text(
                                                  "Min. Order",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall
                                                      ?.copyWith(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                    top: 8,
                                                    bottom: 8),
                                                child: Text(
                                                  "${myMerchantProducts[index].minOrder} ",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall
                                                      ?.copyWith(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                    top: 8,
                                                    bottom: 8),
                                                child: Text(
                                                  "Max. Order",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall
                                                      ?.copyWith(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                    top: 8,
                                                    bottom: 8),
                                                child: Text(
                                                  "${myMerchantProducts[index].maxOrder} ",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall
                                                      ?.copyWith(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                ),
                                              ),
                                            ],
                                          ),
                                          RatingStars(
                                              rating: 4.0, editable: true),
                                          SizedBox(
                                            width: sWidth * 0.5,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(AppColors
                                                                .colorPrimaryDark),
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                12.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                12.0),
                                                      ),
                                                    ))),
                                                onPressed: () {
                                                  CartItem myItem = CartItem(
                                                      productId: int.parse(
                                                          myMerchantProducts![index]
                                                              .productId),
                                                      name:
                                                          myMerchantProducts[index]
                                                              .productName,
                                                      image:
                                                          myMerchantProducts[index]
                                                              .mobileThumbnail,
                                                      description: '-',
                                                      price:
                                                          myMerchantProducts[index]
                                                              .actualPrice,
                                                      currency: "ETB",
                                                      subProductId: int.parse(
                                                          myMerchantProducts[index]
                                                              .subProductId),
                                                      quantity: int.parse(
                                                          myMerchantProducts[index]
                                                              .minOrder));
                                                  context
                                                      .read<CartCoreCubit>()
                                                      .addCartItem(myItem);
                                                  displaySnack(context,
                                                      "${myMerchantProducts[index].productName} added to cart");
                                                },
                                                child: const Text(
                                                  "Add to Cart",
                                                  style: TextStyle(
                                                      color: AppColors.bg1),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      );
                    },
                  )
                ],
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
        setState(() {
          for (var i in datas['data']['products']) {
            myMerchantProducts.add(MerchantProds(
              productId: i['ProductId'].toString(),
              subProductId: i['subProductId'].toString(),
              minOrder: i['minOrder'].toString(),
              maxOrder: i['maxOrder'].toString(),
              isOnFlashSale: i['isOnFlashSale'].toString(),
              productName: i['productName'].toString(),
              unique_id: i['unique_id'].toString(),
              mobileThumbnail: i['mobileImage'].toString(),
              actualPrice: i['actualPrice'].toString(),
              discountDescription: i['discountDescription'].toString(),
              productRating: i['productRating'].toString(),
            ));
            // if (myOrders.isEmpty) {
            //   throw 'No special orders found';
          }
        });
        print(myMerchantProducts.length);
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
        // print(myMerchant!.merchantName);
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
