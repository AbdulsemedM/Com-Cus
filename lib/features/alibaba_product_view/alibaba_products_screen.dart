// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/cart-core/bloc/cart_core_cubit.dart';
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

  void handleImageSelected(int index) {
    // Handle the selected image index
    // print('Selected image index: $index');
  }

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
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  ImageSlider(imageUrls: mainPics),
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
                      child: GestureDetector(
                          onTap: () {
                            if (myListItem.isNotEmpty) {
                              showCupertinoModalBottomSheet(
                                isDismissible: false,
                                context: context,
                                builder: (context) => GestureDetector(
                                  onVerticalDragUpdate: (_) {},
                                  child: AttributeModalScreen(
                                    myAttributes: myProdAttr,
                                    myPrices: myPriceRange,
                                    myConfig: myConfigs,
                                    onProceed: handleProceed,
                                  ),
                                ),
                              );
                            } else {
                              displaySnack(context, "There are no Attributes");
                            }
                          },
                          child: Row(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Ensures the Row only takes minimum space needed
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 168, 123, 144),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical:
                                            10), // Add padding here for spacing inside the container
                                    child: Row(
                                      mainAxisSize: MainAxisSize
                                          .min, // Ensures the inner Row only takes up space needed
                                      children: [
                                        Text(
                                          "Select Attributes (${myProdAttr.length})",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        const SizedBox(
                                            width:
                                                4), // Add a small space between text and icon if needed
                                        const Icon(
                                            Icons.arrow_forward_ios_rounded),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                  GestureDetector(
                    onTap: () {
                      showCupertinoModalBottomSheet(
                        context: context,
                        builder: (context) => AttributeModalScreen(
                          myAttributes: myProdAttr,
                          myPrices: myPriceRange,
                          myConfig: myConfigs,
                          onProceed: handleProceed,
                        ),
                      );
                    },
                    child: AttributeImageScroller(
                        imageUrls:
                            myProdAttr.map((e) => e.MiniImageUrl).toList(),
                        onImageSelected: handleImageSelected),
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
      int loopCount = int.parse(priceRange[0].minOr);
      for (int i = 0; i < loopCount; i++) {
        setState(() {
          if (myListItem.isNotEmpty) {
            selectedItems.add({
              'id': myListItem[0].id,
              'price': myListItem[0].price,
              'count': priceRange[0].minOr, // Add count for each product
            });
          } else {
            selectedItems.add({
              'id': "",
              'price': priceRange[0].price,
              'count': priceRange[0].minOr, // Add count for each product
            });
          }
        });
      }

      // print("The min order:");
      // print(selectedItems.length);

// Attempt to parse `priceRange[0].price` and `priceRange[0].minOr` after trimming whitespace.
      try {
        // Sanitize and parse the price and min order values
        double price = double.parse(sanitizeInput(priceRange[0].price.trim()));
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
        setState(() {
          for (var picture in data['Pictures']) {
            mainPics.add(picture['Url']);
          }
          prodName = data['OriginalTitle'];
          // print("the price range is here");
          myPriceRange = data["QuantityRanges"] != null
              ? parseQuantityRanges(
                  List<Map<String, dynamic>>.from(data["QuantityRanges"]))
              : [Prices(price: data['Price']['ConvertedPrice'], minOr: "1")];
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
          final productInfoList =
              parseConfiguratorInfoList(data['ConfiguredItems']);
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

  List<Prices> parseQuantityRanges(List<Map<String, dynamic>> quantityRanges) {
    List<Prices> pricesList = [];

    for (int i = 0; i < quantityRanges.length; i++) {
      var minQuantity = quantityRanges[i]['MinQuantity'].toString();
      var price = quantityRanges[i]['Price']['OriginalPrice'].toString();
      String? maxQuantity;

      if (i == quantityRanges.length - 1) {
        maxQuantity = null; // Last range, no upper limit
      } else {
        maxQuantity = (quantityRanges[i + 1]['MinQuantity'] - 1).toString();
      }

      pricesList
          .add(Prices(price: price, minOr: minQuantity, maxOr: maxQuantity));
    }
    // calculateTotal(pricesList);
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
          imageUrl: attribute.ImageUrl,
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
  final List<ListItem>? myList;
  final List<Map<String, dynamic>> selection;
  const checkOut_widget({
    required this.price,
    super.key,
    required this.prodName,
    required this.config,
    this.myList,
    required this.selection,
    required this.productId,
    required this.image,
    required this.minOrder,
  });
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
                  "Total: ETB ${formatPrice(price)}",
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
                onClick: () {
                  // print(minOrder);
                  if (int.parse(minOrder) <= selection.length) {
                    // print(int.parse(23).runtimeType);
                    try {
                      for (var sel in selection) {
                        // Validate and parse 'id'
                        final id =
                            sel['id'] != null && sel['id'].toString().isNotEmpty
                                ? int.tryParse(sel['id'].toString()) ?? 0
                                : 0;

                        // Validate and parse 'count'
                        final count = sel['count'] is int
                            ? sel['count']
                            : (sel['count'] != null &&
                                    sel['count'].toString().isNotEmpty
                                ? int.tryParse(sel['count'].toString()) ?? 0
                                : 0);

                        // Create CartItem
                        CartItem myItem = CartItem(
                          // id: productId,
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
  final String MiniImageUrl;
  final String Value;
  final String OriginalValue;
  final String ImageUrl;
  final String Pid;
  final String OriginalPropertyName;
  ProductAttributes({
    required this.Vid,
    required this.PropertyName,
    required this.IsConfigurator,
    required this.MiniImageUrl,
    required this.Value,
    required this.OriginalValue,
    required this.ImageUrl,
    required this.Pid,
    required this.OriginalPropertyName,
  });
}
