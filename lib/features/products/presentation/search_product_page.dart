import 'package:commercepal/features/products/presentation/widgets/products_page_data.dart';
import 'package:flutter/material.dart';

class SearchProductPage extends StatefulWidget {
  final String? val;
  const SearchProductPage({Key? key, this.val}) : super(key: key);

  @override
  State<SearchProductPage> createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  @override
  Widget build(BuildContext context) {
    return ProductsStatePage(val: widget.val,);
  }
}
