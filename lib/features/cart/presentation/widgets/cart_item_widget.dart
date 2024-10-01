import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercepal/app/utils/string_utils.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/utils/app_colors.dart';
import '../../../../core/cart-core/bloc/cart_core_cubit.dart';
import '../../../../core/cart-core/domain/cart_item.dart';

class CartItemWidget extends StatefulWidget {
  final CartItem cartItem;

  const CartItemWidget({
    super.key,
    required this.cartItem,
  });

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  int _quantity = 0;
  FocusNode amountFocus = FocusNode();
  TextEditingController amount = TextEditingController();

  @override
  void initState() {
    super.initState();
    prints(widget.cartItem);
    _deleteCartItem();
    setState(() {
      _quantity = widget.cartItem.quantity ?? 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                context.read<CartCoreCubit>().deleteItem(widget.cartItem);
              },
              child: const Icon(Icons.delete)),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFC4C4C4).withOpacity(0.4),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              child: CachedNetworkImage(
                width: 80,
                height: 100,
                placeholder: (_, __) => Container(
                  color: Colors.grey,
                ),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey,
                ),
                imageUrl: "${widget.cartItem.image}",
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<String>(
                  future: TranslationService.translate(
                      "${widget.cartItem.name}"), // Translate hint
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                          "..."); // Show loading indicator for hint
                    } else if (snapshot.hasError) {
                      return Text('${widget.cartItem.name}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: AppColors.colorPrimary,
                                  fontSize: 14.sp)); // Show error for hint
                    } else {
                      return Text(snapshot.data ?? '${widget.cartItem.name}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: AppColors.colorPrimary,
                                  fontSize: 14.sp)); // Display translated hint
                    }
                  },
                ),
                // Text(
                //   "${widget.cartItem.name}",
                //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
                //       color: AppColors.colorPrimary, fontSize: 14.sp),
                // ),
                if (widget.cartItem.description != null)
                  const SizedBox(
                    height: 5,
                  ),
                if (widget.cartItem.description != null)
                  FutureBuilder<String>(
                    future: TranslationService.translate(
                        "${widget.cartItem.description}"), // Translate hint
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                            "..."); // Show loading indicator for hint
                      } else if (snapshot.hasError) {
                        return Text('${widget.cartItem.description}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize: 13.sp,
                                    color:
                                        Colors.black)); // Show error for hint
                      } else {
                        return Text(
                            snapshot.data ?? '${widget.cartItem.description}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize: 13.sp,
                                    color: Colors
                                        .black)); // Display translated hint
                      }
                    },
                  ),
                // Text(
                //   "${widget.cartItem.description}",
                //   maxLines: 2,
                //   overflow: TextOverflow.ellipsis,
                //   style: Theme.of(context)
                //       .textTheme
                //       .bodyMedium
                //       ?.copyWith(fontSize: 13.sp, color: Colors.black),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      '${widget.cartItem.currency ?? "ETB"} ${widget.cartItem.price}',
                      // widget.cartItem.price
                      //     .formatCurrency(widget.cartItem.currency),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.black, fontSize: 14),
                    ),
                    const Spacer(),
                    Container(
                        height: 40,
                        width: 70,
                        child: TextFormField(
                          onTapOutside: (event) {
                            amountFocus.unfocus();
                            amount.clear();
                          },
                          onChanged: (value) {
                            String inputValue = amount.text;
                            int? parsedValue = parsePositiveInteger(inputValue);
                            if (parsedValue != null) {
                              setState(() {
                                _quantity = parsedValue;
                              });
                              context
                                  .read<CartCoreCubit>()
                                  .changeCartItemQuantity(
                                      widget.cartItem, _quantity);
                            }
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(5),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: amount,
                          focusNode: amountFocus,
                          // maxLength: 5,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            // labelText: "Phone Number*".tr,
                          ),
                          onEditingComplete: () {
                            String inputValue = amount.text;
                            int? parsedValue = parsePositiveInteger(inputValue);
                            if (parsedValue != null) {
                              setState(() {
                                _quantity = parsedValue;
                              });
                              context
                                  .read<CartCoreCubit>()
                                  .changeCartItemQuantity(
                                      widget.cartItem, _quantity);
                            }
                            amount.clear();
                          },
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: const BoxDecoration(color: AppColors.bg1),
                      child: InkWell(
                        onTap: () {
                          if (_quantity > 1) {
                            setState(() {
                              _quantity -= 1;
                            });
                            context
                                .read<CartCoreCubit>()
                                .changeCartItemQuantity(
                                    widget.cartItem, _quantity);
                          }
                        },
                        child: Text(
                          "-",
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "$_quantity",
                        style: TextStyle(color: Colors.black, fontSize: 18.sp),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: const BoxDecoration(color: AppColors.bg1),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _quantity += 1;
                          });
                          context.read<CartCoreCubit>().changeCartItemQuantity(
                              widget.cartItem, _quantity);
                        },
                        child: Text(
                          "+",
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _deleteCartItem() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? isdone = prefs.getString("epg_done");
    print(isdone);
    if (isdone == 'yes') {
      context.read<CartCoreCubit>().deleteItem(widget.cartItem);
      prefs.setString("epg_done", "no");
    }
  }

  void prints(CartItem myc) {
    print("herererer");
    print(myc.currency);
  }

  int? parsePositiveInteger(String value) {
    try {
      int parsedValue = int.parse(value);
      if (parsedValue >= 0) {
        return parsedValue;
      } else {
        // Handle negative values
        return parsedValue * -1;
      }
    } catch (e) {
      // Handle non-integer values
      return null;
    }
  }
}
