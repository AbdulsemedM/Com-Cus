import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/app/utils/string_utils.dart';
import 'package:commercepal/core/cart-core/bloc/cart_core_cubit.dart';
import 'package:commercepal/core/cart-core/bloc/cart_core_state.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/core/translator/translator.dart';
import 'package:commercepal/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:commercepal/features/check_out/presentation/check_out_page.dart';
import 'package:commercepal/features/dashboard/widgets/home_error_widget.dart';
import 'package:commercepal/features/login/presentation/login_page.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/widgets/product_price_widget.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void initState() {
    super.initState();
    // checkToken();
    fetchHints();
    // fetchUser1();
  }

  Future<void> checkToken() async {
    String valid = await fetchUser1(context: context);
    if (valid == "logout") {
      Navigator.pushNamed(context, LoginPage.routeName);
    }
  }

  void fetchHints() async {
    setState(() {
      loading = true;
    });
    Shopping = Translations.translatedText(
        "Shopping Cart", GlobalStrings.getGlobalString());
    items =
        Translations.translatedText("Item", GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    sCart = await Shopping;
    it = await items;
    print("herrerererere");
    print(sCart);

    setState(() {
      loading = false;
    });
  }

  var Shopping;
  String sCart = '';
  var items;
  String it = '';
  var loading = false;
  String logout = "login";

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCoreCubit, CartCoreState>(
      listener: (ctx, state) async {
        if (state is CartCoreStateSuccess) {
          String mess = await setMyState(state.success);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(mess),
          ));
        }
        if (state is CartCoreStateLoginUser) {
          Navigator.pushNamed(ctx, LoginPage.routeName);
        }

        if (state is CartCoreStateCheckOutUser) {
          Navigator.pushNamed(context, CheckOutPage.routeName);
        }
      },
      builder: (ctx, state) {
        return state.maybeWhen(
          orElse: () => const SizedBox(),
          error: (error) => HomeErrorWidget(error: error),
          cartItems: (cartItems) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                  child: loading
                      ? CircularProgressIndicator()
                      : Text(
                          sCart,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.secondaryTextColor),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Text(
                    "${cartItems.map((e) => e.quantity).fold(0, (previousValue, element) => previousValue + element!)} ${loading ? '' : it}",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 12.sp),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (ctx, index) {
                      return CartItemWidget(
                        cartItem: cartItems[index],
                      );
                    },
                  ),
                ),
                ProductPriceWidget(
                  items: cartItems,
                  subTitle:
                      "Delivery Charges: ${cartItems.first.currency ?? "ETB"} 0",
                  totalPrice: cartItems
                      .map((e) => e.quantity! * double.parse(e.price!))
                      .fold(
                          0.0,
                          (previousValue, element) =>
                              previousValue + element.toDouble())
                      .formatCurrency(cartItems.first.currency),
                  onClick: () async {
                    String valid = await fetchUser1(context: context);
                    if (valid == "logout") {
                      displaySnack(context, "Login to your account.");
                      Navigator.pushNamed(ctx, LoginPage.routeName);
                    }
                    ctx.read<CartCoreCubit>().isUserLoggedIn();
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<String> setMyState(String mymess) async {
    try {
      String trans = await Translations.translatedText(
          mymess, GlobalStrings.getGlobalString());
      return trans;
    } catch (e) {
      return mymess;
    }
  }

  // Future<void> fetchUser1({int retryCount = 0, BuildContext? context}) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   try {
  //     await prefs.remove("promocode");
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   try {
  //     setState(() {
  //       loading = true;
  //     });
  //     final prefsData = getIt<PrefsData>();
  //     final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
  //     if (isUserLoggedIn) {
  //       final token = await prefsData.readData(PrefsKeys.userToken.name);
  //       final response = await http.get(
  //         Uri.https(
  //           "api.commercepal.com:2096",
  //           "prime/api/v1/get-details",
  //           {"userType": "BUSINESS"},
  //         ),
  //         headers: <String, String>{"Authorization": "Bearer $token"},
  //       );

  //       var data = jsonDecode(response.body);
  //       print(data);

  //       if (data['statusCode'] == '000') {
  //         // Handle the case when statusCode is '000'
  //         setState(() {
  //           loading = false;
  //         });
  //       } else {
  //         // Retry logic
  //         // if (retryCount < 5) {
  //         //   // Retry after num + 1 seconds
  //         //   await Future.delayed(Duration(seconds: retryCount++));
  //         //   // Call the function again with an increased retryCount
  //         //   await fetchUser(retryCount: retryCount + 1);

  //         // Retry limit reached, handle accordingly
  //         setState(() async {
  //           loading = false;
  //           logout = "logout";
  //         });

  //         // ignore: use_build_context_synchronously
  //         // Navigator.pushReplacement(context!,
  //         //     MaterialPageRoute(builder: (context) => const LoginPage()));
  //       }
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     setState(() {
  //       loading = false;
  //     });
  //     // Handle other exceptions
  //   }
  // }
}
