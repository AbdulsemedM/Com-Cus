// // import 'dart:convert';
// import 'dart:convert';

// import 'package:commercepal/features/translation/get_lang.dart';
// import 'package:http/http.dart' as http;
// import 'package:html_unescape/html_unescape.dart';
// import 'package:translator/translator.dart';

// Map<String, String> translatedStrings = {};

// Future<void> translateStrings() async {
//   translatedStrings.clear();
//   final language = GlobalStrings.getGlobalString(); // Get the selected language
//   if (language == 'en') {
//     translatedStrings = {
//       // 'home': 'Home',
//       // 'category': 'Category',
//       // 'cart': 'Cart',
//       // 'user': 'User',
//       'logout': 'Log Out',
//       'commercepal_coins': 'Commecepal Coins',
//       'special_orders': 'Special Orders',
//       'my_orders': 'My Orders',
//       'addresses': 'Addresses',
//       'change_password': 'Change Password',
//       'privacy_policy': 'Privacy Policy',
//       'delete_account': 'Delete Your Account',
//       'change_language': 'Change Language',
//       'personal_details': 'Personal Details',
//       'continue': 'Login to continue',
//       'email_or_phone': 'Email or Phone Number',
//       'password': 'Enter your password',
//       'forgot_password': 'Forgot Password',
//       'create_account': 'Create Account',
//       'share_app': 'Share App/ Invite Friends',
//       'contact': 'Contact Us',
//     };
//     return;
//   }

//   final apiKey =
//       'AIzaSyAporxDZGXGxQPXtY2zucYPikKGyqSiNeA'; // Replace with your API key
//   final url = 'https://translation.googleapis.com/language/translate/v2';
//   // final stringsToTranslate = {
//   //   // 'home': 'Home',
//   //   // 'category': 'Category',
//   //   // 'cart': 'Cart',
//   //   // 'user': 'User',
//   //   'logout': 'Log Out',
//   //   'special_orders': 'Special Orders',
//   //   'my_orders': 'My Orders',
//   //   'addresses': 'Addresses',
//   //   'change_password': 'Change Password',
//   //   'privacy_policy': 'Privacy Policy',
//   //   'delete_account': 'Delete Your Account',
//   //   'change_language': 'Change Language',
//   //   'personal_details': 'Personal Details',
//   //   'continue': 'Login to continue',
//   //   'email_or_phone': 'Email or Phone Number',
//   //   'password': 'Enter your password',
//   //   'forgot_password': 'Forgot Password',
//   //   'create_account': 'Create Account',
//   //   'share_app': 'Share the App',
//   // };

//   await Future.forEach(stringsToTranslate.entries, (entry) async {
//     try {
//       print(entry.value);
//       Translation translation =
//           await GoogleTranslator().translate(entry.value, to: language);
//       translatedStrings[entry.key] = translation.text;
//       //////////////////////////////////////////////////////////////
//       final response = await http.post(
//         Uri.parse(url),
//         body: {
//           'q': entry.value,
//           'target': language, // Use the selected language
//           'key': apiKey,
//         },
//       );

//       if (response.statusCode == 200) {
//         final decoded = json.decode(response.body);
//         final translatedText =
//             decoded['data']['translations'][0]['translatedText'];
//         final unescapedText = HtmlUnescape().convert(translatedText);
//         translatedStrings[entry.key] = unescapedText;
//         print(unescapedText);
//       } else {
//         throw Exception('Failed to translate text');
//       }
//     } catch (e) {
//       translatedStrings[entry.key] = entry.value;
//       print('Translation failed for ${entry.key}: $e');
//     }
//   });
// }
