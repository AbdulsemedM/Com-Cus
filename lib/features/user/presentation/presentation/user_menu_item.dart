import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/utils/app_colors.dart';
import '../../../../core/translator/translator.dart';

class UserMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? language;
  final Function? onClick;

  const UserMenuItem({
    super.key,
    required this.title,
    required this.icon,
    this.onClick,
    this.language,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick?.call();
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.secondaryTextColor,
              size: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            FutureBuilder<String>(
              future: TranslationService.translate(title), // Translate hint
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    "...",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.colorPrimary, fontSize: 14.sp),
                    textAlign: TextAlign.right,
                  ); // Show loading indicator for hint
                } else if (snapshot.hasError) {
                  return Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.colorPrimary, fontSize: 14.sp),
                    textAlign: TextAlign.right,
                  ); // Show error for hint
                } else {
                  return Text(
                    snapshot.data ?? title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.colorPrimary, fontSize: 14.sp),
                    textAlign: TextAlign.right,
                  ); // Display translated hint
                }
              },
            ),
            // Text(
            //   title,
            //   style: Theme.of(context)
            //       .textTheme
            //       .titleMedium
            //       ?.copyWith(color: AppColors.colorPrimary, fontSize: 14.sp),
            //   textAlign: TextAlign.right,
            // ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
