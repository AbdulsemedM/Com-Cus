import 'dart:convert';

// import 'package:google_translate/components/google_translate.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';

class Translations {
  static final languages = <String>[
    'English',
    'ٱلْعَرَبِيَّة',
    'አማርኛ',
    'Somali',
    'Afaan Oromoo',
  ];

  // static String getLanguageCode(String language) {
  //   switch (language) {
  //     case 'English':
  //       return 'en';
  //     case 'ٱلْعَرَبِيَّة':
  //       return 'ar';
  //     case 'አማርኛ':
  //       return 'am';
  //     case 'Somali':
  //       return 'sm';
  //     case 'Afaan Oromoo':
  //       return 'or';
  //     default:
  //       return 'en';
  //   }
  // }

  static Future<String> translatedText(
      String text, String targetLanguage) async {
    if (targetLanguage == 'en') {
      return text; // Return the original text if target language is English
    }
    try {
      print("trans;ated");
      String result = await TranslationService.translate(text);
      print(result);
      return result;
    } catch (e) {
      return text; // Return the original text if target language is English
    }
    // Translation translation =
    //     await GoogleTranslator().translate(text, to: targetLanguage);
    // print(translation.text);
    // return translation.text;
  }

  // final GoogleTranslator _translator = GoogleTranslator();

  // static Future<String> translatedText(
  //     String text, String targetLanguage) async {
  //   if (targetLanguage == 'en') {
  //     return text; // Return the original text if target language is English
  //   }

  //   final apiKey =
  //       "AIzaSyC2YukgrlGVdc0NZHY6JuRJK3GuIs5U4Ks"; // Replace with your API key
  //   final url = 'https://translation.googleapis.com/language/translate/v2';
  //   final unescape = HtmlUnescape();

  //   final response = await http.post(
  //     Uri.parse(url),
  //     body: {
  //       'q': text,
  //       'target': targetLanguage,
  //       'key': apiKey,
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final decoded = json.decode(response.body);
  //     final translatedText =
  //         decoded['data']['translations'][0]['translatedText'];
  //     final unescapedText = unescape.convert(translatedText);
  //     print(unescapedText);
  //     return unescapedText;
  //   } else {
  //     return text;
  //     // throw Exception('Failed to translate text');
  //   }
  // }

  // Future<String> translateText(text, sourceLanguage, targetLanguage) async {
  //   GoogleTranslate googleTranslate = GoogleTranslate();
  //   final String result = await googleTranslate.translate(
  //     text,
  //     sourceLanguage: sourceLanguage,
  //     targetLanguage: targetLanguage,
  //   );

  //   return result;
  // }
}
