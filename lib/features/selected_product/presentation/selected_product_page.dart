import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:commercepal/app/app.dart';
import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/decoration.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/app/utils/string_utils.dart';
import 'package:commercepal/core/cart-core/bloc/cart_core_cubit.dart';
import 'package:commercepal/core/cart-core/bloc/cart_core_state.dart';
import 'package:commercepal/core/cart-core/domain/cart_item.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/cart/presentation/cart_page.dart';
import 'package:commercepal/features/dashboard/widgets/home_error_widget.dart';
import 'package:commercepal/features/dashboard/widgets/home_loading_widget.dart';
import 'package:commercepal/features/dashboard/widgets/home_search_field_widget.dart';
import 'package:commercepal/features/products/domain/product.dart';
import 'package:commercepal/features/selected_product/presentation/bloc/selected_product_cubit.dart';
import 'package:commercepal/features/selected_product/presentation/bloc/selected_product_state.dart';
import 'package:commercepal/features/selected_product/presentation/widgets/add_product_review.dart';
import 'package:commercepal/features/selected_product/presentation/widgets/review_product.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../app/utils/app_colors.dart';
import '../../../app/utils/assets.dart';
import '../../../core/cart-core/cart_widget.dart';
import '../../../core/widgets/product_item_widget.dart';
import '../../../core/widgets/product_price_widget.dart';
import '../data/dto/selected_product_dto.dart';
import 'widgets/product_review_item_widget.dart';
import 'widgets/selected_product_options.dart';
import 'package:http/http.dart' as http;

class SelectedProductPage extends StatefulWidget {
  static const routeName = "/selected_product_page";

  const SelectedProductPage({Key? key}) : super(key: key);

  @override
  State<SelectedProductPage> createState() => _SelectedProductPageState();
}

String? id;

class _SelectedProductPageState extends State<SelectedProductPage> {
  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)?.settings.arguments as Map;
    id = args['p_id'].toString();
    print(id);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const HomeSearchFieldWidget(),
      ),
      body: BlocProvider(
        create: (context) =>
            getIt<SelectedProductCubit>()..fetchProduct(args['p_id']),
        child: BlocBuilder<SelectedProductCubit, SelectedProductState>(
          builder: (context, state) {
            return state.maybeWhen(
                orElse: () => const HomeLoadingWidget(),
                error: (error) => HomeErrorWidget(error: error),
                loading: () => const HomeLoadingWidget(),
                product: (product) => SelectedProductDataWidget(
                      selectedProductDetails: product,
                    ));
          },
        ),
      ),
    );
  }
}

class SelectedProductDataWidget extends StatefulWidget {
  final SelectedProductDetails selectedProductDetails;

  const SelectedProductDataWidget(
      {Key? key, required this.selectedProductDetails})
      : super(key: key);

  @override
  State<SelectedProductDataWidget> createState() =>
      _SelectedProductDataWidgetState();
}

class _SelectedProductDataWidgetState extends State<SelectedProductDataWidget> {
  final CarouselController _controller = CarouselController();
  final TextEditingController promoController = TextEditingController();
  final GlobalKey<FormState> mykey = GlobalKey();
  String? newPrice;
  String? prize;
  var loading = false;
  int _current = 0;
  num _selectedFeature = -1;
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    setState(() {
      // set first sub product as default
      _selectedFeature =
          widget.selectedProductDetails.subProducts?[0].subProductId ?? -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.selectedProductDetails.productName ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.colorPrimary,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w500)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.selectedProductDetails.descriptionBasedProduct ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: RatingBar.builder(
                        initialRating: (widget
                                    .selectedProductDetails.ratingCount
                                    ?.toDouble() ??
                                1) /
                            5,
                        minRating: 1,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemSize: 14,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('${widget.selectedProductDetails.ratingCount}'),
                  ],
                ),
                SingleChildScrollView(scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greyColor),
                          onPressed: () {
                            displaySnack(context, "Will be available soon");
                          },
                          child: Text(
                            "Enable Price Drop Alert",
                            style: TextStyle(color: Colors.black45, fontSize: 11),
                          )),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greyColor),
                          onPressed: () {
                            displaySnack(context, "Will be available soon");
                          },
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.heart,
                                  color: Colors.black45, size: 12),
                              Text(
                                "Add to Wishlist",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 11),
                              ),
                            ],
                          )),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greyColor),
                          onPressed: () {
                            displaySnack(context, "Will be available soon");
                          },
                          child: Row(
                            children: [
                              Icon(Icons.share, color: Colors.black45, size: 12),
                              Text(
                                "Share",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 11),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          autoPlay: true,
                          height: 200.0),
                      items:
                          widget.selectedProductDetails.productImages.map((i) {
                        return Builder(
                            builder: (BuildContext context) =>
                                CachedNetworkImage(
                                  imageUrl: i,
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Colors.grey.shade200,
                                  ),
                                  placeholder: (ctx, url) => Container(
                                    color: Colors.grey.shade200,
                                  ),
                                )
                            // return Image.asset("assets/images/response.jpeg",
                            //     width: double.infinity, fit: BoxFit.cover);
                            );
                      }).toList(),
                    ),
                    Positioned(
                      bottom: 0,
                      left: MediaQuery.of(context).size.width / 3,
                      right: MediaQuery.of(context).size.width / 3,
                      child: SizedBox(
                        height: 12,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget
                                .selectedProductDetails.productImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: index == _current
                                          ? AppColors.colorPrimary
                                          : Colors.grey,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6))),
                                  width: 20,
                                ),
                              );
                            }),
                      ),
                    )
                  ],
                ),
              ])),

              // SliverList(
              //   delegate: SliverChildBuilderDelegate(
              //     (context, index) {
              //       return Column(
              //         children: [
              //           Row(
              //             children: [
              //               Expanded(
              //                 flex:
              //                     3, // Adjust flex to distribute space between TextFormField and ElevatedButton
              //                 child: Padding(
              //                   padding:
              //                       const EdgeInsets.fromLTRB(16, 16, 0, 16),
              //                   child: Form(
              //                     key: mykey,
              //                     child: TextFormField(
              //                       onChanged: (value) {
              //                         setState(() {});
              //                       },
              //                       keyboardType: TextInputType.text,
              //                       validator: (value) {
              //                         if (value!.isEmpty || value == null) {
              //                           return 'Promo-Code is required.';
              //                         } else {
              //                           return null;
              //                         }
              //                       },
              //                       controller: promoController,
              //                       decoration:
              //                           AppDecorations.getAppInputDecoration(
              //                         lableText: "Promo Code",
              //                         hintText: "Ex. Test Promo-Code 1",
              //                         myBorder: true,
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //               SizedBox(width: 16),
              //               loading
              //                   ? const CircularProgressIndicator(
              //                       color: AppColors.colorPrimaryDark,
              //                     )
              //                   : // Add some space between TextFormField and ElevatedButton
              //                   Expanded(
              //                       flex:
              //                           1, // Adjust flex to distribute space between TextFormField and ElevatedButton
              //                       child: SizedBox(
              //                         height: 50,
              //                         child: Padding(
              //                           padding: const EdgeInsets.fromLTRB(
              //                               0, 0, 4, 0),
              //                           child: ElevatedButton(
              //                             style: ElevatedButton.styleFrom(
              //                                 backgroundColor:
              //                                     AppColors.colorPrimaryDark),
              //                             onPressed: () async {
              //                               if (mykey.currentState!
              //                                   .validate()) {
              //                                 bool done = await verifyForm();
              //                                 displaySnack(context, prize!);
              //                                 if (done) {
              //                                   CartItem myItem = CartItem(
              //                                       productId: widget
              //                                           .selectedProductDetails
              //                                           .productId
              //                                           ?.toInt(),
              //                                       name: widget
              //                                           .selectedProductDetails
              //                                           .productName,
              //                                       image: widget
              //                                           .selectedProductDetails
              //                                           .mobileImage,
              //                                       description: '-',
              //                                       price: newPrice,
              //                                       currency: "ETB",
              //                                       subProductId: widget
              //                                           .selectedProductDetails
              //                                           .selectedSubProductId
              //                                           ?.toInt(),
              //                                       quantity: 1);
              //                                   context
              //                                       .read<CartCoreCubit>()
              //                                       .addCartItem(myItem);
              //                                   // ignore: use_build_context_synchronously
              //                                   displaySnack(context,
              //                                       "${widget.selectedProductDetails.productName} added to cart.");
              //                                 }
              //                               } else {
              //                                 displaySnack(context, prize!);
              //                               }
              //                             },
              //                             child: Text(
              //                               "Apply",
              //                               style:
              //                                   TextStyle(color: Colors.white),
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //             ],
              //           ),
              //         ],
              //       );
              //     },
              //     childCount: 1,
              //   ),
              // ),

              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: widget.selectedProductDetails.features.length,
                      (ctx, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.all(16),
                      //   child: TextFormField(
                      //     onChanged: (value) {
                      //       setState(() {});
                      //     },
                      //     keyboardType: TextInputType.number,
                      //     // validator: (value) {
                      //     //   if (value!.isEmpty || value == null) {
                      //     //     return 'Min Price is required.';
                      //     //   } else {
                      //     //     return null;
                      //     //   }
                      //     // },
                      //     // controller: minPirce,
                      //     decoration: AppDecorations.getAppInputDecoration(
                      //         lableText: "Add a Promo-Code",
                      //         hintText: "in ETB",
                      //         myBorder: true),
                      //   ),
                      // ),
                      if (index == 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: _buildTitle("Product Variations"),
                        ),
                      Text(
                        widget.selectedProductDetails.features.keys
                                .elementAt(index) ??
                            "",
                        textAlign: TextAlign.right,
                      ),
                      // FutureBuilder<String>(
                      //   future: Translations.translatedText(
                      //       widget.selectedProductDetails.features.keys
                      //               .elementAt(index) ??
                      //           "",
                      //       GlobalStrings.getGlobalString()),
                      //   //  translatedText("Log Out", 'en', dropdownValue),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.done) {
                      //       return Text(
                      //         snapshot.data ?? 'Default Text',
                      //         textAlign: TextAlign.right,
                      //       );
                      //     } else {
                      //       return Text(
                      //         'Loading...',
                      //       ); // Or any loading indicator
                      //     }
                      //   },
                      // ),
                      const SizedBox(
                        height: 6,
                      ),
                      SizedBox(
                        //  height: index == 2 ? 30 : 80,
                        height: widget.selectedProductDetails.features.keys
                                    .elementAt(index)
                                    .toLowerCase() ==
                                "color"
                            ? 80
                            : 30,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget
                                .selectedProductDetails.features.values
                                .elementAt(index)
                                .length,
                            itemBuilder: (ctx, i) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedFeature = widget
                                        .selectedProductDetails.features.values
                                        .elementAt(index)[i]
                                        .subProdId!;

                                    // update price
                                    context
                                        .read<SelectedProductCubit>()
                                        .changeProductPrice(_selectedFeature);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: const Color(0xFFFCFCFC),
                                        border: Border.all(
                                            color: widget.selectedProductDetails
                                                        .features.values
                                                        .elementAt(index)[i]
                                                        .subProdId !=
                                                    _selectedFeature
                                                ? Colors.grey.shade300
                                                : AppColors.colorPrimary,
                                            width: 1)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (widget.selectedProductDetails
                                                .features.keys
                                                .elementAt(index)
                                                .toLowerCase() ==
                                            "color")
                                          CachedNetworkImage(
                                            height: 40,
                                            imageUrl: widget
                                                    .selectedProductDetails
                                                    .features
                                                    .values
                                                    .elementAt(index)[i]
                                                    .mobileImage ??
                                                '',
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              color: Colors.transparent,
                                            ),
                                            placeholder: (ctx, url) =>
                                                Container(
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                        if (widget.selectedProductDetails
                                                .features.keys
                                                .elementAt(index)
                                                .toLowerCase() ==
                                            "color")
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        Text(
                                          widget.selectedProductDetails.features
                                                  .values
                                                  .elementAt(index)[i]
                                                  .featureValue ??
                                              '',
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                );
              })),
              SliverList(
                  delegate: SliverChildListDelegate([
                const SizedBox(
                  height: 20,
                ),
                SelectedProductOptions(
                  title: "Specifications",
                  subTitle: "Brand, Express Delivery, Model",
                  asset: Assets.paymentOptions,
                  data: widget.selectedProductDetails.prodDescriptions,
                ),
                SelectedProductOptions(
                  title: "Delivery Options",
                  subTitle:
                      "Free Delivery, Estimated date from \n ${DateFormat('MMM-dd').format((currentDate.add(Duration(days: 3))))} to ${DateFormat('MMM-dd').format((currentDate.add(Duration(days: 7))))}",
                  asset: Assets.track,
                ),
                const SelectedProductOptions(
                  title: "Service",
                  subTitle: "Warranty Available and 7-day returns",
                  asset: Assets.service,
                ),
                const SelectedProductOptions(
                  title: "Payment Options",
                  subTitle: "Credit Card, Mobile Money,\n Loans, Cash",
                  asset: Assets.paymentOptions,
                ),
                if (widget.selectedProductDetails.similarProducts?.isNotEmpty ==
                    true)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 30),
                    child: _buildTitle("Similar Products"),
                  ),
                if (widget.selectedProductDetails.similarProducts?.isNotEmpty ==
                    true)
                  SizedBox(
                    height: 230,
                    child: ListView.builder(
                        itemCount: widget
                            .selectedProductDetails.similarProducts?.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) => ProductItemWidget(
                              product: widget.selectedProductDetails
                                  .similarProducts![index],
                              width: 170,
                              onItemClick: (Product prod) {},
                            )),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 30),
                  child: _buildTitle("Reviews"),
                ),
              ])),
              //   SliverToBoxAdapter(
              //     child: SizedBox(child:
              if (id != null) ReviewProduct(pId: id!),
              //   ),
              // ),
              // if (widget.selectedProductDetails.reviews?.isNotEmpty == true)
              //   SliverList(
              //       delegate: SliverChildBuilderDelegate(
              //           childCount:
              //               widget.selectedProductDetails.reviews?.length,
              //           (context, index) => ProductReviewItemWidget(
              //                 title: widget
              //                     .selectedProductDetails.reviews![index].title,
              //                 name: widget.selectedProductDetails
              //                     .reviews![index].reviewerName,
              //                 userImage: widget.selectedProductDetails
              //                     .reviews![index].reviewerProfileImageUrl,
              //                 description: widget.selectedProductDetails
              //                     .reviews![index].description,
              //                 date: widget
              //                     .selectedProductDetails.reviews![index].date,
              //                 rating: widget.selectedProductDetails
              //                     .reviews![index].rating,
              //               )))
              SliverToBoxAdapter(
                child: SizedBox(
                  // height: 50,
                  child: id!.isNotEmpty
                      ? AddProductReview(
                          pId: id!,
                        )
                      : Container(),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: AppColors.priceBg,
          child: SafeArea(
            child: BlocConsumer<CartCoreCubit, CartCoreState>(
              listener: (context, state) {
                if (state is CartCoreStateData) {
                  displaySnack(context,
                      "${widget.selectedProductDetails.productName} has been added to cart");
                }
              },
              builder: (context, state) {
                return widget.selectedProductDetails.quantity! > 0
                    ? ProductPriceWidget(
                        displayVoucher: false,
                        totalPrice:
                            "ETB ${widget.selectedProductDetails.priceBasedOnSubProducts}",
                        // widget.selectedProductDetails.priceBasedOnSubProducts.formatCurrency(widget.selectedProductDetails.currency),
                        subTitle:
                            "Delivery Estimate ${widget.selectedProductDetails.deliveryDate}",
                        buttonText: "Add to cart",
                        onClick: () {
                          context.read<CartCoreCubit>().addCartItem(
                              widget.selectedProductDetails.toCartItem());
                        },
                        items: [],
                      )
                    : Center(
                        child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Product out of stock',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ));
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(color: Colors.black, fontSize: 18.sp),
    );
  }
}
