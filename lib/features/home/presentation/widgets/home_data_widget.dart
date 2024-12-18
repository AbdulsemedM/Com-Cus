import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/widgets/app_button.dart';
import 'package:commercepal/features/alibaba_new/providers_products_screen.dart';
import 'package:commercepal/features/alibaba_product_view/alibaba_products_screen.dart';
import 'package:commercepal/features/dashboard/widgets/home_error_widget.dart';
import 'package:commercepal/features/flash_sale/flash_sale_dashboard.dart';
import 'package:commercepal/features/my_special_orders/my_special_orders.dart';
import 'package:commercepal/features/provider_products/presentation/widgets/provider_products.dart';
import 'package:commercepal/features/sub_categories/presentation/sub_categories_page.dart';
import 'package:commercepal/features/top_deals/top_deals_dashboard.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/utils/assets.dart';
import '../../../../core/models/category_model.dart';
import '../../../products/presentation/products_page.dart';
import '../../../selected_product/presentation/selected_product_page.dart';
import '../../../special_order/presentantion/list_special_orders_page.dart';
import '../../domain/schema_settings_model.dart';
import 'category_item_widget.dart';
import 'collections_item_widget.dart';
import '../../../dashboard/widgets/home_search_field_widget.dart';
import 'popular_widget_item.dart';
import 'title_widget.dart';
import 'top_brand_widget_item.dart';
import 'top_category_widget.dart';
import 'under_item_widget.dart';

class HomePageDataWidget extends StatefulWidget {
  final SchemaSettingsModel schema;

  const HomePageDataWidget({Key? key, required this.schema}) : super(key: key);

  @override
  State<HomePageDataWidget> createState() => _HomePageDataWidgetState();
}

class _HomePageDataWidgetState extends State<HomePageDataWidget> {
  var loading = false;
  List<SchemaSections>? _mostPopular;

  @override
  void initState() {
    super.initState();
    _mostPopular = widget.schema.schemaSections
        ?.where((element) => element.key == "most_popular")
        .toList();
    fetchHints();
  }

  void fetchHints() async {
    setState(() {
      loading = true;
    });

    physicalAddressHintFuture = Translations.translatedText(
        "Commercepal", GlobalStrings.getGlobalString());
    subcityHint = Translations.translatedText(
        "Originals", GlobalStrings.getGlobalString());
    addAddHint =
        Translations.translatedText("Flash", GlobalStrings.getGlobalString());
    saleHint =
        Translations.translatedText("Sale", GlobalStrings.getGlobalString());
    topHint =
        Translations.translatedText("Top", GlobalStrings.getGlobalString());
    dealHint =
        Translations.translatedText("Deals", GlobalStrings.getGlobalString());
    specialHint =
        Translations.translatedText("Special", GlobalStrings.getGlobalString());
    orderHint =
        Translations.translatedText("Order", GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    pHint = await physicalAddressHintFuture;
    cHint = await subcityHint;
    aHint = await addAddHint;
    bHint = await saleHint;
    dHint = await topHint;
    eHint = await dealHint;
    fHint = await specialHint;
    gHint = await orderHint;
    print("herrerererere");
    print(pHint);
    print(cHint);

    setState(() {
      loading = false;
    });
  }

  var physicalAddressHintFuture;
  var subcityHint;
  var addAddHint;
  var saleHint;
  var topHint;
  var dealHint;
  var specialHint;
  var orderHint;
  String pHint = '';
  String cHint = '';
  String aHint = '';
  String bHint = '';
  String dHint = '';
  String eHint = '';
  String fHint = '';
  String gHint = '';
  // final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          const HomeSearchFieldWidget(),
          _buildHomeSlider(),
          // const SizedBox(height: 10),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: AppButtonWidget(
          //     onClick: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const ProviderProducts()));
          //     },
          //     text: "Providers",
          //   ),
          // ),
          _buildHomeOriginalsCategories(),
          _buildMostPopular(),
          _buildCategories(),
          _buildTopBrands(),
          _buildCollections(),
          const SizedBox(
            height: 10,
          ),
          _buildUnder()
        ])),
        _buildUnderItems()
      ],
    );
  }

  Widget _buildUnderItems() {
    final underPrice = widget.schema.schemaSections
        ?.where((element) => element.key == 'under_1000');
    return underPrice?.isNotEmpty == true
        ? SliverGrid.count(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            children: List.generate(
                underPrice?.first.items?.length ?? 0,
                (index) => GestureDetector(
                    onTap: () {},
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProvidersProductsScreen(
                              productId: underPrice!.first.items![index].prodId
                                  .toString(),
                              // provider: "Shein",
                            ),
                          ),
                        );
                        // Navigator.pushNamed(
                        //     context, SelectedProductPage.routeName, arguments: {
                        //   "p_id":
                        //       underPrice?.first.items?[index].prodId.toString()
                        // });
                      },
                      child: UnderItemWidget(
                          item: underPrice?.first.items?[index]),
                    ))),
          )
        : const SizedBox();
  }

  Widget _buildUnder() {
    final underPrice = widget.schema.schemaSections
        ?.where((element) => element.key == 'under_1000');
    return underPrice?.isNotEmpty == true
        ? TitleWidget(
            title: underPrice?.first.displayName ?? "",
            optionTitle: "See All",
          )
        : const SizedBox();
  }

  Widget _buildTopBrands() {
    final topBrands = widget.schema.schemaSections
        ?.where((element) => element.key == "top_brands");
    return topBrands?.isNotEmpty == true
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<String>(
                  future: TranslationService.translate(
                      topBrands?.first.displayName ?? ""), // Translate hint
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                          "..."); // Show loading indicator for hint
                    } else if (snapshot.hasError) {
                      return Text(
                        topBrands?.first.displayName ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp),
                      ); // Show error for hint
                    } else {
                      return Text(
                        snapshot.data ?? topBrands?.first.displayName ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp),
                      ); // Display translated hint
                    }
                  },
                ),
                // Text(
                //   topBrands?.first.displayName ?? "",
                //   style: Theme.of(context).textTheme.displayMedium?.copyWith(
                //       color: Colors.black,
                //       fontWeight: FontWeight.w500,
                //       fontSize: 16.sp),
                // ),
              ),
              SizedBox(
                height: 150,
                child: topBrands?.first.items?.isNotEmpty == true
                    ? ListView.builder(
                        itemCount: topBrands?.first.items?.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) => Padding(
                              padding: const EdgeInsets.only(right: 18.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, ProductsPage.routeName,
                                      arguments: {
                                        "title":
                                            topBrands?.first.items![index].name,
                                        "query": {
                                          "brand":
                                              topBrands?.first.items![index].id
                                        }
                                      });
                                },
                                child: TopBrandWidgetItem(
                                  imagePng: topBrands
                                      ?.first.items![index].mobileThumbnail,
                                  title:
                                      topBrands?.first.items![index].name ?? "",
                                ),
                              ),
                            ))
                    : const HomeErrorWidget(error: "Top Brands not found"),
              ),
            ],
          )
        : const SizedBox();
  }

  Widget _buildCategories() {
    final categories = widget.schema.schemaSections
        ?.where((element) => element.key == "categories");
    return categories?.isNotEmpty == true
        ? Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TitleWidget(
                title: categories?.first.displayName ?? "",
                optionTitle: "Shop more",
                onOptionClick: () {},
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                height: 210,
                child: categories?.first.items?.isNotEmpty == true
                    ? GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 10,
                        children: categories!.first.items!
                            .map((e) => Builder(builder: (ctx) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, ProductsPage.routeName,
                                          arguments: {
                                            "title": e.name,
                                            "sub_cat_id": e.id
                                          });
                                    },
                                    child: CategoryItemWidget(
                                      title: e.name ?? "...",
                                      image: e.mobileThumbnail ??
                                          e.mobileImage ??
                                          "",
                                    ),
                                  );
                                }))
                            .toList(),
                      )
                    : const HomeErrorWidget(error: "Categories not found"),
              ),
            ],
          )
        : const SizedBox();
  }

  Widget _buildMostPopular() {
    return _mostPopular?.isNotEmpty == true
        ? Column(
            children: [
              const SizedBox(height: 20),
              TitleWidget(title: _mostPopular?.first.displayName ?? ""),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.only(left: 10),
                height: 170,
                child: _mostPopular?.first.items?.isNotEmpty == true
                    ? GridView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 80,
                          childAspectRatio:
                              MediaQuery.of(context).size.height > 896
                                  ? 0.35
                                  : 1 / 2.4,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        children: _mostPopular!.first.items!
                            .map((e) => Builder(
                                builder: (ctx) => GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          SubCategoriesPage.routeName,
                                          arguments: CategoryModel(
                                            image: e.mobileImage,
                                            id: e.categoryId,
                                            parentId: e.parentCategoryId,
                                            pCategoryName: e.name,
                                          ),
                                        );
                                      },
                                      child: PopularWidgetItem(
                                        schemaItem: e,
                                      ),
                                    )))
                            .toList(),
                      )
                    : const HomeErrorWidget(
                        error: "Most popular items not found"),
              ),
            ],
          )
        : const SizedBox();
  }

  Widget _buildHomeSlider() => HomeSlider(banners: widget.schema.banners);
  // Widget _buildHomeSlider() =>
  // (widget.schema.banners?.isNotEmpty == true)
  //     ? Stack(
  //         children: [
  //           CarouselSlider(
  //             // carouselController: _controller,
  //             options: CarouselOptions(
  //                 onPageChanged: (index, reason) {
  //                   setState(() {
  //                     _current = index;
  //                   });
  //                 },
  //                 viewportFraction: 1.0,
  //                 enlargeCenterPage: false,
  //                 autoPlay: true,
  //                 height: 200.0),
  //             items: widget.schema.banners?.map((i) {
  //               return Builder(
  //                   builder: (BuildContext context) => CachedNetworkImage(
  //                         imageUrl: i,
  //                         errorWidget: (context, url, error) =>
  //                             Icon(Icons.error),
  //                         placeholder: (ctx, url) => Container(
  //                           color: Colors.grey.shade200,
  //                         ),
  //                       )
  //                   // return Image.asset("assets/images/response.jpeg",
  //                   //     width: double.infinity, fit: BoxFit.cover);
  //                   );
  //             }).toList(),
  //           )
  //         ],
  //       )
  //     : const SizedBox();

  Widget _buildHomeOriginalsCategories() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TopCategoryWidget(
              title: loading
                  ? "Loading..."
                  : (pHint.length > 10
                      ? '${pHint.substring(0, 10)}...'
                      : pHint),
              subTitle: loading ? "Loading..." : cHint,
              imagePng: Assets.commercepalOriginPng,
              onClick: () {
                displaySnack(context, "Will be available soon.");
              },
            ),
            TopCategoryWidget(
              title: loading ? "Loading..." : aHint,
              subTitle: loading ? "Loading..." : bHint,
              imagePng: Assets.flashSale,
              onClick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FlashSaleDashboard()));
                // displaySnack(context, "Will be available soon.");
              },
            ),
            TopCategoryWidget(
              title: loading ? "Loading..." : dHint,
              subTitle: loading ? "Loading..." : eHint,
              imagePng: Assets.topDeals,
              onClick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TopDealsDashboard()));
              },
            ),
            TopCategoryWidget(
              title: loading ? "Loading..." : fHint,
              subTitle: loading ? "Loading..." : gHint,
              imagePng: Assets.specialOrder,
              onClick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NewSpecialOrders()));
              },
            )
          ],
        ),
      );

  Widget _buildCollections() {
    final collections = widget.schema.schemaSections
        ?.where((element) => element.key == "collections");
    return collections?.isNotEmpty == true
        ? Column(
            children: [
              TitleWidget(title: collections?.first.displayName ?? ""),
              SizedBox(
                height: 190,
                child: collections?.first.items?.isNotEmpty == true
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: collections?.first.items?.length,
                        itemBuilder: (ctx, index) => GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ProductsPage.routeName,
                                    arguments: {
                                      "title":
                                          collections?.first.items![index].name,
                                      "sub_cat_id":
                                          collections?.first.items![index].id
                                    });
                              },
                              child: CollectionsItemWidget(
                                  item: collections?.first.items![index]),
                            ))
                    : const HomeErrorWidget(error: "No collections found"),
              ),
            ],
          )
        : const SizedBox();
  }
}

class HomeSlider extends StatefulWidget {
  final List<String>? banners;

  const HomeSlider({Key? key, this.banners}) : super(key: key);

  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  int _current = 0; // Track the current index

  @override
  Widget build(BuildContext context) {
    return (widget.banners?.isNotEmpty == true)
        ? Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index; // Update the current index
                      });
                    },
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    autoPlay: true,
                    height: 150.0,
                  ),
                  items: widget.banners!.map((i) {
                    return Builder(
                      builder: (BuildContext context) => CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: i,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        placeholder: (ctx, url) => Container(
                          color: Colors.grey.shade200,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Optional: Add indicator or other widgets on top of the slider
            ],
          )
        : const SizedBox(); // Return an empty SizedBox if no banners are available
  }
}
