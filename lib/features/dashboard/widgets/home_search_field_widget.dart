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
    return GestureDetector(
      onTap: () async {
        if (_searchType == null) {
          // Ask user to select search type if not already selected
          await _showSearchTypeDialog(context);
        } else {
          // Navigate to search page with selected search type
          Navigator.pushNamed(context, ProductsPage.routeName, arguments: {
            "search": true,
            "searchType": _searchType,
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  enabled: false,
                  hintStyle: TextStyle(
                      color: AppColors.secondaryTextColor, fontSize: 14.sp),
                  focusedBorder: _buildOutlineInputBorder(),
                  disabledBorder: _buildOutlineInputBorder(),
                  enabledBorder: _buildOutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.iconColor,
                  ),
                  hintText: "Type something eg watch",
                ),
              ),
            ),
            const SizedBox(
              width: 14,
            ),
            const CartWidget(),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.fieldBorder, width: 2));
  }

  Future<void> _showSearchTypeDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Search Type'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                DropdownButton<String>(
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
                    Navigator.of(context).pop();
                    if (_searchType == "Product") {
                      _searchType = null;
                      Navigator.pushNamed(context, ProductsPage.routeName,
                          arguments: {
                            "search": true,
                          });
                    }
                    if (_searchType == "Merchant") {
                      _searchType = null;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MerchantSearchPage()));
                    }
                  },
                  hint: const Text('Select search type'),
                ),
              ],
            ),
          ),
          // actions: <Widget>[
          //   TextButton(
          //     child: const Text('OK'),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //       if (_searchType == "Product") {
          //         _searchType = null;
          //         Navigator.pushNamed(context, ProductsPage.routeName,
          //             arguments: {
          //               "search": true,
          //             });
          //       }
          //     },
          //   ),
          // ],
        );
      },
    );
  }
}
