import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/utils/app_colors.dart';
import 'package:commercepal/app/utils/logger.dart';

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
  late Future<String> tTitle;
  late Future<String> tSubTitle;
  late Future<List<String>>
      translateData; // Replace this with your translation method

  @override
  void initState() {
    super.initState();
    if (widget.title == 'Specifications') {
      appLog(_open);
      _open = true;
    }
    tTitle = TranslationService.translate(widget.title);
    tSubTitle = TranslationService.translate(widget.subTitle ?? "");
    translateData = translateMyData(widget.data ?? []);
  }

  Future<List<String>> translateMyData(List<String> data) async {
    // Use Future.wait to translate each item in the list
    return Future.wait(data.map((e) => TranslationService.translate(e)));
  }

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
                    FutureBuilder<String>(
                      future: tTitle, // Translate hint
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                              "..."); // Show loading indicator for hint
                        } else if (snapshot.hasError) {
                          return Text(widget.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: Colors.black,
                                      fontSize: 18.sp)); // Show error for hint
                        } else {
                          return Text(snapshot.data ?? widget.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: Colors.black,
                                      fontSize:
                                          18.sp)); // Display translated hint
                        }
                      },
                    ),

                    // Text(
                    //   widget.title,
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .titleMedium
                    //       ?.copyWith(color: Colors.black, fontSize: 18.sp),
                    // ),
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
                    if (widget.subTitle != null)
                      Row(
                        children: [
                          FutureBuilder<String>(
                            future: tSubTitle, // Translate hint
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text(
                                    "..."); // Show loading indicator for hint
                              } else if (snapshot.hasError) {
                                return Text(
                                  widget.subTitle ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ); // Show error for hint
                              } else {
                                return Text(
                                  snapshot.data ?? widget.subTitle ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ); // Display translated hint
                              }
                            },
                          ),
                          // Text(
                          //   widget.subTitle!,
                          // ),
                        ],
                      ),
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
                child: FutureBuilder<List<String>>(
                  future: translateData, // Call the translation method
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child:
                              CircularProgressIndicator()); // Loading indicator
                    } else if (snapshot.hasError) {
                      return Center(
                          child:
                              Text('Error: ${snapshot.error}')); // Handle error
                    } else if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: snapshot.data!
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "• $e",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: AppColors.primaryTextColor),
                                  ),
                                ))
                            .toList(),
                      );
                    }
                    return Container(); // Fallback in case of unexpected behavior
                  },
                ),
              )
          ],
        ),
      ),
    );
  }

  String wrapText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      String wrappedText = '';
      for (int i = 0; i < text.length; i += maxLength) {
        wrappedText += text.substring(i, i + maxLength) + '\n';
      }
      return wrappedText;
    }
  }
}
