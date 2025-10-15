// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     initDynamicLinks();
//   }

//   Future<String> createReferralLink(String userId) async {
//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: 'https://yourapp.page.link', // Your Dynamic Link domain
//       link: Uri.parse(
//           'https://yourapp.com/referral?userId=$userId'), // Your referral link
//       androidParameters: AndroidParameters(
//         packageName: 'com.yourapp.package', // Your Android package name
//         minimumVersion: 0,
//       ),
//       iosParameters: IOSParameters(
//         bundleId: 'com.yourapp.bundleId', // Your iOS bundle ID
//         minimumVersion: '0',
//       ),
//     );

//     final ShortDynamicLink shortLink =
//         await FirebaseDynamicLinks.instance.buildShortLink(parameters);
//     final Uri shortUrl = shortLink.shortUrl;

//     return shortUrl.toString();
//   }

//   void initDynamicLinks() async {
//     FirebaseDynamicLinks.instance.onLink;

//     final PendingDynamicLinkData? data =
//         await FirebaseDynamicLinks.instance.getInitialLink();
//     final Uri deepLink = data!.link;

//     if (deepLink != null) {
//       handleReferralLink(deepLink);
//     }
//   }

//   void handleReferralLink(Uri url) {
//     // Extract the userId from the URL and use it as needed
//     final String userId = url.queryParameters['userId']!;
//     appLog('Referral User ID: $userId');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Dynamic Links Example'),
//         ),
//         body: Center(
//           child: Text('Welcome to MyApp'),
//         ),
//       ),
//     );
//   }
// }
