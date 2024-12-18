import 'package:commercepal/app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MinOrderPricePage extends StatefulWidget {
  final List<Prices> price;
  final String currentCountryForm;
  const MinOrderPricePage(
      {super.key, required this.price, required this.currentCountryForm});

  @override
  State<MinOrderPricePage> createState() => _MinOrderPricePageState();
}

class _MinOrderPricePageState extends State<MinOrderPricePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.colorPrimaryDark,
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.width * 0.2,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            widget.price.length,
            (index) {
              final priceItem = widget.price[index];
              // print(priceItem.minOr);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.currentCountryForm == "ETB" ? "ETB" : "\$"}  ${priceItem.price}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      index == 0
                          ? 'Min Order: ${priceItem.minOr} pieces'
                          : index != 0 && priceItem.maxOr != null
                              ? '${priceItem.minOr} - ${priceItem.maxOr} pieces'
                              : index == widget.price.length - 1
                                  ? '> ${priceItem.minOr} pieces'
                                  : "",
                      style: TextStyle(color: Colors.white, fontSize: 8),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Prices {
  final String price;
  final String minOr;
  final String? maxOr;

  Prices({required this.price, required this.minOr, this.maxOr});
}
