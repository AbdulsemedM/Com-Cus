import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/string_utils.dart';
import 'package:commercepal/core/cart-core/bloc/cart_core_cubit.dart';
import 'package:commercepal/core/cart-core/bloc/cart_core_state.dart';
import 'package:commercepal/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:commercepal/features/check_out/presentation/check_out_page.dart';
import 'package:commercepal/features/dashboard/widgets/home_error_widget.dart';
import 'package:commercepal/features/login/presentation/login_page.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/product_price_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void initState() {
    super.initState();
    fetchHints();
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
                  subTitle: "Delivery Charges: ${cartItems.first.currency} 0",
                  totalPrice: cartItems
                      .map((e) => e.quantity! * double.parse(e.price!))
                      .fold(
                          0.0,
                          (previousValue, element) =>
                              previousValue + element.toDouble())
                      .formatCurrency(cartItems.first.currency),
                  onClick: () {
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
}
