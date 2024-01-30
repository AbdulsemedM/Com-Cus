import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/utils/app_colors.dart';

class ProductPriceWidget extends StatefulWidget {
  final bool displayVoucher;
  final String? title;
  final String? subTitle;
  final String? totalPrice;
  final String? buttonText;
  final VoidCallback? onClick;
  final double? padding;

  const ProductPriceWidget({
    Key? key,
    this.displayVoucher = false,
    this.subTitle,
    this.totalPrice,
    this.buttonText,
    this.onClick,
    this.padding,
    this.title,
  }) : super(key: key);
  @override
  _ProductPriceWidgetState createState() => _ProductPriceWidgetState();
}

class _ProductPriceWidgetState extends State<ProductPriceWidget> {
  var loading = false;
  @override
  void initState() {
    super.initState();
    fetchHints();
  }

  void fetchHints() async {
    setState(() {
      loading = true;
    });

    totalPrice = Translations.translatedText(
        widget.title ?? 'Total: ', GlobalStrings.getGlobalString());
    subTitle = Translations.translatedText(
        widget.subTitle ?? '', GlobalStrings.getGlobalString());
    butText = Translations.translatedText(
        widget.buttonText ?? "Checkout", GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    tPrice = await totalPrice;
    sTit = await subTitle;
    bText = await butText;
    print("herrerererere");
    print(tPrice);
    print(sTit);

    setState(() {
      loading = false;
    });
  }

  var totalPrice;
  var subTitle;
  var butText;
  String tPrice = '';
  String sTit = '';
  String bText = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.priceBg, // Replace with appropriate color
      padding: EdgeInsets.symmetric(vertical: widget.padding ?? 6),
      width: double.infinity,
      child: Column(
        children: [
          if (widget.displayVoucher) _buildVoucherField(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    loading
                        ? CircularProgressIndicator()
                        : RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: tPrice,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 18.sp,
                                      color: AppColors.secondaryTextColor
                                          .withOpacity(0.8),
                                    ),
                              ),
                              TextSpan(
                                text: widget.totalPrice!.startsWith("null")
                                    ? " ETB ${widget.totalPrice!.substring(4)}"
                                    : ' ${widget.totalPrice}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 18.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ]),
                          ),
                    const SizedBox(height: 4),
                    if (widget.subTitle != null)
                      Text(
                        sTit,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black,
                              fontSize: 14.sp,
                            ),
                      )
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (widget.onClick != null) {
                      widget.onClick!();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                      (states) => AppColors
                          .colorPrimary, // Replace with appropriate color
                    ),
                  ),
                  child: loading
                      ? CircularProgressIndicator()
                      : Text(
                          bText,
                          style: TextStyle(color: Colors.white),
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildVoucherField() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16, top: 14, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  isDense: true,
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.colorPrimary, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.colorPrimary, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  hintStyle:
                      TextStyle(color: AppColors.colorPrimary, fontSize: 14.sp),
                  hintText: "Voucher Card",
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: AppColors.colorPrimary, // Replace with appropriate color
            child: Text(
              "APPLY",
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
