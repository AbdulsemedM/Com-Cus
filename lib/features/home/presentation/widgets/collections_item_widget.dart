import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/utils/app_colors.dart';
import '../../domain/schema_settings_model.dart';

class CollectionsItemWidget extends StatelessWidget {
  final SchemaItem? item;

  const CollectionsItemWidget({
    Key? key,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 200,
        decoration: const BoxDecoration(
            color: AppColors.bg1,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: CachedNetworkImage(
                width: 200,
                height: 120,
                placeholder: (_, __) => Container(
                  color: AppColors.bg1,
                ),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey,
                ),
                imageUrl: item?.mobileThumbnail ?? "",
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 8.0, top: 8, bottom: 8, left: 8),
              child: FutureBuilder<String>(
                future: TranslationService.translate(
                    "${item?.name}"), // Translate hint
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("..."); // Show loading indicator for hint
                  } else if (snapshot.hasError) {
                    return Text(
                      "${item?.name}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontSize: 15.sp),
                    ); // Show error for hint
                  } else {
                    return Text(
                      snapshot.data ?? "${item?.name}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontSize: 15.sp),
                    ); // Display translated hint
                  }
                },
              ),
              // Text(
              //   "${item?.name}",
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              //   style: Theme.of(context)
              //       .textTheme
              //       .displayMedium
              //       ?.copyWith(fontSize: 15.sp),
              // ),
            )
          ],
        ),
      ),
    );
  }
}
