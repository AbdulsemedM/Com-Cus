import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/utils/app_colors.dart';
import '../../app/utils/string_utils.dart';
import '../../core/cart-core/bloc/cart_core_cubit.dart';
import '../../core/cart-core/domain/cart_item.dart';
import '../../features/products/domain/product.dart';
import '../../features/translation/get_lang.dart';
import '../../features/translation/translations.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductItemWidget extends StatefulWidget {
  final double? width;
  final Product product;
  final Function? onItemClick;

  const ProductItemWidget({
    Key? key,
    required this.product,
    this.width,
    this.onItemClick,
  }) : super(key: key);

  @override
  _ProductItemWidgetState createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  bool _cartItemCheck = false;

  @override
  void initState() {
    super.initState();
    // checkCart(context, widget.product.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onItemClick?.call(widget.product);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          children: [
            Container(
              width: widget.width,
              decoration: const BoxDecoration(
                color: AppColors.bg1,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        height: 120,
                        placeholder: (_, __) => Container(
                          color: AppColors.bg1,
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.grey,
                        ),
                        imageUrl: widget.product.image ?? "",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "${widget.product.name}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (widget.product.rating != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemSize: 14,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                    ),
                  if (widget.product.currency != null)
                    const SizedBox(
                      height: 10,
                    ),
                  if (widget.product.offerPrice != null)
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            widget.product.offerPrice
                                .toString()
                                .formatCurrency(widget.product.currency),
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.colorPrimary,
                                ),
                          ),
                        ),
                        const Spacer(),
                        if (widget.product.isDiscounted.toString() == "1")
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              "${widget.product.currency} ${widget.product.offerPrice}",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                    fontSize: 12.sp,
                                    color: AppColors.secondaryTextColor,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  if (widget.product.quantity! > 0)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 9),
                      child:
                          // _cartItemCheck
                          //     ? Text('data')
                          //     :
                          ElevatedButton(
                        onPressed: () {
                          if (widget.product.subProducts != null &&
                              widget.product.subProducts! > 1) {
                            checkCart(context, widget.product.id.toString());
                            widget.onItemClick?.call(widget.product);
                          } else {
                            context
                                .read<CartCoreCubit>()
                                .addCartItem(widget.product.toCartItem());
                            displaySnack(context, "Product added to cart");
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => AppColors.colorPrimary)),
                        child: FutureBuilder<String>(
                          future: Translations.translatedText(
                              "Add to cart", GlobalStrings.getGlobalString()),
                          //  translatedText("Log Out", 'en', dropdownValue),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Text(
                                snapshot.data ?? 'Default Text',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.white),
                              );
                            } else {
                              return Text(
                                'Loading...',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.white),
                              ); // Or any loading indicator
                            }
                          },
                        ),
                      ),
                    ),
                  if (widget.product.quantity! == 0)
                    Container(
                      margin: const EdgeInsets.only(top: 6, bottom: 8),
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Product out of stock',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> checkCart(BuildContext context, String id) async {
    List<CartItem> myItems = await context.read<CartCoreCubit>().getAllItem();
    print(myItems.length);
    for (CartItem item in myItems) {
      if (id == item.productId.toString()) {
        setState(() {
          _cartItemCheck = true;
        });
        return true;
      }
    }
    return false;
  }
}
