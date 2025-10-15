// import 'package:commercepal/app/utils/app_colors.dart';
// import 'package:commercepal/app/utils/decoration.dart';
import 'package:commercepal/core/widgets/app_button.dart';
import 'package:commercepal/core/widgets/product_item_widget.dart';
import 'package:commercepal/features/alibaba_new/providers_products_screen.dart';
import 'package:commercepal/features/alibaba_product_view/alibaba_products_screen.dart';
import 'package:commercepal/features/products/presentation/widgets/product_not_found.dart';
import 'package:commercepal/features/selected_product/presentation/selected_product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../app/di/injector.dart';
// import '../../../dashboard/widgets/home_error_widget.dart';
import '../../../dashboard/widgets/home_loading_widget.dart';
import '../../domain/product.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';
import 'package:commercepal/app/utils/logger.dart';

class ProductsPageData extends StatefulWidget {
  final num? subCatId;
  final Map? queryParams;

  const ProductsPageData({Key? key, this.subCatId, this.queryParams})
      : super(key: key);

  @override
  State<ProductsPageData> createState() => _ProductsPageDataState();
}

class _ProductsPageDataState extends State<ProductsPageData> {
  @override
  void initState() {
    super.initState();
    context
        .read<ProductCubit>()
        .fetchProducts(widget.subCatId, widget.queryParams, false);
  }

  @override
  Widget build(BuildContext context) {
    return ProductsStatePage(
      subCatId: widget.subCatId,
      queryParams: widget.queryParams,
    );
  }
}

class ProductsStatePage extends StatefulWidget {
  final num? subCatId;
  final Map? queryParams;
  final String? val;
  ProductsStatePage({Key? key, this.subCatId, this.queryParams, this.val})
      : super(key: key);

  @override
  _ProductsStatePageState createState() => _ProductsStatePageState();
}

class _ProductsStatePageState extends State<ProductsStatePage> {
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (widget.val != null) {
        setState(() {
          isLoadingMore = true;
        });

        // Load more products
        if (widget.subCatId == null) {
          // For search results
          String prompt = widget.val ?? "";
          context.read<ProductCubit>().searchProduct(prompt, 150);
        } else {
          // For category products
          context.read<ProductCubit>().fetchProducts(
                widget.subCatId,
                widget.queryParams,
                true,
              );
        }

        setState(() {
          isLoadingMore = false;
          currentPage++;
        });
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => const SizedBox(),
          error: (String error) => ProductNotFound(error: error),
          loading: () => const HomeLoadingWidget(),
          products: (List<Product> products) => Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                child: GridView.count(
                  controller: scrollController,
                  crossAxisCount: 2,
                  childAspectRatio: 0.95,
                  children: List.generate(
                    products.length + (isLoadingMore ? 1 : 0),
                    (index) {
                      if (index < products.length) {
                        return ProductItemWidget(
                          product: products[index],
                          onItemClick: (Product prod) {
                            if (prod.provider == "Commercepal") {
                              appLog("it's true it's commercepal profuct");
                              Navigator.pushNamed(
                                context,
                                SelectedProductPage.routeName,
                                arguments: {"p_id": prod.id},
                              );
                            } else if (prod.provider == "Alibaba" ||
                                prod.provider == "Shein" ||
                                prod.provider == "Aliexpress") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProvidersProductsScreen(
                                    productId: prod.id!,
                                    // provider: prod.provider!,
                                  ),
                                ),
                              );
                            } else {
                              appLog(prod.id
                                  ?.toString()
                                  .contains(RegExp(r'^[0-9]+$')));
                              appLog("it's true it's product");
                              appLog(prod.provider);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProvidersProductsScreen(
                                    productId: prod.id!,
                                    // provider: prod.provider!,
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      } else {
                        // Show loading indicator at the bottom
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
