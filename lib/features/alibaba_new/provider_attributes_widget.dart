import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/cart-core/bloc/cart_core_cubit.dart';
import 'package:commercepal/core/cart-core/domain/cart_item.dart';
import 'package:commercepal/features/alibaba_new/provider_config_model.dart';
import 'package:commercepal/features/alibaba_product_view/alibaba_products_screen.dart';
import 'package:commercepal/features/alibaba_product_view/minOrder_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late TextEditingController quantityController;
  String? errorText;
  GlobalKey<FormState> myKey = GlobalKey<FormState>();
  List<CartItem> myCart = [];

  @override
  void initState() {
    super.initState();
    // Grouping the attributes by PropertyName
    groupedAttributes = _groupAttributesByPropertyName(widget.myProdAttr);
    // Initialize selected attributes with null (no selection initially)
    selectedAttributes = {
      for (var group in groupedAttributes.keys) group: null,
    };
    quantityController = TextEditingController();
    quantityController.text = widget.myPriceRange[0].minOr;
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  void _validateQuantityInput(String value) {
    final minOrder = widget.myPriceRange[0].minOr;
    final quantity = int.tryParse(value);
    setState(() {
      if (quantity == null || quantity < double.parse(minOrder)) {
        errorText = "Quantity must be at least $minOrder";
      } else {
        errorText = null;
      }
    });
  }

  void _addToCartItems() {
    if (myKey.currentState!.validate()) {
      final selectedVids = selectedAttributes.values
          .where((attribute) => attribute != null)
          .map((attribute) => attribute!.Vid)
          .join(", ");
      final List<String> selectedVidList =
          selectedVids.split(", ").map((vid) => vid.trim()).toList();
      print(selectedVidList);

      var myTheconfig;
      if (widget.myConfig.isNotEmpty) {
        final ProviderConfigModel theConfig =
            widget.myConfig.firstWhere((config) {
          // Check if all selectedVidList values exist in the config's vid list
          return selectedVidList
              .every((selectedVid) => config.vid.contains(selectedVid));
        });
        print("theConfig.id");
        myTheconfig = theConfig;
      }
      final int quantity = int.tryParse(quantityController.text) ?? 0;

// Find the applicable price based on the quantity range
      final Prices? applicablePrice = widget.myPriceRange.firstWhere(
        (price) {
          final int minQuantity = int.parse(price.minOr);
          final int? maxQuantity =
              price.maxOr != null ? int.parse(price.maxOr!) : null;

          // Check if quantity falls within this price range
          return quantity >= minQuantity &&
              (maxQuantity == null || quantity <= maxQuantity);
        },
        orElse: () => widget
            .myPriceRange.first, // Return the first if no price range matches
      );
      if (applicablePrice != null) {
        final double unitPrice = double.parse(applicablePrice.price);
        final double totalPrice = unitPrice * quantity;

        print("Total Price: $totalPrice");
        setState(() {
          myCart.add(CartItem(
            currency: widget.currentCountry == "ETB" ? "ETB" : "\$",
            description: "provider",
            subProductId: myTheconfig == null ? "0" : myTheconfig.id,
            name: widget.productName.toString(),
            price: totalPrice.toString(),
            image: widget.imageUrl.toString(),
            productId: widget.productId.toString(),
            // id: id, // Use validated and parsed ID
            quantity: int.parse(
                quantityController.text), // Use validated and parsed count
          ));
        });
      }
    }
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
      // Toggle the selection: If the clicked attribute is already selected, unselect it; else, select it
      if (selectedAttributes[propertyName] == attribute) {
        selectedAttributes[propertyName] = null;
      } else {
        selectedAttributes[propertyName] = attribute;
      }
    });
  }

  bool _areAllGroupsSelected() {
    // Check if all groups have a selected attribute
    return selectedAttributes.values.every((selection) => selection != null);
  }

  bool _isMinOrderValid() {
    int totalQuantity = 0;
    for (var item in myCart) {
      totalQuantity += item.quantity!;
    }
    return int.parse(widget.myPriceRange[0].minOr) <= totalQuantity;
  }

  void _showSelectedVids() {
    for (var item in myCart) {
      context.read<CartCoreCubit>().addCartItem(item);
    }
    displaySnack(context, "Product added to cart successfully");
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

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // Main content with the attribute grid
          ListView.builder(
            shrinkWrap: true, // Ensures proper scrolling inside ListView
            physics:
                NeverScrollableScrollPhysics(), // Avoid nested scroll issues
            itemCount: groupedAttributes.keys.length,
            itemBuilder: (context, index) {
              final propertyName = groupedAttributes.keys.elementAt(index);
              final items = groupedAttributes[propertyName]!;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Column(
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, childAspectRatio: 1),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final attribute = items[index];
                          bool isSelected =
                              selectedAttributes[propertyName] == attribute;

                          return Padding(
                            padding: const EdgeInsets.all(0),
                            child: GestureDetector(
                              onTap: () =>
                                  _onItemClicked(propertyName, attribute),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.colorPrimaryDark
                                              .withOpacity(0.4)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: attribute.MiniImageUrl != null &&
                                                attribute
                                                    .MiniImageUrl!.isNotEmpty
                                            ? Image.network(
                                                attribute.MiniImageUrl!,
                                                width: 50,
                                                height: 50,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Icon(
                                                      Icons.broken_image,
                                                      size: 50);
                                                },
                                              )
                                            : Container(
                                                width: 50,
                                                height: _calculateHeight(
                                                    attribute.OriginalValue
                                                        .toString()),
                                                color: Colors.grey[200],
                                                child: Center(
                                                  child: Text(
                                                    attribute.OriginalValue
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              )),
                                  ),
                                  const SizedBox(height: 8),
                                  attribute.MiniImageUrl != null &&
                                          attribute.MiniImageUrl!.isNotEmpty
                                      ? Text(
                                          attribute.Vid,
                                          style: const TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
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
                      child:
                          Text("Min. Order: ${widget.myPriceRange[0].minOr}"),
                    )),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: myKey,
                          child: TextFormField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              labelText: "Enter Quantity",
                              // errorText: errorText,
                              border: OutlineInputBorder(),
                            ),
                            // onChanged: _validateQuantityInput,
                            validator: (value) => _validateQuantity(value!),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              // color: AppColors.colorAccent,
                              border: Border.all(color: AppColors.colorAccent),
                              borderRadius: BorderRadius.circular(30)),
                          child: IconButton(
                            // highlightColor: AppColors.colorAccent,
                            color: AppColors.colorAccent,
                            onPressed: () {
                              _addToCartItems();
                              print(myCart.length);
                            },
                            icon: Container(
                              decoration: BoxDecoration(
                                color: AppColors
                                    .colorAccent, // Change to your desired color
                                shape: BoxShape
                                    .circle, // Optional: make it circular
                              ),
                              padding: const EdgeInsets.all(
                                  8.0), // Adjust padding as needed
                              child: Icon(Icons.add,
                                  color: Colors
                                      .white), // Adjust icon color for contrast
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          // Display Selected Attributes and Quantities
          if (myCart.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Selected Attributes:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...myCart.map((entry) {
                    // Find the attribute using Vid
                    final attribute = widget.myConfig
                        // .expand((group) => group)
                        .firstWhere((attr) => attr.id == entry.subProductId);

                    return ListTile(
                      title: Text(
                        "${attribute.vid}",
                      ),
                      subtitle: Text("Quantity: ${entry.quantity}"),
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
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorPrimaryDark),
              onPressed: _isMinOrderValid() ? _showSelectedVids : null,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: AppColors.bg1,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Add to Cart",
                    style: TextStyle(color: AppColors.bg1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateHeight(String text) {
    const double baseHeight = 20.0; // Base height for a single line of text
    const double heightPerChar =
        2.5; // Height factor per character (tune as needed)

    // Calculate height
    return baseHeight + (text.length * heightPerChar);
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
}
