import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercepal/features/alibaba_product_view/alibaba_products_screen.dart';
import 'package:commercepal/features/alibaba_product_view/attributes_list_view.dart';
import 'package:commercepal/features/alibaba_product_view/minOrder_price.dart';
import 'package:flutter/material.dart';

class AttributeModalScreen extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onProceed; // Add callback
  final List<ProductAttributes> myAttributes;
  final List<Prices> myPrices;
  final List<ConfiguratorInfo> myConfig;

  const AttributeModalScreen(
      {super.key,
      required this.myAttributes,
      required this.myPrices,
      required this.myConfig,
      required this.onProceed});
  @override
  _AttributeModalScreenState createState() => _AttributeModalScreenState();
}

class _AttributeModalScreenState extends State<AttributeModalScreen> {
  @override
  void initState() {
    super.initState();
    myListItem = createListItems(widget.myAttributes, widget.myConfig);
  }

  List<ListItem> myListItem = [];
  List<ListItem> createListItems(
      List<ProductAttributes> myAttributes, List<ConfiguratorInfo> myConfig) {
    return myAttributes.map((attribute) {
      // Find matching ConfiguratorInfo by Vid
      final matchingConfig = myConfig.firstWhere(
        (config) => config.vid == attribute.Vid,
        orElse: () => ConfiguratorInfo(id: '', vid: '', originalPrice: 0.0),
      );

      // Create ListItem using values from attribute and matchingConfig
      return ListItem(
        id: matchingConfig.id,
        imageUrl: attribute.ImageUrl,
        title: attribute.Vid,
        price: matchingConfig.originalPrice,
        name: attribute.OriginalValue
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                title: Text("Product Attributes"),
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFC4C4C4).withOpacity(0.4),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        child: CachedNetworkImage(
                          width: 80,
                          height: 80,
                          placeholder: (_, __) => Container(
                            color: Colors.grey,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: Colors.grey,
                          ),
                          imageUrl: widget.myAttributes[0].MiniImageUrl,
                        ),
                      ),
                    ),
                    MinOrderPricePage(
                      price: widget.myPrices,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      "Attributes  (${widget.myAttributes.length})",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  thickness: 4,
                ),
              ),
              AttributesListItem(
                items: myListItem,
                onProceed: handleProceed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleProceed(List<Map<String, dynamic>> selectedItems) {
    widget.onProceed(selectedItems);
    Navigator.of(context).pop();
  }
}

class ConfiguratorInfo {
  final String id;
  final String vid;
  final String? name;
  final double originalPrice;

  ConfiguratorInfo({
    required this.id,
    required this.vid,
    this.name,
    required this.originalPrice,
  });

  // Factory constructor to create an instance from JSON
  factory ConfiguratorInfo.fromJson(Map<String, dynamic> json) {
    return ConfiguratorInfo(
      id: json['Id'] as String,
      vid: json['Configurators'][0]['Vid'] as String,
      originalPrice: json['Price']['OriginalPrice'] as double,
    );
  }
}

// Function to parse JSON data into a list of ConfiguratorInfo objects
List<ConfiguratorInfo> parseConfiguratorInfoList(List<dynamic> jsonList) {
  return jsonList.map((json) => ConfiguratorInfo.fromJson(json)).toList();
}
