import 'dart:convert';

import 'package:commercepal/core/cart-core/cart_widget.dart';
import 'package:commercepal/core/widgets/app_button.dart';
import 'package:commercepal/features/alibaba_new/provider_attributes_widget.dart';
import 'package:commercepal/features/alibaba_new/provider_config_model.dart';
// import 'package:commercepal/features/alibaba_new/the_new.dart';
import 'package:commercepal/features/alibaba_product_view/alibaba_products_screen.dart';
import 'package:commercepal/features/alibaba_product_view/image_slider.dart';
import 'package:commercepal/features/alibaba_product_view/minOrder_price.dart';
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
        title: Text(
          "Place your order",
          style: Theme.of(context).textTheme.displaySmall,
        ),
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
                          child: Text(
                            prodName,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      style: Theme.of(context).textTheme.bodyLarge,
                      "Estimated delivery date: ${DateFormat('MMM dd, yyyy').format(DateTime.now().add(const Duration(days: 10)))}",
                    ),
                  ),

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
                  : AppButtonWidget(
                      text: "Add to cart",
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
                        );
                      },
                    ),
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
                    price: (data['Price']['prices'] as List)
                        .firstWhere((p) =>
                            p['currencyCode'] == (currentCountry))['price']
                        .toString(),
                    minOr: "1",
                  )
                ];
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
      setState(() {
        loading = true;
      });
      print(e.toString());

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

      var price = priceData['price'].toString();

      String? maxQuantity;
      if (i == quantityRanges.length - 1) {
        maxQuantity = null;
      } else {
        maxQuantity = (quantityRanges[i + 1]['MinQuantity'] - 1).toString();
      }

      pricesList
          .add(Prices(price: price, minOr: minQuantity, maxOr: maxQuantity));
    }
    return pricesList;
  }
}
