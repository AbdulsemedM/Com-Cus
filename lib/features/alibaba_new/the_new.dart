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
  late Map<String, int> attributeQuantities;
  String? errorText;
  GlobalKey<FormState> myKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    groupedAttributes = _groupAttributesByPropertyName(widget.myProdAttr);
    selectedAttributes = {
      for (var group in groupedAttributes.keys) group: null
    };
    attributeQuantities = {};
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
      selectedAttributes[propertyName] = attribute;
    });

    if (_areAllGroupsSelected()) {
      _showQuantityDialog();
    }
  }

  bool _areAllGroupsSelected() {
    return selectedAttributes.values.every((selection) => selection != null);
  }

  void _showQuantityDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text("Enter Total Quantity"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: "Quantity"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final quantity = int.tryParse(controller.text);
                if (quantity != null) {
                  setState(() {
                    for (var attribute in selectedAttributes.values) {
                      if (attribute != null) {
                        attributeQuantities[attribute.Vid] = quantity;
                      }
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  bool _isMinOrderValid() {
    final totalQuantity =
        attributeQuantities.values.fold<int>(0, (sum, value) => sum + value);
    return totalQuantity >= int.parse(widget.myPriceRange[0].minOr);
  }

  void _removeAttribute(String propertyName) {
    setState(() {
      selectedAttributes[propertyName] = null;
      attributeQuantities.removeWhere((key, value) =>
          groupedAttributes[propertyName]!
              .any((attribute) => attribute.Vid == key));
    });
  }

  void _addToCart() {
    if (!_isMinOrderValid()) {
      displaySnack(context,
          "Total quantity must be at least ${widget.myPriceRange[0].minOr}");
      return;
    }

    // Prepare the cart items
    final cartItems = selectedAttributes.entries
        .map((entry) {
          final propertyName = entry.key;
          final attribute = entry.value;
          if (attribute == null) return null;
          final quantity = attributeQuantities[attribute.Vid] ?? 0;
          final unitPrice = double.parse(widget.myPriceRange[0].price);
          final totalPrice = quantity * unitPrice;

          return CartItem(
            currency: widget.currentCountry == "ETB" ? "ETB" : "\$",
            description: "$propertyName: ${attribute.OriginalValue}",
            subProductId: attribute.Vid,
            name: widget.productName,
            price: totalPrice.toString(),
            image: widget.imageUrl,
            productId: widget.productId,
            quantity: quantity,
          );
        })
        .whereType<CartItem>()
        .toList();

    // Add items to cart
    for (final item in cartItems) {
      context.read<CartCoreCubit>().addCartItem(item);
    }

    displaySnack(context, "Products added to cart successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // Attributes Grid
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: groupedAttributes.keys.length,
            itemBuilder: (context, index) {
              final propertyName = groupedAttributes.keys.elementAt(index);
              final items = groupedAttributes[propertyName]!;

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
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, childAspectRatio: 1),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final attribute = items[index];
                      final isSelected =
                          selectedAttributes[propertyName] == attribute;

                      return GestureDetector(
                        onTap: () {
                          _onItemClicked(propertyName, attribute);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.colorPrimaryDark.withOpacity(0.4)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              attribute.OriginalValue,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          // Display Selected Attributes and Quantities
          if (attributeQuantities.isNotEmpty)
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
                  ...attributeQuantities.entries.map((entry) {
                    final attribute = groupedAttributes.values
                        .expand((group) => group)
                        .firstWhere((attr) => attr.Vid == entry.key);
                    return ListTile(
                      title: Text(
                          "${attribute.PropertyName}: ${attribute.OriginalValue}"),
                      subtitle: Text("Quantity: ${entry.value}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            _removeAttribute(attribute.PropertyName),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          if (attributeQuantities.isNotEmpty)
            ElevatedButton(
              onPressed: _addToCart,
              child: const Text("Add to Cart"),
            ),
        ],
      ),
    );
  }
}
