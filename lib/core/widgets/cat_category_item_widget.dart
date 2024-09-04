import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/utils/app_colors.dart';

class CatCategoryItemWidget extends StatelessWidget {
  final String title;
  final String image;

  const CatCategoryItemWidget(
      {Key? key, required this.title, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(12),
          decoration:
              const BoxDecoration(color: AppColors.bg1, shape: BoxShape.circle),
          child: CachedNetworkImage(
            placeholder: (_, __) => Container(
              color: AppColors.bg1,
            ),
            errorWidget: (_, __, ___) => Container(
              color: AppColors.bg1,
            ),
            imageUrl: image,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: FutureBuilder<String>(
            future: Translations.translatedText(
                title, GlobalStrings.getGlobalString()),
            //  translatedText("Log Out", 'en', dropdownValue),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(snapshot.data ?? 'Default Text',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 12.sp));
              } else {
                return Text('Loading...',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp)); // Or any loading indicator
              }
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
