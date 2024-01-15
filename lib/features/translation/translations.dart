import 'package:google_translate/components/google_translate.dart';
import 'package:translator/translator.dart';

class Translations {
  static final languages = <String>[
    'English',
    'ٱلْعَرَبِيَّة',
    'አማርኛ',
    'Somali',
    'Afaan Oromoo',
  ];

  static String getLanguageCode(String language) {
    switch (language) {
      case 'English':
        return 'en';
      case 'ٱلْعَرَبِيَّة':
        return 'ar';
      case 'አማርኛ':
        return 'am';
      case 'Somali':
        return 'sm';
      case 'Afaan Oromoo':
        return 'or';
      default:
        return 'en';
    }
  }

  // static translateText(String text, String targetLanguage) async {
  //   Translation translation =
  //       await GoogleTranslator().translate(text, to: targetLanguage);
  //   print(translation.text);
  //   return translation.text;
  // }

  // final GoogleTranslator _translator = GoogleTranslator();

  Future<String> translateText(text, sourceLanguage, targetLanguage) async {
    GoogleTranslate googleTranslate = GoogleTranslate();
    final String result = await googleTranslate.translate(
      text,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );

    return result;
  }
}
