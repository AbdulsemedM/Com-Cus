import 'dart:convert';

import 'package:commercepal/features/translation/get_lang.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

class TranslationService {
  static final _apiKey = 'AIzaSyAporxDZGXGxQPXtY2zucYPikKGyqSiNeA';
  static final language = GlobalStrings.getGlobalString();
  static Future<String> translate(String message) async {
    if (language == "en") {
      return message;
    }
    final Uri uri = Uri.parse(
      'https://translation.googleapis.com/language/translate/v2?target=$language&key=$_apiKey&q=$message',
    );

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final translations = body['data']['translations'] as List;
      final translation = translations.first;

      return HtmlUnescape().convert(translation['translatedText']);
    } else {
      throw Exception();
    }
  }

  static Future<String> translate2(
      String message, String fromLanguageCode, String toLanguageCode) async {
    final translation = await GoogleTranslator().translate(
      message,
      from: fromLanguageCode,
      to: toLanguageCode,
    );

    return translation.text;
  }
}
