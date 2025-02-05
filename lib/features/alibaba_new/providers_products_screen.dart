import 'dart:convert';

import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/core/cart-core/cart_widget.dart';
import 'package:commercepal/core/widgets/app_button.dart';
import 'package:commercepal/features/alibaba_new/provider_attributes_widget.dart';
import 'package:commercepal/features/alibaba_new/provider_config_model.dart';
// import 'package:commercepal/features/alibaba_new/the_new.dart';
import 'package:commercepal/features/alibaba_product_view/alibaba_products_screen.dart';
import 'package:commercepal/features/alibaba_product_view/image_slider.dart';
import 'package:commercepal/features/alibaba_product_view/minOrder_price.dart';
import 'package:commercepal/features/dashboard/dashboard_page.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class Prices {
//   final String price;
//   final String minOr;
//   final String? maxOr;

//   Prices({required this.price, required this.minOr, this.maxOr});
// }

class ProvidersProductsScreen extends StatefulWidget {
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
    fetchProductItem();
  }

  String currentCountryForm = "";
  bool addedToCart = false;
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
        actions: const [
          CartWidget(),
        ],
      ),
      body: SingleChildScrollView(
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  ImageSlider(
                    imageUrls: mainPics,
                    attributes: myProdAttr,
                    onShowAllImages: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductAttributesWidget(
                            myProdAttr: myProdAttr,
                            myPriceRange: myPriceRange,
                            myConfig: myConfigs,
                            productName: prodName,
                            productId: widget.productId,
                            imageUrl: mainPics[0],
                            currentCountry: currentCountryForm,
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    child: Row(
                      children: [
                        Flexible(
                          child: FutureBuilder(
                            future: TranslationService.translate(prodName),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data ?? prodName,
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: MinOrderPricePage(
                      currentCountryForm: currentCountryForm,
                      price: myPriceRange,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildDeliveryEstimate(context),
                  SizedBox(height: 16),
                  // SizedBox(
                  //     height:
                  //         // myProdAttr.length < 4
                  //         //     ? 160
                  //         //     : myProdAttr.length >= 4 && myProdAttr.length < 10
                  //         //         ? 300
                  //         //         :
                  //         500,
                  //     child: ProductAttributesWidget(
                  //       myProdAttr: myProdAttr,
                  //       myPriceRange: myPriceRange,
                  //       myConfig: myConfigs,
                  //       productName: prodName,
                  //       productId: widget.productId,
                  //       imageUrl: mainPics[0],
                  //       currentCountry: currentCountryForm,
                  //     )),
                ],
              ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Container(
          // Set height to null to fit the child dynamically
          height: null,
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Make the column's size fit its children
            children: [
              loading
                  ? Center(
                      child: Container(),
                    )
                  : (addedToCart
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 3.0),
                                child: AppButtonWidget(
                                  text: "Continue Shopping",
                                  onClick: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        DashboardPage.routeName,
                                        (route) => false);
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: AppButtonWidget(
                                  text: "Checkout",
                                  onClick: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        DashboardPage.routeName,
                                        (route) => false,
                                        arguments: {"redirect_to": "cart"});
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      : AppButtonWidget(
                          text: "Start Order",
                          onClick: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductAttributesWidget(
                                  myProdAttr: myProdAttr,
                                  myPriceRange: myPriceRange,
                                  myConfig: myConfigs,
                                  productName: prodName,
                                  productId: widget.productId,
                                  imageUrl: mainPics[0],
                                  currentCountry: currentCountryForm,
                                ),
                              ),
                            ).then((value) {
                              if (value == true) {
                                setState(() {
                                  addedToCart = true;
                                  print("added to cart");
                                  print("loading");
                                  print(loading);
                                });
                              }
                            });
                          },
                        )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchProductItem() async {
    try {
      setState(() {
        loading = true;
      });
      // print(widget.productId);
      // final prefsData = getIt<PrefsData>();
      // final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      // if (isUserLoggedIn) {
      //   final token = await prefsData.readData(PrefsKeys.userToken.name);
      final response = await http.get(
        Uri.https(
          "api.commercepal.com:2096",
          "/prime/api/v1/data/products/${widget.productId}",
        ),
        headers: <String, String>{},
      );

      var data = jsonDecode(response.body);
      // print(data);

      if (data['statusCode'] == '000') {
        setState(() async {
          for (var picture in data['Pictures']) {
            mainPics.add(picture['Url']);
          }
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String currentCountry = prefs.getString("currency") ?? "ETB";
          currentCountryForm = currentCountry;
          prodName = data['OriginalTitle'];
          // print("the price range is here");
          myPriceRange = data["QuantityRanges"] != null
              ? parseQuantityRanges(
                  List<Map<String, dynamic>>.from(data["QuantityRanges"]),
                  currentCountry)
              : [
                  Prices(
                    originalPrice: (data['Price']['prices'] as List)
                        .firstWhere((p) =>
                            p['currencyCode'] ==
                            (currentCountry))['originalPrice']
                        .toString(),
                    baseMarkup: ((data['Price']['prices'] as List).firstWhere(
                                (p) => p['currencyCode'] == (currentCountry))['baseMarkup']
                            is int)
                        ? ((data['Price']['prices'] as List).firstWhere((p) =>
                                p['currencyCode'] ==
                                (currentCountry))['baseMarkup'] as int)
                            .toDouble()
                        : (data['Price']['prices'] as List).firstWhere((p) =>
                            p['currencyCode'] == (currentCountry))['baseMarkup'],
                    minOr: "1",
                  )
                ];
          print("my price range");
          print(myPriceRange.length);
          for (var attr in data['Attributes']) {
            if (attr['IsConfigurator'] == true) {
              // print(attr['OriginalPropertyName']);
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
          print("here are the atributes");
          print(myProdAttr);

          for (var attr in myProdAttr) {
            uniquePropertyNames.add(attr.PropertyName);
          }
// Convert the Set to a List (if needed)
          uniquePropertyNamesList = uniquePropertyNames.toList();
          final productInfoList = parseProviderConfigModelList(
              data['ConfiguredItems'], currentCountry);
          print(productInfoList.length);
          for (var item in productInfoList) {
            print(item.vid);
            print(item.originalPrice);
          }
          for (var config in productInfoList) {
            myConfigs.add(ProviderConfigModel(
                baseMarkup: config.baseMarkup,
                id: config.id,
                vid: config.vid,
                originalPrice: config.originalPrice));
          }
          loading = false;
        });
        // Handle the case when statusCode is '000'
      } else {
        setState(() {
          loading = true;
        });
        // Retry limit reached, handle accordingly
      }
    } catch (e) {
      print("Error: ${e.toString()}");
      setState(() {
        loading = true;
      });

      // Handle other exceptions
    }
  }

  List<Prices> parseQuantityRanges(
      List<Map<String, dynamic>> quantityRanges, String country) {
    List<Prices> pricesList = [];

    for (int i = 0; i < quantityRanges.length; i++) {
      var minQuantity = quantityRanges[i]['MinQuantity'].toString();

      // Get the prices array
      var prices = quantityRanges[i]['Price']['prices'] as List;
      // Select price based on country
      var priceData = prices.firstWhere((p) => p['currencyCode'] == (country))
          as Map<String, dynamic>;

      // Convert to string to handle both int and double values
      var price = priceData['originalPrice'].toString();
      // Ensure baseMarkup is handled as double
      var baseMarkup = (priceData['baseMarkup'] is int)
          ? (priceData['baseMarkup'] as int).toDouble()
          : priceData['baseMarkup'] as double;

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
          baseMarkup: baseMarkup));
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
            duration:
                "${DateFormat('MMM dd').format(DateTime.now().add(const Duration(days: 20)))} - ${DateFormat('MMM dd').format(DateTime.now().add(const Duration(days: 35)))}",
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
