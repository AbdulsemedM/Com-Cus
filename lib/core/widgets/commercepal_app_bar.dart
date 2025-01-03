import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../app/utils/app_colors.dart';
import '../../app/utils/assets.dart';
import '../cart-core/cart_widget.dart';

AppBar buildCommerceAppBar(BuildContext context,
        [String? title, String? subTitle, bool displayCart = true]) =>
    AppBar(
      centerTitle: false,
      actions: [if (displayCart) CartWidget()],
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subTitle != null)
            const SizedBox(
              height: 10,
            ),
          if (title != null)
            FutureBuilder<String>(
              future: TranslationService.translate(title),
              //  translatedText("Log Out", 'en', dropdownValue),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    snapshot.data ?? 'Default Text',
                    style: Theme.of(context).textTheme.titleMedium,
                  );
                } else {
                  return Text(
                    'Loading...',
                    style: Theme.of(context).textTheme.titleMedium,
                  ); // Or any loading indicator
                }
              },
            ),
          if (subTitle != null)
            const SizedBox(
              height: 4,
            ),
          if (subTitle != null)
            FutureBuilder<String>(
              future: TranslationService.translate(subTitle),
              //  translatedText("Log Out", 'en', dropdownValue),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(snapshot.data ?? 'Default Text',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: AppColors.secondaryTextColor));
                } else {
                  return Text('Loading...',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors
                              .secondaryTextColor)); // Or any loading indicator
                }
              },
            ),
        ],
      ),
    );
