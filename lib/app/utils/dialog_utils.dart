import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';

import 'dart:async';

Future<void> displaySnack(BuildContext context, String message) async {
  String translatedMessage = await TranslationService.translate(message);

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(milliseconds: 1000),
    content: Text(translatedMessage),
  ));
}

Future<void> displaySnackWithAction(BuildContext context, String message,
    String actionText, Function onAction) async {
  String translatedMessage = await TranslationService.translate(message);
  String translatedActionText = await TranslationService.translate(actionText);

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(translatedMessage),
    action: SnackBarAction(
      label: translatedActionText,
      onPressed: () {
        onAction();
      },
    ),
  ));
}
