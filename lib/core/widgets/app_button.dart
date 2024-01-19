import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';

import '../../app/utils/app_colors.dart';

class AppButtonWidget extends StatefulWidget {
  final Function onClick;
  final bool? isLoading;
  final String text;

  const AppButtonWidget({
    Key? key,
    required this.onClick,
    this.isLoading = false,
    this.text = "Submit",
  }) : super(key: key);

  @override
  _AppButtonWidgetState createState() => _AppButtonWidgetState();
}

class _AppButtonWidgetState extends State<AppButtonWidget> {
  void initState() {
    super.initState();
    fetchHints();
  }

  void fetchHints() async {
    setState(() {
      loading = true;
    });

    subcityHint = Translations.translatedText(
        widget.text, GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    cHint = await subcityHint;
    print("herrerererere");
    print(cHint);

    setState(() {
      loading = false;
    });
  }

  var subcityHint;
  String cHint = '';
  var loading = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: widget.isLoading != true
            ? () {
                widget.onClick.call();
              }
            : null,
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) =>
              AppColors.colorPrimaryDark), // Change to your desired color
        ),
        child: widget.isLoading == true
            ? const Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              )
            : loading
                ? CircularProgressIndicator()
                : Text(cHint),
      ),
    );
  }
}
