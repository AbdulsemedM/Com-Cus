import 'package:commercepal/features/translation/get_lang.dart';
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
              future: Translations.translatedText(
                  title, GlobalStrings.getGlobalString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    snapshot.data ?? 'Default Text',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.colorPrimary, fontSize: 14.sp),
                    textAlign: TextAlign.right,
                  );
                } else {
                  return Text(
                    'Loading...',
                    textAlign: TextAlign.right,
                  ); // Or any loading indicator
                }
              },
            ),
            // Text(
            //   title,
            //   style: Theme.of(context)
            //       .textTheme
            //       .titleMedium
            //       ?.copyWith(fontSize: 14.sp),
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
