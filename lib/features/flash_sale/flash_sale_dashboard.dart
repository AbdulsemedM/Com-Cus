import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/cart-core/bloc/cart_core_cubit.dart';
import 'package:commercepal/core/cart-core/domain/cart_item.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/selected_product/presentation/selected_product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:rate_in_stars/rate_in_stars.dart';
import 'package:commercepal/app/utils/logger.dart';

class FlashSaleDashboard extends StatefulWidget {
  const FlashSaleDashboard({super.key});

  @override
  State<FlashSaleDashboard> createState() => _FlashSaleDashboardState();
}

class FlashSaleProducts {
  final String productId;
  final String productName;
  final String mobileThumbnail;
  final String actualPrice;
  final String flashSalePrice;
  final String minOrder;
  final String maxOrder;
  final String isOnFlashSale;
  final String unique_id;
  final String discountDescription;
  final String productRating;
  final String subProductId;
  FlashSaleProducts(
      {required this.flashSalePrice,
      required this.minOrder,
      required this.maxOrder,
      required this.isOnFlashSale,
      required this.unique_id,
      required this.productId,
      required this.productName,
      required this.mobileThumbnail,
      required this.discountDescription,
      required this.productRating,
      required this.subProductId,
      required this.actualPrice});
}

class _FlashSaleDashboardState extends State<FlashSaleDashboard> {
  var loading = false;
  List<FlashSaleProducts> myFlashSaleProducts = [];
  @override
  void initState() {
    super.initState();
    fetchFlashSaleProducts();
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height;
    var sWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flash Sale",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Let's help you buy in a flash",
                style: TextStyle(fontSize: 20),
              ),
            ),
            loading == false && myFlashSaleProducts.isEmpty
                ? SizedBox(
                    height: sHeight * 0.9,
                    child: const Column(
                      children: [
                        Center(
                          child:
                              Center(child: Text('No flash products found.')),
                        ),
                      ],
                    ),
                  )
                : loading && myFlashSaleProducts.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.colorPrimaryDark,
                        ),
                      )
                    : LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return SizedBox(
                            height: sHeight * 0.85,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: sHeight > 896 ? 2 : 0.5,
                                    crossAxisCount:
                                        2, // Number of columns in the grid
                                    crossAxisSpacing:
                                        2.0, // Spacing between columns
                                    mainAxisSpacing: 5, // Spacing between rows
                                  ),
                                  itemCount: myFlashSaleProducts.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            SelectedProductPage.routeName,
                                            arguments: {
                                              "p_id": int.parse(
                                                  myFlashSaleProducts[index]
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
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 4, 0, 4),
                                                child: Center(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    12),
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
                                                      errorWidget:
                                                          (_, __, ___) =>
                                                              Container(
                                                        color: Colors.grey,
                                                      ),
                                                      imageUrl:
                                                          myFlashSaleProducts[
                                                                  index]
                                                              .mobileThumbnail,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8.0),
                                                child: Text(
                                                  myFlashSaleProducts[index]
                                                      .productName,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall
                                                      ?.copyWith(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0,
                                                            top: 8,
                                                            bottom: 8),
                                                    child: Text(
                                                      "Old Price",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displaySmall
                                                          ?.copyWith(
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0,
                                                            top: 8,
                                                            bottom: 8),
                                                    child: Text(
                                                      "${myFlashSaleProducts[index].actualPrice} ETB",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displaySmall
                                                          ?.copyWith(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0,
                                                            top: 8,
                                                            bottom: 8),
                                                    child: Text(
                                                      "Flash Price",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displaySmall
                                                          ?.copyWith(
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0,
                                                            top: 8,
                                                            bottom: 8),
                                                    child: Text(
                                                      "${myFlashSaleProducts[index].flashSalePrice} ETB",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displaySmall
                                                          ?.copyWith(
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0,
                                                            top: 8,
                                                            bottom: 8),
                                                    child: Text(
                                                      "${myFlashSaleProducts[index].minOrder} ",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displaySmall
                                                          ?.copyWith(
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0,
                                                            top: 8,
                                                            bottom: 8),
                                                    child: Text(
                                                      "${myFlashSaleProducts[index].maxOrder} ",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displaySmall
                                                          ?.copyWith(
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              RatingStars(
                                                  rating: 4.2, editable: true),
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
                                                          productId:
                                                              (myFlashSaleProducts[index]
                                                                  .productId),
                                                          name:
                                                              myFlashSaleProducts[
                                                                      index]
                                                                  .productName,
                                                          image: myFlashSaleProducts[
                                                                  index]
                                                              .mobileThumbnail,
                                                          description: '-',
                                                          price:
                                                              myFlashSaleProducts[
                                                                      index]
                                                                  .flashSalePrice,
                                                          currency: "ETB",
                                                          subProductId:
                                                              (myFlashSaleProducts[
                                                                      index]
                                                                  .subProductId),
                                                          quantity: int.parse(
                                                              myFlashSaleProducts[
                                                                      index]
                                                                  .minOrder));
                                                      context
                                                          .read<CartCoreCubit>()
                                                          .addCartItem(myItem);
                                                      displaySnack(context,
                                                          "Flash product ${myFlashSaleProducts[index].productName} added to cart");
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
        ),
      ),
    );
  }

  Future<void> fetchFlashSaleProducts() async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      // appLog(isUserLoggedIn);
      if (isUserLoggedIn) {
        // final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.get(
          Uri.https(
            "api.commercepal.com:2096",
            "/prime/api/v1/products/on-flash-sale",
            // {'page': "0", "size": "100", "sortDirection": "desc"},
          ),
          headers: <String, String>{
            // 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        // appLog('hererererer');
        var datas = jsonDecode(response.body);
        // appLog(datas);
        myFlashSaleProducts.clear();
        if (datas['statusCode'] == "000") {
          for (var i in datas['data']['products']) {
            myFlashSaleProducts.add(FlashSaleProducts(
              productId: i['ProductId'].toString(),
              subProductId: i['flashSale']['subProductId'].toString(),
              minOrder: i['minOrder'].toString(),
              maxOrder: i['maxOrder'].toString(),
              isOnFlashSale: i['isOnFlashSale'].toString(),
              flashSalePrice: i['flashSale']['flashSalePrice'].toString(),
              productName: i['productName'].toString(),
              unique_id: i['unique_id'].toString(),
              mobileThumbnail: i['mobileImage'].toString(),
              actualPrice: i['actualPrice'].toString(),
              discountDescription: i['discountDescription'].toString(),
              productRating: i['productRating'].toString(),
            ));
          }
          // appLog(myFlashSaleProducts.length);
        } else {
          throw datas['statusDescription'] ?? 'Error fetching Flash-Sales';
        }
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      appLog(e.toString());
      rethrow;
    }
  }
}
