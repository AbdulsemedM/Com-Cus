import 'package:google_translate/google_translate.dart';

Future<String> translateText(text, sourceLanguage, targetLanguage) async {
  print(text);

  GoogleTranslate googleTranslate = GoogleTranslate();
  final String result = await googleTranslate.translate(
    text,
    sourceLanguage: sourceLanguage,
    targetLanguage: targetLanguage,
  );
  print(result);
  return result;
}
