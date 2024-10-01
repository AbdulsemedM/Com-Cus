import 'package:commercepal/core/cart-core/cart_widget.dart';
import 'package:commercepal/features/merchants/merchants_page.dart';
import 'package:commercepal/features/products/presentation/products_page.dart';
import 'package:commercepal/features/translation/translation_api.dart';
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
  List<DropdownMenuItem<String>> _dropdownItems = [];
  bool _isLoading = true;
  String _hintText = '...'; // Initial loading state
  @override
  void initState() {
    super.initState();
    _loadTranslations();
  }

  Future<void> _loadTranslations() async {
    List<String> items = ['Product', 'Merchant'];

    // Fetch the translations asynchronously
    List<DropdownMenuItem<String>> translatedItems = [];
    for (String item in items) {
      String translatedText = await TranslationService.translate(item);
      translatedItems.add(
        DropdownMenuItem<String>(
          value: item,
          child: Text(translatedText), // Use translated text
        ),
      );
    }

    // Update the state with the translated items
    setState(() {
      _dropdownItems = translatedItems;
      _isLoading = false;
    });
    String translatedHint =
        await TranslationService.translate("Type something e.g., watch");
    setState(() {
      _hintText =
          translatedHint; // Update the hint text once translation is loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Row(
        children: [
          Expanded(
            flex: 2, // Adjust this value to make the DropdownButton narrower
            child: _isLoading
                ? const SizedBox(
                    width:
                        10) // Show a loader while translations are being fetched
                : DropdownButton<String>(
                    value: _searchType,
                    items: _dropdownItems, // Use translated dropdown items
                    onChanged: (String? newValue) {
                      setState(() {
                        _searchType = newValue;
                      });
                    },
                    hint: FutureBuilder<String>(
                      future: TranslationService.translate(
                          "Search"), // Translate hint
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                              "..."); // Show loading indicator for hint
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}'); // Show error for hint
                        } else {
                          return Text(snapshot.data ??
                              'Search'); // Display translated hint
                        }
                      },
                    ),
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
                    hintText: _hintText),
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
