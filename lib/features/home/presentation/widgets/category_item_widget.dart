import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/utils/app_colors.dart';

class CategoryItemWidget extends StatelessWidget {
  final String title;
  final String image;

  const CategoryItemWidget({Key? key, required this.title, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height;
    return Column(
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
              color: Colors.grey,
            ),
            imageUrl: image,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: FutureBuilder<String>(
            future: TranslationService.translate(title), // Translate hint
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("..."); // Show loading indicator for hint
              } else if (snapshot.hasError) {
                return Text(
                  title,
                  maxLines: 2,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: sHeight > 896 ? 12 : 12.sp),
                ); // Show error for hint
              } else {
                return Text(
                  snapshot.data ?? title,
                  maxLines: 2,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: sHeight > 896 ? 12 : 12.sp),
                ); // Display translated hint
              }
            },
          ),
          // Text(title,
          //     maxLines: 2,
          //     style: Theme.of(context)
          //         .textTheme
          //         .bodyMedium
          //         ?.copyWith(fontSize: sHeight > 896 ? 12 : 12.sp)),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
