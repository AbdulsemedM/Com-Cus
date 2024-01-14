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

  static translateText(String text, String targetLanguage) async {
    Translation translation =
        await GoogleTranslator().translate(text, to: targetLanguage);
    print(translation.text);
    return translation.text;
  }
}
