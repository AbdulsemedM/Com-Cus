import 'package:commercepal/core/cart-core/cart_widget.dart';
import 'package:commercepal/features/merchants/merchants_page.dart';
import 'package:commercepal/features/products/presentation/products_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/utils/app_colors.dart';

class HomeSearchFieldWidget extends StatefulWidget {
  const HomeSearchFieldWidget({Key? key}) : super(key: key);

  @override
  _HomeSearchFieldWidgetState createState() => _HomeSearchFieldWidgetState();
}

class _HomeSearchFieldWidgetState extends State<HomeSearchFieldWidget> {
  String? _searchType; // Variable to store selected search type

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Row(
        children: [
          Expanded(
            flex: 2, // Adjust this value to make the DropdownButton narrower
            child: DropdownButton<String>(
              value: _searchType,
              items: <String>['Product', 'Merchant'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _searchType = newValue;
                });
              },
              hint: const Text('search'),
            ),
          ),
          const SizedBox(
            width: 14,
          ),
          Expanded(
            flex: 4, // Adjust this value to make the TextField wider
            child: GestureDetector(
              onTap: () {
                if (_searchType == "Product") {
                  Navigator.pushNamed(context, ProductsPage.routeName,
                      arguments: {
                        "search": true,
                        // "searchType": _searchType,
                      });
                } else if (_searchType == "Merchant") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MerchantSearchPage(),
                    ),
                  );
                } else {
                  // Show a message if no search type is selected
                  Navigator.pushNamed(context, ProductsPage.routeName,
                      arguments: {
                        "search": true,
                        // "searchType": _searchType,
                      });
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //     content: Text('Please select a search type first'),
                  //   ),
                  // );
                }
              },
              child: TextField(
                decoration: InputDecoration(
                  enabled: false,
                  hintStyle: TextStyle(
                    color: AppColors.secondaryTextColor,
                    fontSize: 14.sp,
                  ),
                  focusedBorder: _buildOutlineInputBorder(),
                  disabledBorder: _buildOutlineInputBorder(),
                  enabledBorder: _buildOutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.iconColor,
                  ),
                  hintText: "Type something e.g., watch",
                ),
              ),
            ),
          ),
          const CartWidget(),
        ],
      ),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.fieldBorder, width: 2),
    );
  }
}
