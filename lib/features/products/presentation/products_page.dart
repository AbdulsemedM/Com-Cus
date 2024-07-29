import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/features/my_special_orders/add_special_orders.dart';
import 'package:commercepal/features/products/presentation/cubit/product_cubit.dart';
import 'package:commercepal/features/products/presentation/search_product_page.dart';
import 'package:commercepal/features/products/presentation/widgets/products_page_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/cart-core/cart_widget.dart';
import '../../../core/widgets/commercepal_app_bar.dart';
import 'cubit/product_state.dart';
import 'widgets/search_product_widget.dart';

//TODO: find/change to use only one BlocBuilder
class ProductsPage extends StatelessWidget {
  static const routeName = "/products_page";

  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)?.settings.arguments as Map;
    return BlocProvider(
      create: (context) => getIt<ProductCubit>(),
      child: BlocBuilder<ProductCubit, ProductState>(
        builder: (ctx, state) {
          return Scaffold(
            floatingActionButton: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: ElevatedButton(
                // style: ElevatedButton.styleFrom(
                //     backgroundColor: AppColors.secondaryTextColor),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddSpecialOrders()));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.colorSecondaryDark,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.card_giftcard_outlined,
                      color: AppColors.colorPrimaryDark,
                    ),
                    SizedBox(
                        width: 8), // Adjust the spacing between icon and text
                    Text(
                      "Special Order",
                      style: TextStyle(
                          color: AppColors.colorPrimaryDark,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.white,
            appBar: args['search'] != null
                ? _buildSearchAppBar(ctx)
                : buildCommerceAppBar(context, args['title'] ?? "Items"),
            body: args['search'] != null
                ? const SearchProductPage()
                : ProductsPageData(
                    subCatId: args['sub_cat_id'],
                    queryParams: args['query'],
                  ),
          );
        },
      ),
    );
  }
}

AppBar _buildSearchAppBar(BuildContext ctx) {
  return AppBar(
    title: SearchProductWidget(
      onChanged: (value) {
        if (value.isEmpty == true) {
          return;
        }
        ctx.read<ProductCubit>().searchProduct(value);
      },
    ),
    actions: const [
      Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: CartWidget(),
      )
    ],
  );
}
