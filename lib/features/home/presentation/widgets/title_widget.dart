import 'package:commercepal/features/translation/translation_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/utils/app_colors.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final String? optionTitle;
  final Function? onOptionClick;

  const TitleWidget(
      {Key? key, required this.title, this.optionTitle, this.onOptionClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          FutureBuilder<String>(
            future: TranslationService.translate(title), // Translate hint
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("..."); // Show loading indicator for hint
              } else if (snapshot.hasError) {
                return Text(title,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp)); // Show error for hint
              } else {
                return Text(snapshot.data ?? title,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp)); // Display translated hint
              }
            },
          ),
          // Text(
          //   title,
          //   style: Theme.of(context).textTheme.displayMedium?.copyWith(
          //       color: Colors.black,
          //       fontWeight: FontWeight.w500,
          //       fontSize: 16.sp),
          // ),
          if (optionTitle != null) const Spacer(),
          if (optionTitle != null)
            FutureBuilder<String>(
              future:
                  TranslationService.translate(optionTitle!), // Translate hint
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("..."); // Show loading indicator for hint
                } else if (snapshot.hasError) {
                  return Text(
                    optionTitle!,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.colorPrimary, fontSize: 16.sp),
                  ); // Show error for hint
                } else {
                  return Text(
                    snapshot.data ?? optionTitle!,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.colorPrimary, fontSize: 16.sp),
                  ); // Display translated hint
                }
              },
            ),
          // Text(
          //   optionTitle!,
          //   style: Theme.of(context)
          //       .textTheme
          //       .displayMedium
          //       ?.copyWith(color: AppColors.colorPrimary, fontSize: 16.sp),
          // ),
        ],
      ),
    );
  }
}
