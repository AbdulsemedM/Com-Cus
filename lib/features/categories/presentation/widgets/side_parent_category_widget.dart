import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/utils/app_colors.dart';

class SideParentCategoryItemWidget extends StatelessWidget {
  final String name;
  final String image;

  const SideParentCategoryItemWidget(
      {Key? key, required this.name, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
      child: Column(
        children: [
          CachedNetworkImage(
            height: 60,
            width: 60,
            placeholder: (_, __) => Container(
              color: AppColors.bg1,
            ),
            errorWidget: (_, __, ___) => Container(
              color: Colors.grey,
            ),
            imageUrl: image,
          ),
          FutureBuilder<String>(
            future: TranslationService.translate(
                name),
            //  translatedText("Log Out", 'en', dropdownValue),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(
                  snapshot.data ?? 'Default Text',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.normal, fontSize: 12.sp),
                );
              } else {
                return Text(
                  'Loading...',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.normal, fontSize: 12.sp),
                ); // Or any loading indicator
              }
            },
          ),
        ],
      ),
    );
  }
}
