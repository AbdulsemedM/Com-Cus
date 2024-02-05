import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/utils/app_colors.dart';

class SelectedProductOptions extends StatefulWidget {
  final String title;
  final String? subTitle;
  final String? asset;
  final List<String>? data;

  const SelectedProductOptions(
      {Key? key, required this.title, this.subTitle, this.asset, this.data})
      : super(key: key);

  @override
  State<SelectedProductOptions> createState() => _SelectedProductOptionsState();
}

class _SelectedProductOptionsState extends State<SelectedProductOptions> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _open = !_open;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  widget.asset!,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.black, fontSize: 18.sp),
                    ),
                    // FutureBuilder<String>(
                    //   future: Translations.translatedText(
                    //       widget.title, GlobalStrings.getGlobalString()),
                    //   //  translatedText("Log Out", 'en', dropdownValue),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState == ConnectionState.done) {
                    //       return Text(
                    //         snapshot.data ?? 'Default Text',
                    //         style: Theme.of(context)
                    //             .textTheme
                    //             .titleMedium
                    //             ?.copyWith(
                    //                 color: Colors.black, fontSize: 18.sp),
                    //       );
                    //     } else {
                    //       return Text(
                    //         'Loading...',
                    //         textAlign: TextAlign.right,
                    //       ); // Or any loading indicator
                    //     }
                    //   },
                    // ),
                    const SizedBox(
                      height: 4,
                    ),
                    if (widget.subTitle != null) Text(widget.subTitle!),
                    // FutureBuilder<String>(
                    //   future: Translations.translatedText(
                    //       widget.subTitle!, GlobalStrings.getGlobalString()),
                    //   //  translatedText("Log Out", 'en', dropdownValue),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState == ConnectionState.done) {
                    //       return Text(
                    //         snapshot.data ?? 'Default Text',
                    //       );
                    //     } else {
                    //       return Text(
                    //         'Loading...',
                    //       ); // Or any loading indicator
                    //     }
                    //   },
                    // ),
                  ],
                ),
                const Spacer(),
                Icon(
                  _open
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  color: Colors.grey,
                  size: 24,
                )
              ],
            ),
            if (widget.data?.isNotEmpty == true && _open)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.data!
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "• $e",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.primaryTextColor),
                            ),
                          ))
                      .toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
