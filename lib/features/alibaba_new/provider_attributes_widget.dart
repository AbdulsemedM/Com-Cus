import 'dart:io';

import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/cart-core/bloc/cart_core_cubit.dart';
import 'package:commercepal/core/cart-core/cart_widget.dart';
import 'package:commercepal/core/cart-core/domain/cart_item.dart';
import 'package:commercepal/features/alibaba_new/provider_config_model.dart';
import 'package:commercepal/features/alibaba_product_view/alibaba_products_screen.dart';
import 'package:commercepal/features/alibaba_product_view/minOrder_price.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttributeCombination {
  final Map<String, ProductAttributes> attributes;
  final int quantity;

  AttributeCombination({
    required this.attributes,
    required this.quantity,
  });

  String get displayText {
    return attributes.values
        .map((attr) => '${attr.PropertyName}: ${attr.OriginalValue}')
        .join(', ');
  }
}

class ProductAttributesWidget extends StatefulWidget {
  final List<ProductAttributes> myProdAttr;
  final List<Prices> myPriceRange;
  final List<ProviderConfigModel> myConfig;
  final String productName;
  final String productId;
  final String imageUrl;
  final String currentCountry;

  const ProductAttributesWidget(
      {super.key,
      required this.myProdAttr,
      required this.myPriceRange,
      required this.myConfig,
      required this.productName,
      required this.productId,
      required this.imageUrl,
      required this.currentCountry});

  @override
  _ProductAttributesWidgetState createState() =>
      _ProductAttributesWidgetState();
}

class _ProductAttributesWidgetState extends State<ProductAttributesWidget> {
  late Map<String, List<ProductAttributes>> groupedAttributes;
  late Map<String, ProductAttributes?> selectedAttributes;
  late Map<String, TextEditingController> quantityControllers;
  String? errorText;
  GlobalKey<FormState> myKey = GlobalKey<FormState>();
  List<CartItem> myCart = [];
  List<AttributeCombination> selectedCombinations = [];
  Map<String, int> combinationQuantities = {};
  late TextEditingController simpleQuantityController;

  int get totalQuantity =>
      selectedCombinations.fold(0, (sum, combo) => sum + combo.quantity);

  @override
  void initState() {
    super.initState();
    simpleQuantityController = TextEditingController(text: "0");
    groupedAttributes = _groupAttributesByPropertyName(widget.myProdAttr);
    selectedAttributes = {
      for (var group in groupedAttributes.keys) group: null,
    };

    // Only initialize quantityControllers if there are attributes
    if (groupedAttributes.isNotEmpty) {
      quantityControllers = {
        for (var attr in groupedAttributes[groupedAttributes.keys.last]!)
          attr.Vid: TextEditingController(text: "0")
      };
    } else {
      quantityControllers = {}; // Initialize empty map if no attributes
    }
  }

  @override
  void dispose() {
    simpleQuantityController.dispose();
    quantityControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _validateQuantityInput(String value) {
    final minOrder = widget.myPriceRange[0].minOr;
    final quantity = int.tryParse(value);
    setState(() async {
      if (quantity == null || quantity < double.parse(minOrder)) {
        errorText = await TranslationService.translate(
            "Quantity must be at least $minOrder");
      } else {
        errorText = null;
      }
    });
  }

  void _addToCartItems() {
    // if (myKey.currentState!.validate()) {
    // Validate minimum order requirement
    // if (!_isMinOrderValid()) {
    //   // Show error message about minimum order not met
    //   return;
    // }

    // Get all selected combinations and their quantities
    for (var combination in selectedCombinations) {
      // Get the configuration for this combination
      var combinationVids =
          combination.attributes.values.map((attr) => attr.Vid).toList();
      // print("combinationVids");
      // print(combinationVids);

      ProviderConfigModel? matchingConfig;
      if (widget.myConfig.isNotEmpty) {
        try {
          matchingConfig = widget.myConfig.firstWhere((config) {
            return combinationVids.every((vid) => config.vid.contains(vid));
          });
        } catch (e) {
          // No matching config found for this combination
          print("No matching config found for combination: $combinationVids");
          continue;
        }
      }
      print("matchingConfig");
      print(matchingConfig?.originalPrice);
      // Find applicable price range for this combination's quantity
      final Prices applicablePrice = widget.myPriceRange.firstWhere(
        (price) {
          final int minQuantity = int.parse(price.minOr);
          final int? maxQuantity =
              price.maxOr != null ? int.parse(price.maxOr!) : null;

          return combination.quantity >= minQuantity &&
              (maxQuantity == null || combination.quantity <= maxQuantity);
        },
        orElse: () => widget.myPriceRange.first,
      );
      // print("applicablePrice");
      // print(applicablePrice.price);

      // Calculate total price for this combination
      final double unitPrice = double.parse(applicablePrice.originalPrice);
      final double totalPrice = unitPrice * combination.quantity;

      // Add to cart
      // setState(() {
      myCart.add(CartItem(
        baseMarkup: matchingConfig?.baseMarkup.toString(),
        currency: widget.currentCountry == "ETB" ? "ETB" : "\$",
        description: "provider",
        subProductId: matchingConfig?.id ?? "0",
        name: widget.productName.toString(),
        price: matchingConfig?.originalPrice.toString(),
        image: widget.imageUrl.toString(),
        productId: widget.productId.toString(),
        quantity: combination.quantity,
        createdAt: DateTime.now().toIso8601String(),
      ));
      print("myCart");
      print(myCart[0].createdAt);
      print(myCart[0].merchantId);
      print("myCart");
      print(myCart[0].price);
      print(calculateTotalPrice(
          double.parse(matchingConfig?.originalPrice.toString() ?? "0"),
          matchingConfig?.baseMarkup ?? 0,
          combination.quantity));
    }
    _addToCart();
    // }
  }

  String? _validateQuantity(String value) {
    // final minOrder = widget.myPriceRange[0].minOr;
    // final quantity = int.tryParse(value);

    if (int.parse(value) < 1) {
      return ("Quantity must be at least 1");
    } else {
      return null;
    }
  }

  Map<String, List<ProductAttributes>> _groupAttributesByPropertyName(
      List<ProductAttributes> attributes) {
    Map<String, List<ProductAttributes>> grouped = {};
    for (var attribute in attributes) {
      if (grouped.containsKey(attribute.PropertyName)) {
        grouped[attribute.PropertyName]?.add(attribute);
      } else {
        grouped[attribute.PropertyName] = [attribute];
      }
    }
    return grouped;
  }

  void _onItemClicked(String propertyName, ProductAttributes attribute) {
    setState(() {
      // Simply update the selection without clearing previous combinations
      if (selectedAttributes[propertyName] == attribute) {
        selectedAttributes[propertyName] = null;
      } else {
        selectedAttributes[propertyName] = attribute;
      }

      // Initialize quantity for new combination if it's the last attribute
      if (propertyName == groupedAttributes.keys.last &&
          selectedAttributes[propertyName] != null &&
          _canSelectLastAttribute()) {
        String combinationKey = _getCombinationKey();
        if (!combinationQuantities.containsKey(combinationKey)) {
          combinationQuantities[combinationKey] = 0;
        }
      }
    });
  }

  bool _areAllGroupsSelected() {
    // Check if all groups have a selected attribute
    return selectedAttributes.values.every((selection) => selection != null);
  }

  bool _isMinOrderValid() {
    int totalQuantity = 0;

    // Sum quantities from selectedCombinations
    for (var combo in selectedCombinations) {
      totalQuantity += combo.quantity;
    }

    // Sum quantities from combinationQuantities map
    for (var quantity in combinationQuantities.values) {
      totalQuantity += quantity;
    }

    // Sum quantities from myCart
    for (var item in myCart) {
      totalQuantity += item.quantity!;
    }

    // Check if total meets minimum order requirement
    return totalQuantity >= int.parse(widget.myPriceRange[0].minOr);
  }

  void _addToCart() {
    for (var item in myCart) {
      context.read<CartCoreCubit>().addCartItem(item);
    }
    displaySnack(context, "Product added to cart successfully");
    combinationQuantities.clear();
    myCart.clear();
    selectedCombinations.clear();
    Navigator.pop(context, true);
    // Collect the selected Vids and display them
    // if (myKey.currentState!.validate()) {
    // final selectedVids = selectedAttributes.values
    //     .where((attribute) => attribute != null)
    //     .map((attribute) => attribute!.Vid)
    //     .join(", ");
    // final List<String> selectedVidList =
    //     selectedVids.split(", ").map((vid) => vid.trim()).toList();

    // print("theConfig.id");
    // var myTheconfig;
    // print(myTheconfig);
    // if (widget.myConfig.isNotEmpty) {
    //   final ProviderConfigModel theConfig =
    //       widget.myConfig.firstWhere((config) {
    //     // Check if all selectedVidList values exist in the config's vid list
    //     return selectedVidList
    //         .every((selectedVid) => config.vid.contains(selectedVid));
    //   });
    //   myTheconfig = theConfig;
    // }
    // // Parse the quantity from the quantityController
    // final int quantity = int.tryParse(quantityController.text) ?? 0;

// Find the applicable price based on the quantity range
    // final Prices? applicablePrice = widget.myPriceRange.firstWhere(
    //   (price) {
    //     final int minQuantity = int.parse(price.minOr);
    //     final int? maxQuantity =
    //         price.maxOr != null ? int.parse(price.maxOr!) : null;

    //     // Check if quantity falls within this price range
    //     return quantity >= minQuantity &&
    //         (maxQuantity == null || quantity <= maxQuantity);
    //   },
    //   // orElse: () => null, // Return null if no price range matches
    // );

    // if (applicablePrice != null) {
    //   // Calculate the total price
    //   final double unitPrice = double.parse(applicablePrice.price);
    //   final double totalPrice = unitPrice * quantity;

    //   print("Total Price: $totalPrice");
    //   CartItem myItem = CartItem(
    //     currency: widget.currentCountry == "ETB" ? "ETB" : "\$",
    //     description: "provider",
    //     subProductId: myTheconfig == null ? "0" : myTheconfig.id,
    //     name: widget.productName.toString(),
    //     price: totalPrice.toString(),
    //     image: widget.imageUrl.toString(),
    //     productId: widget.productId.toString(),
    //     // id: id, // Use validated and parsed ID
    //     quantity: int.parse(
    //         quantityController.text), // Use validated and parsed count
    //   );

    //   // Debug print
    //   print("Item added to cart: ${myItem.price}");

    //   // Add to cart
    //   context.read<CartCoreCubit>().addCartItem(myItem);
    //   displaySnack(context, "Product added to cart successfully");
    // } else {
    //   // Handle the case where no price range matches
    //   print("No price range matches the given quantity.");
    // }
    // }
    // else {
    //   displaySnack(context,
    //       "The minimum number of products must be at least ${widget.myPriceRange[0].minOr}");
    // }
  }

  Widget _buildAttributeGrid(
      String propertyName, List<ProductAttributes> items) {
    bool isLastAttribute = propertyName == groupedAttributes.keys.last;

    if (isLastAttribute) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              propertyName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (!_canSelectLastAttribute())
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder(
                future: TranslationService.translate(
                    "Please select options above first"),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? "Please select options above first",
                    style: TextStyle(
                      color: Colors.red,
                      fontStyle: FontStyle.italic,
                    ),
                  );
                },
              ),
            ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final attribute = items[index];
              bool isSelected = selectedAttributes[propertyName] == attribute;
              bool canSelect = _canSelectLastAttribute();

              // Create a map of current selected attributes for this specific combination
              Map<String, ProductAttributes> currentAttributes = {};
              selectedAttributes.forEach((key, value) {
                if (value != null && key != propertyName) {
                  // Exclude the last property
                  currentAttributes[key] = value;
                }
              });
              // Add this specific last attribute
              currentAttributes[propertyName] = attribute;

              // Find quantity for this specific combination
              int quantity = selectedCombinations
                  .firstWhere(
                    (combo) => _compareCombinations(
                        combo.attributes, currentAttributes),
                    orElse: () =>
                        AttributeCombination(attributes: {}, quantity: 0),
                  )
                  .quantity;

              return Container(
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? AppColors.colorPrimaryDark
                        : Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: !canSelect ? Colors.grey[100] : null,
                ),
                child: ListTile(
                  enabled: canSelect,
                  onTap: () => canSelect
                      ? _onItemClicked(propertyName, attribute)
                      : null,
                  leading: attribute.MiniImageUrl != null &&
                          attribute.MiniImageUrl!.isNotEmpty
                      ? Image.network(
                          attribute.MiniImageUrl!,
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 50);
                          },
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[200],
                          child: Center(
                            child: Text(
                              attribute.OriginalValue.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                  title: Text(
                    attribute.OriginalValue.toString(),
                    style: TextStyle(
                      color: canSelect ? Colors.black : Colors.grey,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: canSelect ? null : Colors.grey,
                        ),
                        onPressed: canSelect
                            ? () => _updateQuantity(attribute.Vid, false)
                            : null,
                      ),
                      SizedBox(
                          width: 50,
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              enabled: canSelect,
                              controller: TextEditingController(
                                  text: quantity.toString()),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  int newQuantity = int.parse(value);
                                  _updateQuantityDirectly(
                                      attribute.Vid, newQuantity);
                                }
                              },
                              style: TextStyle(
                                color: canSelect ? Colors.black : Colors.grey,
                              ),
                            ),
                          )),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: canSelect ? null : Colors.grey,
                        ),
                        onPressed: canSelect
                            ? () => _updateQuantity(attribute.Vid, true)
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Display selected combinations
          if (selectedCombinations.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future:
                        TranslationService.translate("Selected Combinations:"),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? "Selected Combinations:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 8),
                  ...selectedCombinations.map((combo) {
                    return Card(
                      child: ListTile(
                        title: Text(combo.displayText),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FutureBuilder(
                              future: TranslationService.translate(
                                  "Quantity: ${combo.quantity}"),
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.data ??
                                      "Quantity: ${combo.quantity}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  selectedCombinations.remove(combo);
                                  String key = _getCombinationKeyFromAttributes(
                                      combo.attributes);
                                  combinationQuantities.remove(key);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                  //   child: FutureBuilder(
                  //     future: TranslationService.translate(
                  //         "Total Quantity: $totalQuantity (Minimum Order: ${widget.myPriceRange[0].minOr})"),
                  //     builder: (context, snapshot) {
                  //       return Text(
                  //         snapshot.data ??
                  //             "Total Quantity: $totalQuantity (Minimum Order: ${widget.myPriceRange[0].minOr})",
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           color: _isMinOrderMet() ? Colors.green : Colors.red,
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
        ],
      );
    }

    // Original grid view for non-last attributes
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            propertyName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: items.length > 4 && items.length <= 8
              ? 150
              : items.length <= 4
                  ? 80
                  : 225,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final attribute = items[index];
              bool isSelected = selectedAttributes[propertyName] == attribute;

              return GestureDetector(
                onTap: () => _onItemClicked(propertyName, attribute),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.colorPrimaryDark.withOpacity(0.4)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? Border.all(color: AppColors.colorPrimaryDark)
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: attribute.MiniImageUrl != null &&
                            attribute.MiniImageUrl!.isNotEmpty
                        ? Image.network(
                            attribute.MiniImageUrl!,
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 50);
                            },
                          )
                        : Container(
                            width: 50,
                            height: _calculateHeight(
                                attribute.OriginalValue.toString()),
                            color: Colors.grey[200],
                            child: Center(
                              child: Text(
                                attribute.OriginalValue.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if attributes are empty
    if (widget.myProdAttr.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: FutureBuilder(
            future: TranslationService.translate("Order Quantity"),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? "Order Quantity",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              );
            },
          ),
          actions: const [
            CartWidget(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: myKey,
                child: TextFormField(
                  controller: simpleQuantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: "Enter Quantity",
                    border: OutlineInputBorder(),
                    helperText:
                        "Minimum Order: ${widget.myPriceRange[0].minOr}",
                  ),
                  validator: (value) => _validateQuantity(value!),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorPrimaryDark,
                  minimumSize: Size(double.infinity, 48),
                ),
                onPressed: () {
                  if (myKey.currentState!.validate()) {
                    int quantity = int.parse(simpleQuantityController.text);
                    if (quantity >= int.parse(widget.myPriceRange[0].minOr)) {
                      // Find applicable price range with proper error handling
                      Prices applicablePrice;
                      try {
                        applicablePrice = widget.myPriceRange.firstWhere(
                          (price) {
                            final int minQuantity = int.parse(price.minOr);
                            final int? maxQuantity = price.maxOr != null
                                ? int.parse(price.maxOr!)
                                : null;
                            return quantity >= minQuantity &&
                                (maxQuantity == null ||
                                    quantity <= maxQuantity);
                          },
                          orElse: () => widget.myPriceRange[
                              0], // Default to first price range if no match
                        );
                      } catch (e) {
                        // Fallback to first price range if any error occurs
                        applicablePrice = widget.myPriceRange[0];
                      }

                      // Create cart item
                      myCart.add(CartItem(
                        baseMarkup: applicablePrice.baseMarkup.toString(),
                        currency: widget.currentCountry == "ETB" ? "ETB" : "\$",
                        description: "provider",
                        subProductId: "0",
                        name: widget.productName.toString(),
                        price: applicablePrice.originalPrice.toString(),
                        image: widget.imageUrl.toString(),
                        productId: widget.productId.toString(),
                        quantity: quantity,
                        createdAt: DateTime.now().toIso8601String(),
                      ));

                      // // Add to cart
                      _addToCart();
                    } else {
                      displaySnack(context, "Minimum order quantity not met");
                    }
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart, color: AppColors.bg1),
                    SizedBox(width: 8),
                    FutureBuilder(
                      future: TranslationService.translate("Add to Cart"),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ?? "Add to Cart",
                          style: TextStyle(color: AppColors.bg1),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Return original widget if attributes are not empty
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: FutureBuilder(
            future: TranslationService.translate(
                "Total Quantity: $totalQuantity (Minimum Order: ${widget.myPriceRange[0].minOr})"),
            builder: (context, snapshot) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _isMinOrderMet()
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  snapshot.data ??
                      "Total Quantity: $totalQuantity (Minimum Order: ${widget.myPriceRange[0].minOr})",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isMinOrderMet() ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: groupedAttributes.keys.length,
          itemBuilder: (context, index) {
            final propertyName = groupedAttributes.keys.elementAt(index);
            final items = groupedAttributes[propertyName]!;
            return _buildAttributeGrid(propertyName, items);
          },
        ),
        SizedBox(height: 10),
        if (_areAllGroupsSelected())
          Column(
            children: [
              Container(
                  color: Colors.amber[300],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder(
                      future: TranslationService.translate(
                          "Minimum Order: ${widget.myPriceRange[0].minOr}"),
                      builder: (context, snapshot) {
                        return Text(snapshot.data ??
                            "Minimum Order: ${widget.myPriceRange[0].minOr}");
                      },
                    ),
                  )),
            ],
          ),
        if (myCart.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: TranslationService.translate("Selected Attributes:"),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data ?? "Selected Attributes:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ...myCart.map((entry) {
                  final attribute = widget.myConfig
                      .firstWhere((attr) => attr.id == entry.subProductId);

                  return ListTile(
                    title: Text(
                      "${attribute.vid}",
                    ),
                    subtitle: FutureBuilder(
                      future: TranslationService.translate(
                          "Quantity: ${entry.quantity}"),
                      builder: (context, snapshot) {
                        return Text(
                            snapshot.data ?? "Quantity: ${entry.quantity}");
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeAttribute(entry),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.colorPrimaryDark),
            onPressed: _isMinOrderMet() ? _addToCartItems : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: AppColors.bg1,
                ),
                SizedBox(width: 8),
                FutureBuilder(
                  future: TranslationService.translate("Add to Cart"),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data ?? "Add to Cart",
                      style: TextStyle(color: AppColors.bg1),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _calculateHeight(String text) {
    const double baseHeight = 20.0; // Base height for a single line of text
    const double heightPerChar =
        2.5; // Height factor per character (tune as needed)

    // Calculate height
    return baseHeight + (text.length * heightPerChar);
  }

  bool isAndroid() {
    return Platform.isAndroid;
  }

  void _removeAttribute(CartItem item) {
    setState(() {
      // Remove from quantities
      myCart.remove(item);

      // Find the property name and reset its selection
      // for (var group in groupedAttributes.entries) {
      //   if (group.value.any((attr) => attr.Vid == vid)) {
      //     selectedAttributes[group.key] = null;
      //     break;
      //   }
      // }
    });
  }

  bool _canSelectLastAttribute() {
    for (var propertyName in groupedAttributes.keys) {
      if (propertyName == groupedAttributes.keys.last) continue;
      if (selectedAttributes[propertyName] == null) return false;
    }
    return true;
  }

  void _updateQuantity(String vid, bool increase) {
    if (_canSelectLastAttribute()) {
      // Create a map of current selected attributes
      Map<String, ProductAttributes> currentAttributes = {};
      selectedAttributes.forEach((key, value) {
        if (value != null) {
          currentAttributes[key] = value;
        }
      });

      // Add the last attribute based on the vid
      final lastPropertyName = groupedAttributes.keys.last;
      final lastAttribute = groupedAttributes[lastPropertyName]!
          .firstWhere((attr) => attr.Vid == vid);
      currentAttributes[lastPropertyName] = lastAttribute;

      // Generate combination key from current attributes
      String combinationKey =
          currentAttributes.values.map((attr) => attr.Vid).join('_');

      setState(() {
        // Get current quantity from combinationQuantities
        int currentValue = combinationQuantities[combinationKey] ?? 0;

        // Update quantity
        if (increase) {
          currentValue++;
        } else if (currentValue > 0) {
          currentValue--;
        }

        // Update the quantity in combinationQuantities
        combinationQuantities[combinationKey] = currentValue;

        // Find existing combination index
        int existingIndex = selectedCombinations.indexWhere((combo) =>
            _compareCombinations(combo.attributes, currentAttributes));

        if (currentValue > 0) {
          // Create new combination with current attributes
          AttributeCombination newCombo = AttributeCombination(
            attributes: Map.from(currentAttributes),
            quantity: currentValue,
          );

          // Update or add the combination
          if (existingIndex != -1) {
            selectedCombinations[existingIndex] = newCombo;
          } else {
            selectedCombinations.add(newCombo);
          }
        } else {
          // Remove only this specific combination if quantity is 0
          if (existingIndex != -1) {
            selectedCombinations.removeAt(existingIndex);
          }
          combinationQuantities.remove(combinationKey);
        }
      });
    }
  }

  String _getCombinationKey() {
    return selectedAttributes.values
        .where((attr) => attr != null)
        .map((attr) => attr!.Vid)
        .join('_');
  }

  bool _isMinOrderMet() {
    return totalQuantity >= int.parse(widget.myPriceRange[0].minOr);
  }

  String _getCombinationKeyFromAttributes(
      Map<String, ProductAttributes> attrs) {
    return attrs.values
        .where((attr) => attr != null)
        .map((attr) => attr!.Vid)
        .join('_');
  }

  // Add a method to check if a combination already exists
  bool _combinationExists(String combinationKey) {
    return selectedCombinations.any((combo) =>
        _getCombinationKeyFromAttributes(combo.attributes) == combinationKey);
  }

  // Optional: Add sorting to keep the combinations list organized
  void _sortCombinations() {
    selectedCombinations.sort((a, b) {
      // Sort by first attribute, then second attribute
      var aAttrs = a.attributes.values.toList();
      var bAttrs = b.attributes.values.toList();

      for (int i = 0; i < aAttrs.length; i++) {
        int compare =
            aAttrs[i].OriginalValue.compareTo(bAttrs[i].OriginalValue);
        if (compare != 0) return compare;
      }
      return 0;
    });
  }

  // Add this helper method to compare combinations
  bool _compareCombinations(Map<String, ProductAttributes> combo1,
      Map<String, ProductAttributes> combo2) {
    if (combo1.length != combo2.length) return false;

    for (var key in combo1.keys) {
      if (!combo2.containsKey(key) || combo1[key]!.Vid != combo2[key]!.Vid) {
        return false;
      }
    }

    return true;
  }

  void _updateQuantityDirectly(String vid, int newQuantity) {
    if (_canSelectLastAttribute()) {
      Map<String, ProductAttributes> currentAttributes = {};
      selectedAttributes.forEach((key, value) {
        if (value != null) {
          currentAttributes[key] = value;
        }
      });

      final lastPropertyName = groupedAttributes.keys.last;
      final lastAttribute = groupedAttributes[lastPropertyName]!
          .firstWhere((attr) => attr.Vid == vid);
      currentAttributes[lastPropertyName] = lastAttribute;

      String combinationKey =
          currentAttributes.values.map((attr) => attr.Vid).join('_');

      setState(() {
        combinationQuantities[combinationKey] = newQuantity;

        int existingIndex = selectedCombinations.indexWhere((combo) =>
            _compareCombinations(combo.attributes, currentAttributes));

        if (newQuantity > 0) {
          AttributeCombination newCombo = AttributeCombination(
            attributes: Map.from(currentAttributes),
            quantity: newQuantity,
          );

          if (existingIndex != -1) {
            selectedCombinations[existingIndex] = newCombo;
          } else {
            selectedCombinations.add(newCombo);
          }
        } else {
          if (existingIndex != -1) {
            selectedCombinations.removeAt(existingIndex);
          }
          combinationQuantities.remove(combinationKey);
        }
      });
    }
  }

  double calculateTotalPrice(
      double itemPrice, double baseMarkup, int quantity) {
    double totalPrice = 0; // Initialize total price to 0

    for (int itemIndex = 1; itemIndex <= quantity; itemIndex++) {
      if (itemIndex == 1) {
        totalPrice +=
            itemPrice + baseMarkup; // For the first item, price + full markup
      } else if (itemIndex == 2) {
        // For subsequent items, price + half markup (rounded to 2 decimal places)
        double halfMarkup = baseMarkup * 0.2;
        totalPrice += itemPrice + baseMarkup - halfMarkup;
      } else if (itemIndex == 3) {
        double halfMarkup = baseMarkup * 0.35;
        totalPrice += itemPrice + baseMarkup - halfMarkup;
      } else if (itemIndex == 4) {
        double halfMarkup = baseMarkup * 0.4;
        totalPrice += itemPrice + baseMarkup - halfMarkup;
      } else if (itemIndex == 5) {
        double halfMarkup = baseMarkup * 0.45;
        totalPrice += itemPrice + baseMarkup - halfMarkup;
      } else if (itemIndex >= 6) {
        double halfMarkup = baseMarkup * 0.5;
        totalPrice += itemPrice + baseMarkup - halfMarkup;
      }
    }
    print("totalPrice: $totalPrice");
    // Round to 2 decimal places
    return double.parse((totalPrice).toStringAsFixed(2));
  }
}
