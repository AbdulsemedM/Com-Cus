import 'dart:convert';
import 'dart:io';

import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/core/cart-core/cart_widget.dart';
import 'package:commercepal/core/widgets/app_button.dart';
import 'package:commercepal/features/alibaba_new/provider_attributes_widget.dart';
import 'package:commercepal/features/alibaba_new/provider_config_model.dart';
import 'package:commercepal/features/alibaba_new/recommended_products_widget.dart';
// import 'package:commercepal/features/alibaba_new/the_new.dart';
import 'package:commercepal/features/alibaba_product_view/alibaba_products_screen.dart';
import 'package:commercepal/features/alibaba_product_view/image_slider.dart';
import 'package:commercepal/features/alibaba_product_view/minOrder_price.dart';
import 'package:commercepal/features/dashboard/dashboard_page.dart';
import 'package:commercepal/features/install_referral/deep_link_service.dart';
import 'package:commercepal/features/products/data/dto/products_dto.dart';
import 'package:commercepal/features/products/domain/product.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:commercepal/app/utils/logger.dart';

// class Prices {
//   final String price;
//   final String minOr;
//   final String? maxOr;

//   Prices({required this.price, required this.minOr, this.maxOr});
// }

class ProvidersProductsScreen extends StatefulWidget {
  static const String routeName = '/product';
  final String productId;
  const ProvidersProductsScreen({super.key, required this.productId});

  @override
  State<ProvidersProductsScreen> createState() =>
      _ProvidersProductsScreenState();
}

class _ProvidersProductsScreenState extends State<ProvidersProductsScreen> {
  @override
  void initState() {
    super.initState();
    appLog(widget.productId);
    fetchProductItem();
    // Initialize deep link handling
    DeepLinkService.initUniLinks(context);
  }

  String currentCountryForm = "";
  bool addedToCart = false;
  List<Product> recommendedProd = [];
  var loading = false;
  List<String> mainPics = [];
  String prodName = "";
  List<Prices> myPriceRange = [];
  List<ProductAttributes> myProdAttr = [];
  List<ProviderConfigModel> myConfigs = [];
  Set<String> uniquePropertyNames = {};
  List<String> uniquePropertyNamesList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: TranslationService.translate("Place your order"),
          builder: (context, snapshot) {
            return Text(
              snapshot.data ?? "Place your order",
              style: Theme.of(context).textTheme.displaySmall,
            );
          },
        ),
        // title: Text(
        //   "Place your order",
        //   style: Theme.of(context).textTheme.displaySmall,
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => DeepLinkService.shareProduct(widget.productId),
          ),
          const CartWidget(),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Image Slider
                SliverToBoxAdapter(
                  child: ImageSlider(
                    imageUrls: mainPics,
                    attributes: myProdAttr,
                    onShowAllImages: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ProductAttributesWidget(
                      //       myProdAttr: myProdAttr,
                      //       myPriceRange: myPriceRange,
                      //       myConfig: myConfigs,
                      //       productName: prodName,
                      //       productId: widget.productId,
                      //       imageUrl: mainPics[0],
                      //       currentCountry: currentCountryForm,
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                ),

                // Product Name
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: FutureBuilder(
                            future: TranslationService.translate(prodName),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data ?? prodName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Min Order Price Page
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: MinOrderPricePage(
                      currentCountryForm: currentCountryForm,
                      price: myPriceRange,
                    ),
                  ),
                ),

                // Spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 10),
                ),

                // Product Attributes Widget - Now integrated as sliver
                SliverToBoxAdapter(
                  child: ProductAttributesWidget(
                    myProdAttr: myProdAttr,
                    myPriceRange: myPriceRange,
                    myConfig: myConfigs,
                    productName: prodName,
                    productId: widget.productId,
                    imageUrl: mainPics[0],
                    currentCountry: currentCountryForm,
                  ),
                ),

                // Delivery Estimate
                SliverToBoxAdapter(
                  child: _buildDeliveryEstimate(context),
                ),

                // Spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 10),
                ),

                // Recommended Products - Now integrated as sliver
                if (recommendedProd.isEmpty != true)
                  SliverToBoxAdapter(
                    child: ProductGridWidget(products: recommendedProd),
                  ),
              ],
            ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      //   child: Container(
      //     // Set height to null to fit the child dynamically
      //     height: null,
      //     child: Column(
      //       mainAxisSize:
      //           MainAxisSize.min, // Make the column's size fit its children
      //       children: [
      //         loading
      //             ? Center(
      //                 child: Container(),
      //               )
      //             : (addedToCart
      //                 ? Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                     children: [
      //                       Expanded(
      //                         flex: 3,
      //                         child: Padding(
      //                           padding: const EdgeInsets.only(right: 3.0),
      //                           child: AppButtonWidget(
      //                             text: "Continue Shopping",
      //                             onClick: () {
      //                               Navigator.pushNamedAndRemoveUntil(
      //                                   context,
      //                                   DashboardPage.routeName,
      //                                   (route) => false);
      //                             },
      //                           ),
      //                         ),
      //                       ),
      //                       Expanded(
      //                         flex: 2,
      //                         child: Padding(
      //                           padding: const EdgeInsets.only(left: 3.0),
      //                           child: AppButtonWidget(
      //                             text: "Checkout",
      //                             onClick: () {
      //                               Navigator.pushNamedAndRemoveUntil(
      //                                   context,
      //                                   DashboardPage.routeName,
      //                                   (route) => false,
      //                                   arguments: {"redirect_to": "cart"});
      //                             },
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   )
      //                 : AppButtonWidget(
      //                     text: "Start Order",
      //                     onClick: () {
      //                       Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                           builder: (context) => ProductAttributesWidget(
      //                             myProdAttr: myProdAttr,
      //                             myPriceRange: myPriceRange,
      //                             myConfig: myConfigs,
      //                             productName: prodName,
      //                             productId: widget.productId,
      //                             imageUrl: mainPics[0],
      //                             currentCountry: currentCountryForm,
      //                           ),
      //                         ),
      //                       ).then((value) {
      //                         if (value == true) {
      //                           setState(() {
      //                             addedToCart = true;
      //                             appLog("added to cart");
      //                             appLog("loading");
      //                             appLog(loading);
      //                           });
      //                         }
      //                       });
      //                     },
      //                   )),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Future<http.Client> createInsecureHttpClient() async {
    final ioc = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    return IOClient(ioc);
  }

  Future<void> fetchProductItem() async {
    try {
      setState(() {
        loading = true;
      });
      // appLog(widget.productId);
      // final prefsData = getIt<PrefsData>();
      // final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      // if (isUserLoggedIn) {
      //   final token = await prefsData.readData(PrefsKeys.userToken.name);
      // final httpClient = await createInsecureHttpClient();
      appLog("here we go");
      final response = await http.get(
        Uri.https(
          "api.commercepal.com",
          "/api/v2/products/${widget.productId}",
        ),
        headers: <String, String>{},
      );
      var data = jsonDecode(response.body);
      data = data['responseData']['content'];
      appLog(response.request);

      if (data['statusCode'] == '000') {
        setState(() async {
          for (var picture in data['Pictures']) {
            mainPics.add(picture['Url']);
          }
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String currentCountry = prefs.getString("currency") ?? "ETB";
          final String currentCountryCode = prefs.getString("country") ?? "ET";
          appLog(currentCountryCode);
          appLog(currentCountry);
          currentCountryForm = currentCountry;
          prodName = data['OriginalTitle'];
          appLog("the price range is here");
          myPriceRange = data["QuantityRanges"] != null
              ? parseQuantityRanges(
                  List<Map<String, dynamic>>.from(data["QuantityRanges"]),
                  currentCountryCode,
                  currentCountry)
              : [
                  Prices(
                    originalPrice: ((data['Price']['prices'] as List)
                            .firstWhere((p) =>
                                p['countryCode'] ==
                                currentCountryCode)['prices'] as List)
                        .firstWhere(
                            (t) => t['currencyCode'] == currentCountry)['price']
                        .toString(),
                    baseMarkup: 0,
                    minOr: "1",
                  )
                ];
          appLog("my price range");
          appLog(myPriceRange[0].originalPrice);
          for (var attr in data['Attributes']) {
            if (attr['IsConfigurator'] == true) {
              // appLog(attr['OriginalPropertyName']);
              myProdAttr.add(ProductAttributes(
                  Vid: attr['Vid'],
                  PropertyName: attr['PropertyName'],
                  IsConfigurator: attr['IsConfigurator'],
                  MiniImageUrl: attr['MiniImageUrl'],
                  Value: attr['Value'],
                  OriginalValue: attr['OriginalValue'],
                  ImageUrl: attr['ImageUrl'],
                  Pid: attr['Pid'],
                  OriginalPropertyName: attr['OriginalPropertyName']));
            }
          }
          appLog("here are the atributes");
          appLog(myProdAttr);

          for (var attr in myProdAttr) {
            uniquePropertyNames.add(attr.PropertyName);
          }
// Convert the Set to a List (if needed)
          uniquePropertyNamesList = uniquePropertyNames.toList();
          final productInfoList = parseProviderConfigModelList(
              data['ConfiguredItems'], currentCountry, currentCountryCode);
          appLog(productInfoList.length);
          for (var item in productInfoList) {
            appLog(item.vid);
            appLog(item.originalPrice);
          }
          for (var config in productInfoList) {
            myConfigs.add(ProviderConfigModel(
                baseMarkup: config.baseMarkup,
                id: config.id,
                vid: config.vid,
                tieredPrices: config.tieredPrices,
                additionalItemPrice: config.additionalItemPrice,
                originalPrice: config.originalPrice));
          }
          if (data['RecommendedItems']['details'].isEmpty == false) {
            final prod = data['RecommendedItems'];
            final prodObjs =
                ProductsDto.fromJson(prod, currentCountry, currentCountryCode);
            if (prodObjs.details?.isEmpty == true) {}
            appLog("hrreeerr");
            recommendedProd = prodObjs.details!
                .where((element) => element.productId != null)
                .map((e) => e.toProduct())
                .toList();
          }
          loading = false;
        });
        // Handle the case when statusCode is '000'
      } else {
        appLog(response.body);
        setState(() {
          loading = true;
        });
        // Retry limit reached, handle accordingly
      }
    } catch (e) {
      appLog("Error: ${e.toString()}");
      setState(() {
        loading = true;
      });

      // Handle other exceptions
    }
  }

  List<Prices> parseQuantityRanges(List<Map<String, dynamic>> quantityRanges,
      String country, String currency) {
    List<Prices> pricesList = [];

    for (int i = 0; i < quantityRanges.length; i++) {
      var minQuantity = quantityRanges[i]['MinQuantity'].toString();

      // Get the prices array
      var prices = quantityRanges[i]['Price']['prices'] as List;
      // Select price based on country
      appLog("parsing the quantity");
      appLog(prices);
      var priceData1 = prices.firstWhere((p) => p['countryCode'] == (country))
          as Map<dynamic, dynamic>;
      var priceData2 = priceData1["prices"] as List<dynamic>;
      var priceData =
          priceData2.firstWhere((p) => p['currencyCode'] == currency);

      // Convert to string to handle both int and double values
      var price = priceData['price'].toString();
      // Ensure baseMarkup is handled as double
      // var baseMarkup = (priceData['baseMarkup'] is int)
      //     ? (priceData['baseMarkup'] as int).toDouble()
      //     : priceData['baseMarkup'] as double;

      String? maxQuantity;
      if (i == quantityRanges.length - 1) {
        maxQuantity = null;
      } else {
        // Convert to int first, then subtract, then convert to string
        maxQuantity =
            (int.parse(quantityRanges[i + 1]['MinQuantity'].toString()) - 1)
                .toString();
      }

      pricesList.add(Prices(
          originalPrice: price,
          minOr: minQuantity,
          maxOr: maxQuantity,
          baseMarkup: 0));
    }
    return pricesList;
  }

  Widget _buildDeliveryEstimate(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_shipping_outlined,
                color: AppColors.colorPrimaryDark,
                size: 24,
              ),
              const SizedBox(width: 8),
              FutureBuilder(
                future: TranslationService.translate("Delivery Options"),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? "Delivery Options",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Same Town Delivery
          _buildDeliveryOption(
            context,
            icon: Icons.directions_run,
            title: "Express City Delivery",
            duration:
                "${DateFormat('MMM dd').format(DateTime.now().add(const Duration(days: 2)))} - ${DateFormat('MMM dd').format(DateTime.now().add(const Duration(days: 3)))}",
            subtitle: "For deliveries within same city (e.g., Addis to Addis)",
            color: Colors.green,
          ),

          const Divider(height: 24),

          // Local Delivery
          _buildDeliveryOption(
            context,
            icon: Icons.local_shipping,
            title: "Local Delivery",
            duration:
                "${DateFormat('MMM dd').format(DateTime.now().add(const Duration(days: 7)))} - ${DateFormat('MMM dd').format(DateTime.now().add(const Duration(days: 10)))}",
            subtitle: "For deliveries within Ethiopia",
            color: AppColors.colorPrimaryDark,
          ),

          const Divider(height: 24),

          // International Delivery
          _buildDeliveryOption(
            context,
            icon: Icons.flight,
            title: "International Shipping",
            duration: DateFormat('MMM dd')
                .format(DateTime.now().add(const Duration(days: 20))),
            subtitle: "For international deliveries",
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String duration,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: TranslationService.translate(title),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  );
                },
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              FutureBuilder(
                future: TranslationService.translate(subtitle),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
