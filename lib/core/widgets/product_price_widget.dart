import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/core/cart-core/domain/cart_item.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/utils/app_colors.dart';
import 'package:http/http.dart' as http;

class ProductPriceWidget extends StatefulWidget {
  final bool displayVoucher;
  final String? title;
  final String? subTitle;
  final String? totalPrice;
  final String? buttonText;
  final VoidCallback? onClick;
  final double? padding;
  final List<CartItem> items;

  const ProductPriceWidget(
      {Key? key,
      this.displayVoucher = true,
      this.subTitle,
      this.totalPrice,
      this.buttonText,
      this.onClick,
      this.padding,
      this.title,
      required this.items})
      : super(key: key);
  @override
  _ProductPriceWidgetState createState() => _ProductPriceWidgetState();
}

class _ProductPriceWidgetState extends State<ProductPriceWidget> {
  var loading = false;
  TextEditingController promoCodeController = TextEditingController();
  String totalCheckoutPrice = "";
  late Future<String> hintTranslationFuture;
  late Future<String> labelTranslationFuture;
  @override
  void initState() {
    super.initState();
    hintTranslationFuture = TranslationService.translate("Ex: Test Promo-code");
    labelTranslationFuture = TranslationService.translate("Promo-Code");
    fetchHints();
    // print("object");
    // print(widget.items!.length);
  }

  void fetchHints() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("myRayTotalPrice", widget.totalPrice!);
    setState(() {
      loading = true;
    });

    totalPrice = TranslationService.translate(widget.title ?? 'Total: ');
    subTitle = TranslationService.translate(widget.subTitle ?? '');
    butText = TranslationService.translate(widget.buttonText ?? "Checkout");

    // Use await to get the actual string value from the futures
    tPrice = await totalPrice;
    sTit = await subTitle;
    bText = await butText;
    // print("herrerererere");
    // print(tPrice);
    // print(sTit);

    setState(() {
      loading = false;
    });
  }

  var totalPrice;
  var subTitle;
  var butText;
  String tPrice = '';
  String sTit = '';
  String bText = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.priceBg, // Replace with appropriate color
      padding: EdgeInsets.symmetric(vertical: widget.padding ?? 6),
      width: double.infinity,
      child: Column(
        children: [
          // if (widget.displayVoucher) _buildVoucherField(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    loading
                        ? CircularProgressIndicator()
                        : RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: widget.totalPrice != null ? tPrice : "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 18.sp,
                                      color: AppColors.secondaryTextColor
                                          .withOpacity(0.8),
                                    ),
                              ),
                              TextSpan(
                                  text: totalCheckoutPrice != ""
                                      ? (widget.totalPrice!.startsWith("null")
                                          ? "${widget.totalPrice!.substring(4)}"
                                          : ' ${widget.totalPrice}')
                                      : "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          decoration:
                                              TextDecoration.lineThrough)),
                              TextSpan(
                                text: totalCheckoutPrice != ""
                                    ? "ETB  ${totalCheckoutPrice}"
                                    : (widget.totalPrice!.startsWith("null")
                                        ? " ETB ${widget.totalPrice!.substring(4)}"
                                        : ' ${widget.totalPrice}'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 18.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ]),
                          ),
                    const SizedBox(height: 4),
                    if (widget.subTitle != null)
                      Text(
                        sTit,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black,
                              fontSize: 14.sp,
                            ),
                      )
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (widget.onClick != null) {
                      widget.onClick!();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                      (states) => AppColors
                          .colorPrimary, // Replace with appropriate color
                    ),
                  ),
                  child: loading
                      ? CircularProgressIndicator()
                      : Text(
                          bText,
                          style: TextStyle(color: Colors.white),
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildVoucherField() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16, top: 14, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: FutureBuilder<String>(
                future: hintTranslationFuture,
                builder: (context, hintSnapshot) {
                  if (hintSnapshot.connectionState == ConnectionState.waiting) {
                    // While loading, you can show a placeholder or loading indicator
                    return TextField(
                      controller: promoCodeController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        isDense: true,
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.colorPrimary, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.colorPrimary, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                        hintText: "...", // Placeholder while loading hint
                        hintStyle: TextStyle(
                            color: AppColors.colorPrimary, fontSize: 14.sp),
                      ),
                    );
                  } else if (hintSnapshot.hasError) {
                    // Handle error case for hint
                    return TextField(
                      controller: promoCodeController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        isDense: true,
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.colorPrimary, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.colorPrimary, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                        hintText:
                            "Ex: Test Promo-code", // Default value on error
                        hintStyle: TextStyle(
                            color: AppColors.colorPrimary, fontSize: 14.sp),
                      ),
                    );
                  } else {
                    // Build TextField with translated hint text
                    return FutureBuilder<String>(
                      future: labelTranslationFuture,
                      builder: (context, labelSnapshot) {
                        return TextField(
                          controller: promoCodeController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            isDense: true,
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.colorPrimary, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.colorPrimary, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)),
                            ),
                            hintText: hintSnapshot.data ??
                                "Ex: Test Promo-code", // Use translated hint
                            hintStyle: TextStyle(
                                color: AppColors.colorPrimary, fontSize: 14.sp),
                            labelText: labelSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? "..." // Placeholder while loading label
                                : labelSnapshot.hasError
                                    ? "Promo-Code" // Default label on error
                                    : labelSnapshot.data ??
                                        "Promo-Code", // Use translated label
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (promoCodeController.text.isNotEmpty) {
                await verifyForm();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: AppColors.colorPrimary, // Replace with appropriate color
              child: FutureBuilder<String>(
                future: TranslationService.translate("Apply"), // Translate hint
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("..."); // Show loading indicator for hint
                  } else if (snapshot.hasError) {
                    return Text('Apply',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp)); // Show error for hint
                  } else {
                    return Text(snapshot.data ?? 'Apply',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp)); // Display translated hint
                  }
                },
              ),
              // Text(
              //   "APPLY",
              //   style: TextStyle(color: Colors.white, fontSize: 14.sp),
              // ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> verifyForm() async {
    try {
      setState(() {
        loading = true;
      });

      // print("hereeeewego");
      Map<String, dynamic> payload = {
        "promoCode": promoCodeController.text,
        "items": []
      };
      for (var item in widget.items) {
        Map<String, dynamic> itemMap = {
          "productId": item.productId,
          "subProductId": item.subProductId,
          "quantity": item.quantity
        };
        payload["items"].add(itemMap);
      }
      // print(payload);
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.post(
            Uri.https("api.commercepal.com:2096",
                "/prime/api/v1/product/promo-codes/apply"),
            body: jsonEncode(payload),
            headers: <String, String>{
              "Authorization": "Bearer $token",
              "Content-type": "application/json; charset=utf-8"
            });
        // print(response.body);
        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          setState(() {
            totalCheckoutPrice =
                data['priceSummary']['finalTotalCheckoutPrice'].toString();
            loading = false;
          });
          // print(totalCheckoutPrice);
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("promocode", promoCodeController.text);
          prefs.setString("newTotalPrice", totalCheckoutPrice!);
          return true;
        } else {
          setState(() {
            loading = false;
          });
          return false;
        }
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      return false;
    } finally {
      setState(() {
        loading = false;
      });
    }
    return false;
  }
}
