import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/utils/app_colors.dart';
import '../../../../app/utils/assets.dart';
import '../../domain/schema_settings_model.dart';

class PopularWidgetItem extends StatelessWidget {
  final SchemaItem schemaItem;

  const PopularWidgetItem({Key? key, required this.schemaItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.bg1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
            child: CachedNetworkImage(
              width: 60,
              height: double.infinity,
              placeholder: (_, __) => Container(
                color: Colors.grey,
              ),
              errorWidget: (_, __, ___) => Container(
                color: Colors.grey,
              ),
              imageUrl: schemaItem.mobileThumbnail ?? "",
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 100,
                child: FutureBuilder<String>(
                  future: TranslationService.translate(
                      schemaItem.name ?? "..."), // Translate hint
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                          "..."); // Show loading indicator for hint
                    } else if (snapshot.hasError) {
                      return Text(
                        schemaItem.name ?? "...",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(fontSize: sHeight > 896 ? 12 : 14.sp),
                      ); // Show error for hint
                    } else {
                      return Text(
                        snapshot.data ?? schemaItem.name ?? "...",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(fontSize: sHeight > 896 ? 12 : 14.sp),
                      ); // Display translated hint
                    }
                  },
                ),
                //     Text(
                //   schemaItem.name ?? "...",
                //   overflow: TextOverflow.ellipsis,
                //   maxLines: 2,
                //   style: Theme.of(context)
                //       .textTheme
                //       .displaySmall
                //       ?.copyWith(fontSize: sHeight > 896 ? 12 : 14.sp),
                // ),
              ),
              Spacer(),
              SizedBox(
                width: 100,
                child: FutureBuilder<String>(
                  future: TranslationService.translate(
                      schemaItem.sectionDescription ?? ""), // Translate hint
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                          "..."); // Show loading indicator for hint
                    } else if (snapshot.hasError) {
                      return Text(schemaItem.sectionDescription ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize: sHeight > 896
                                      ? 12
                                      : 12.sp)); // Show error for hint
                    } else {
                      return Text(
                          snapshot.data ??
                              schemaItem.sectionDescription ??
                              "...",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize: sHeight > 896
                                      ? 12
                                      : 12.sp)); // Display translated hint
                    }
                  },
                ),
                // Text(
                //   schemaItem.sectionDescription ?? "",
                //   overflow: TextOverflow.ellipsis,
                //   maxLines: 1,
                //   style: Theme.of(context)
                //       .textTheme
                //       .bodyMedium
                //       ?.copyWith(fontSize: sHeight > 896 ? 12 : 12.sp),
                // ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          )
        ],
      ),
    );
  }
}
