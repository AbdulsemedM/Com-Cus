import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/features/translation/translation_api.dart';
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
                    FutureBuilder(
                      future: TranslationService.translate(
                          '${widget.currentCountryForm == "ETB" ? "ETB" : "\$"}  ${priceItem.originalPrice}'),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ??
                              '${widget.currentCountryForm == "ETB" ? "ETB" : "\$"}  ${priceItem.originalPrice}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        );
                      },
                    ),
                    FutureBuilder(
                      future: TranslationService.translate(index == 0
                          ? 'Min Order: ${priceItem.minOr} pieces'
                          : index != 0 && priceItem.maxOr != null
                              ? '${priceItem.minOr} - ${priceItem.maxOr} pieces'
                              : index == widget.price.length - 1
                                  ? '> ${priceItem.minOr} pieces'
                                  : ""),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ??
                              (index == 0
                                  ? 'Min Order: ${priceItem.minOr} pieces'
                                  : index != 0 && priceItem.maxOr != null
                                      ? '${priceItem.minOr} - ${priceItem.maxOr} pieces'
                                      : index == widget.price.length - 1
                                          ? '> ${priceItem.minOr} pieces'
                                          : ""),
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        );
                      },
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
  final double baseMarkup;
  final String originalPrice;
  final String minOr;
  final String? maxOr;

  Prices(
      {required this.baseMarkup,
      required this.originalPrice,
      required this.minOr,
      this.maxOr});
}
