// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:commercepal/app/utils/country_manager/country_manager.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/cart-core/bloc/cart_core_cubit.dart';
import 'package:commercepal/core/cart-core/cart_widget.dart';
import 'package:commercepal/core/cart-core/domain/cart_item.dart';
import 'package:commercepal/features/alibaba_product_view/attributes_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/core/widgets/app_button.dart';
import 'package:commercepal/features/alibaba_product_view/attribute_image_slider.dart';
import 'package:commercepal/features/alibaba_product_view/attribute_modal_screen.dart';
import 'package:commercepal/features/alibaba_product_view/image_slider.dart';
import 'package:commercepal/features/alibaba_product_view/minOrder_price.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlibabaProductsScreen extends StatefulWidget {
  final String productId;
  final String provider;
  const AlibabaProductsScreen(
      {super.key, required this.productId, required this.provider});

  @override
  State<AlibabaProductsScreen> createState() => _AlibabaProductsScreenState();
}

class _AlibabaProductsScreenState extends State<AlibabaProductsScreen> {
  @override
  void initState() {
    super.initState();
    fetchProductItem();
  }

  String currentCountryForm = "";
  void handleImageSelected(int index) {
    // Handle the selected image index
    // print('Selected image index: $index');
  }
  final countryManager = CountryManager();
  String prodName = "";
  List<String> mainPics = [];
  List<Prices> myPriceRange = [];
  List<ProductAttributes> myProdAttr = [];
  List<ConfiguratorInfo> myConfigs = [];
  List<Map<String, dynamic>> selectedItems = [];
  List<ListItem> myListItem = [];
  var loading = false;
  var vendorName = "";
  String totalPrice = "";
  bool config = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: loading
          ? Container(height: 70)
          : checkOut_widget(
              currentCountryForm: currentCountryForm,
              minOrder: myPriceRange[0].minOr,
              price: totalPrice,
              prodName: prodName,
              config: config,
              myList: myListItem,
              selection: selectedItems,
              productId: widget.productId,
              image: mainPics[0],
            ),
      appBar: AppBar(
        title: Text(
          "Place your order",
          style: Theme.of(context).textTheme.displaySmall,
        ),
        actions: const [
          CartWidget(),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  ImageSlider(
                    imageUrls: mainPics,
                    onShowAllImages: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 10),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            prodName,
                            style: Theme.of(context).textTheme.bodyLarge,
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
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                    child: Divider(
                      color: AppColors.greyColor,
                      thickness: 5,
                    ),
                  ),
                  if (myListItem.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Description above the button
                          Text(
                            "Customize your product by selecting the attributes below:",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[700],
                                ),
                          ),
                          const SizedBox(
                              height:
                                  8), // Space between the description and the button
                          GestureDetector(
                            onTap: () {
                              if (myListItem.isNotEmpty) {
                                showCupertinoModalBottomSheet(
                                  isDismissible: false,
                                  context: context,
                                  builder: (context) => GestureDetector(
                                    onVerticalDragUpdate: (_) {},
                                    child: AttributeModalScreen(
                                      currentCountryForm: currentCountryForm,
                                      myAttributes: myProdAttr,
                                      myPrices: myPriceRange,
                                      myConfig: myConfigs,
                                      onProceed: handleProceed,
                                    ),
                                  ),
                                );
                              } else {
                                displaySnack(
                                    context, "There are no Attributes");
                              }
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 168, 123, 144),
                                          Color.fromARGB(255, 123, 77, 136),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 12.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Select Attributes (${myProdAttr.length})",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(
                                            width:
                                                8), // Space between text and icon
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      showCupertinoModalBottomSheet(
                        context: context,
                        builder: (context) => AttributeModalScreen(
                          currentCountryForm: currentCountryForm,
                          myAttributes: myProdAttr,
                          myPrices: myPriceRange,
                          myConfig: myConfigs,
                          onProceed: handleProceed,
                        ),
                      );
                    },
                    child: AttributeImageScroller(
                      imageUrls:
                          myProdAttr.map((e) => e.MiniImageUrl ?? '').toList(),
                      onImageSelected: (selectedImage) {
                        // Perform any specific action for image selection here if needed
                        // Then redirect to the modal
                        showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) => AttributeModalScreen(
                            currentCountryForm: currentCountryForm,
                            myAttributes: myProdAttr,
                            myPrices: myPriceRange,
                            myConfig: myConfigs,
                            onProceed: handleProceed,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            "Vendor: $vendorName",
                            // maxLines: 2, // Allows up to 2 lines; increase if needed
                            // overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge, // Adds "..." if text is too long for 2 lines
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
      )),
    );
  }

  void handleProceed(List<Map<String, dynamic>> selectedItem) {
    // print("from the home");
    double total = 0.0;
    for (var tot in selectedItem) {
      total += tot['price'] as double;
    }

    setState(() {
      selectedItems = selectedItem;
      config = !config;
      totalPrice = total.toString();
    });
    // print("Total price: $total");
  }

  String sanitizeInput(String input) {
    return input.replaceAll(RegExp(r'[^0-9.]'), '');
  }

  Future<void> calculateTotal(List<Prices> priceRange) async {
    try {
      // Avoid calling setState unnecessarily
      // int loopCount = int.parse(priceRange[0].minOr);
      // print("loopCount");
      // print(loopCount);
      // for (int i = 0; i < loopCount; i++) {
      setState(() {
        if (myListItem.isNotEmpty) {
          selectedItems.add({
            'id': myListItem[0].id,
            'price': myListItem[0].price,
            'count': priceRange[0].minOr, // Add count for each product
          });
        } else {
          selectedItems.add({
            'id': myListItem.isNotEmpty ? myListItem[0].id : "",
            'price': priceRange[0].originalPrice,
            'count': priceRange[0].minOr, // Add count for each product
          });
        }
      });
      // }

      // print("The min order:");
      // print(selectedItems.length);

// Attempt to parse `priceRange[0].price` and `priceRange[0].minOr` after trimming whitespace.
      try {
        // Sanitize and parse the price and min order values
        double price = double.parse(sanitizeInput(priceRange[0].originalPrice.trim()));
        double minOrder =
            double.parse(sanitizeInput(priceRange[0].minOr.trim()));

        // Calculate the total
        double calculatedTotal = price * minOrder;

        // Update the totalPrice in the state
        setState(() {
          totalPrice = calculatedTotal.toString();
        });

        // print("Total Price after calculation: $totalPrice");
      } catch (e) {
        print("Error parsing values: ${e.toString()}");
      }

      // if(priceRange[0].minOr != null ){

      // }
      // print("Calculated total price: $totalPrice");
    } catch (e) {
      print("Error: $e");
    }
    return; // Ensures the function completes with a non-null return
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
          // await countryManager.loadCountryFromPreferences();
          // final String currentCountry = countryManager.country;
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
                            p['currencyCode'] == (currentCountry))['price']
                        .toString(),
                    baseMarkup: 0,
                    minOr: "1",
                  )
                ];
          // print(myPriceRange[0].minOr);
          for (var attr in data['Attributes']) {
            if (attr['IsConfigurator'] == true
                // &&
                //     attr['MiniImageUrl'] != null &&
                //     attr['ImageUrl'] != null
                ) {
              // print(attr['OriginalPropertyName']);
              myProdAttr.add(ProductAttributes(
                  Vid: attr['Vid'],
                  PropertyName: attr['PropertyName'],
                  IsConfigurator: attr['IsConfigurator'],
                  MiniImageUrl: attr['MiniImageUrl'] ?? mainPics[0],
                  Value: attr['Value'],
                  OriginalValue: attr['OriginalValue'],
                  ImageUrl: attr['ImageUrl'] ?? mainPics[0],
                  Pid: attr['Pid'],
                  OriginalPropertyName: attr['OriginalPropertyName']));
            }
          }
          // print("here are the atributes");
          // print(myProdAttr);
          final productInfoList = parseConfiguratorInfoList(
              data['ConfiguredItems'], currentCountry);
          for (var config in productInfoList) {
            myConfigs.add(ConfiguratorInfo(
                id: config.id,
                vid: config.vid,
                originalPrice: config.originalPrice));
          }
          vendorName = data['VendorDisplayName'];
          setState(() {
            myListItem = createListItems(myProdAttr, myConfigs);
          });
          calculateTotal(myPriceRange);
          // print(myListItem.le);
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
          .add(Prices(originalPrice: price, minOr: minQuantity, maxOr: maxQuantity, baseMarkup: 0));
    }
    return pricesList;
  }

  List<ListItem> createListItems(
      List<ProductAttributes> myAttributes, List<ConfiguratorInfo> myConfig) {
    return myAttributes.map((attribute) {
      // Find matching ConfiguratorInfo by Vid
      final matchingConfig = myConfig.firstWhere(
        (config) => config.vid == attribute.Vid,
        orElse: () => ConfiguratorInfo(id: '', vid: '', originalPrice: 0.0),
      );

      // print("Attributes");
      // print(ListItem(
      //   id: matchingConfig.id,
      //   imageUrl: attribute.ImageUrl,
      //   title: attribute.Vid,
      //   price: matchingConfig.originalPrice,
      // ));
      // Create ListItem using values from attribute and matchingConfig
      return ListItem(
          id: matchingConfig.id,
          imageUrl: attribute.ImageUrl ?? '',
          title: attribute.Vid,
          price: matchingConfig.originalPrice,
          name: attribute.OriginalValue);
    }).toList();
  }
}

class checkOut_widget extends StatelessWidget {
  final String minOrder;
  final String price;
  final String prodName;
  final bool config;
  final String productId;
  final String image;
  final String currentCountryForm;
  final List<ListItem>? myList;
  final List<Map<String, dynamic>> selection;
  checkOut_widget({
    required this.price,
    super.key,
    required this.prodName,
    required this.config,
    this.myList,
    required this.selection,
    required this.productId,
    required this.image,
    required this.minOrder,
    required this.currentCountryForm,
  });
  final countryManager = CountryManager();
  String sanitizeInput(String input) {
    return input.replaceAll(RegExp(r'[^0-9.]'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.greyColor,
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // checkOut_widget(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Total: ${currentCountryForm == "ETB" ? "ETB" : "\$"} ${formatPrice(price)}",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                // Text(
                //   "Delivery date: Nov. 4-24",
                //   style: Theme.of(context).textTheme.bodyLarge,
                // )
              ],
            ),
          ),
          SizedBox(
              width: 140,
              height: 50,
              child: AppButtonWidget(
                isLoading: false,
                text: "Add to Cart",
                onClick: () async {
                  // print(minOrder);
                  var mini = 0;
                  for (var i in selection) {
                    mini += int.parse(i['count'].toString());
                  }
                  print(mini);
                  if (int.parse(minOrder) <= mini) {
                    try {
                      // await countryManager.loadCountryFromPreferences();
                      // final String currentCountry = countryManager.country;
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final String currentCountry =
                          prefs.getString("currency") ?? "ETB";
                      print(currentCountry);
                      for (var sel in selection) {
                        print("the id heer");
                        print(sel['count']);
                        // Validate and parse 'id'
                        // final id =
                        //     sel['id'] != null && sel['id'].toString().isNotEmpty
                        //         ? int.tryParse(sel['id'].toString()) ?? 0
                        //         : 0;

                        // Validate and parse 'count'
                        final count = sel['count'] is int
                            ? sel['count']
                            : (sel['count'] != null &&
                                    sel['count'].toString().isNotEmpty
                                ? int.tryParse(sel['count'].toString()) ?? 0
                                : 0);

                        // Create CartItem
                        CartItem myItem = CartItem(
                          currency: currentCountry == "ETB" ? "ETB" : "\$",
                          description: "provider",
                          subProductId: sel[
                              'id'], // Assuming sel['id'] is fine as a string here
                          name: prodName.toString(),
                          price:
                              sanitizeInput(sel['price'].toString()).toString(),
                          image: image.toString(),
                          productId: productId.toString(),
                          // id: id, // Use validated and parsed ID
                          quantity: count, // Use validated and parsed count
                        );

                        // Debug print
                        print("Item added to cart: ${myItem.price}");

                        // Add to cart
                        context.read<CartCoreCubit>().addCartItem(myItem);
                      }

                      // Show snack bar
                      displaySnack(context, "$prodName added to cart");
                    } catch (e) {
                      print("Error: ${e.toString()}");
                    }

                    // if (myList != null && config) {
                    // for (var i in selection) {
                    // }
                    // }
                  } else {
                    displaySnack(context,
                        "The minimum order count for this product is $minOrder");
                  }
                },
              ))
        ],
      ),
    );
  }

  String formatPrice(String price) {
    try {
      // Convert the price to a double and round to two decimal places
      double value = double.parse(price);
      return value
          .toStringAsFixed(2); // Format as a string with two decimal points
    } catch (e) {
      return '0.00'; // Return a default value if there's an error
    }
  }
}

class ProductAttributes {
  final String Vid;
  final String PropertyName;
  final bool IsConfigurator;
  final String? MiniImageUrl;
  final String Value;
  final String OriginalValue;
  final String? ImageUrl;
  final String Pid;
  final String OriginalPropertyName;
  ProductAttributes({
    required this.Vid,
    required this.PropertyName,
    required this.IsConfigurator,
    this.MiniImageUrl,
    required this.Value,
    required this.OriginalValue,
    this.ImageUrl,
    required this.Pid,
    required this.OriginalPropertyName,
  });
}
