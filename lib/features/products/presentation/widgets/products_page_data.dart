import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/decoration.dart';
import 'package:commercepal/core/widgets/product_item_widget.dart';
import 'package:commercepal/features/selected_product/presentation/selected_product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../dashboard/widgets/home_error_widget.dart';
import '../../../dashboard/widgets/home_loading_widget.dart';
import '../../domain/product.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

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
  ProductsStatePage({Key? key, this.subCatId, this.queryParams})
      : super(key: key);

  @override
  _ProductsStatePageState createState() => _ProductsStatePageState();
}

class _ProductsStatePageState extends State<ProductsStatePage> {
  final scrollController = ScrollController();
  TextEditingController minPirce = TextEditingController();
  TextEditingController maxPirce = TextEditingController();
  final GlobalKey<FormState> myForm = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => const SizedBox(),
          error: (String error) => HomeErrorWidget(error: error),
          loading: () => const HomeLoadingWidget(),
          products: (List<Product> products) => Column(
            children: [
              Form(
                key: myForm,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {});
                          },
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty || value == null) {
                              return 'Min Price is required.';
                            } else {
                              return null;
                            }
                          },
                          controller: minPirce,
                          decoration: AppDecorations.getAppInputDecoration(
                              lableText: "Min Price",
                              hintText: "in ETB",
                              myBorder: true),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {});
                          },
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty || value == null) {
                              return 'Max Price is required.';
                            } else {
                              return null;
                            }
                          },
                          controller: maxPirce,
                          decoration: AppDecorations.getAppInputDecoration(
                              lableText: "Max price",
                              hintText: "in ETB",
                              myBorder: true),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.colorPrimaryDark),
                          onPressed: () {
                            if (myForm.currentState!.validate()) {}
                            Map<String, String> orderValues = {
                              "subCategoryId": widget.subCatId.toString(),
                              'minPrice': "10",
                              'maxPrice': "20000",
                            };
                            context.read<ProductCubit>().fetchProducts(
                                widget.subCatId, orderValues, true);
                          },
                          child: Text("Filter"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 8.0),
              //     child:
              //   ),
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.78,
                child: GridView.count(
                  controller: scrollController,
                  crossAxisCount: 2,
                  childAspectRatio: 0.81,
                  children: List.generate(
                    products.length,
                    (index) => ProductItemWidget(
                      product: products[index],
                      onItemClick: (Product prod) {
                        Navigator.pushNamed(
                          context,
                          SelectedProductPage.routeName,
                          arguments: {"p_id": prod.id},
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      print("Scroll Listener Called");
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
