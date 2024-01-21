import 'package:commercepal/app/app.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/input_decorations.dart';
import 'widgets/special_order_form.dart';

class SpecialOrderPage extends StatelessWidget {
  static const routeName = "/special_order";

  const SpecialOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: FutureBuilder<String>(
          future: Translations.translatedText(
              "Add special Order", GlobalStrings.getGlobalString()),
          //  translatedText("Log Out", 'en', dropdownValue),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text(
                snapshot.data ?? 'Default Text',
              );
            } else {
              return Text(
                'Loading...',
              ); // Or any loading indicator
            }
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: const SpecialOrderForm(),
    );
  }
}
