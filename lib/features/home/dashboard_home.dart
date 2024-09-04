import 'dart:async';
import 'dart:io';

import 'package:android_play_install_referrer/android_play_install_referrer.dart';
// import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links2/uni_links.dart';

import '../../app/di/injector.dart';
import 'domain/schema_settings_model.dart';
import 'presentation/cubit/home_cubit.dart';
import '../dashboard/widgets/home_error_widget.dart';
import '../dashboard/widgets/home_loading_widget.dart';
import 'presentation/cubit/home_state.dart';
import 'presentation/widgets/home_data_widget.dart';
// import 'package:install_referrer/install_referrer.dart';

class DashboardHomePage extends StatefulWidget {
  const DashboardHomePage({Key? key}) : super(key: key);

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage> {
  // late AppLinks _appLinks;
  // StreamSubscription<Uri>? _linkSubscription;
  StreamSubscription? _sub;
  @override
  void initState() {
    super.initState();
    // print("Start");
    initDeepLinks();
  }

  // @override
  // void dispose() {
  //   _linkSubscription?.cancel();

  //   super.dispose();
  // }
  // Future<void> _getReferrer() async {
  //   try {
  //     print("comeonplease");
  //     final referrerDetails = await AndroidPlayInstallReferrer.installReferrer;

  //     String? referrer = referrerDetails.installReferrer;
  //     String? userId = _extractUserId(referrer);
  //     print("hereitis $userId");
  //     // if (userId != null) {
  //     //   _sendUserIdToApi(userId!);
  //     // }
  //   } catch (e) {
  //     print('Failed to get referrer: $e');
  //   }
  // }

  // String? _extractUserId(String? referrer) {
  //   if (referrer != null) {
  //     final uri = Uri.parse('https://dummy?$referrer');
  //     return uri.queryParameters['referrer'];
  //   }
  //   return null;
  // }

  Future<void> initDeepLinks() async {
    print("here we go now\$newOne");
    if (Platform.isAndroid) {
      try {
        ReferrerDetails referrerDetails =
            await AndroidPlayInstallReferrer.installReferrer;
        print("referrerDetails: ${referrerDetails.toString()}");
        final referrer = await AndroidPlayInstallReferrer.installReferrer;
        if (referrer != null) {
          final utmParams = referrer.installReferrer;
          print("Install Referrer: $utmParams");
          if (utmParams != null) {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setString("referrer", utmParams);
          }

          // final playStoreLink =
          //     'https://play.google.com/store/apps/details?id=com.commercepal.commercepal&$utmParams';
          // print("Play Store Link: $playStoreLink");

          // // Append the utmParams to your Play Store link
          // final referralLink = '$playStoreLink&$utmParams';
          // print("Referral Link: $referralLink");

          // Map<String, String> queryParams =
          //     Uri.parse(playStoreLink).queryParameters;
          // print("queryParams: $queryParams");

          // // Get the `utm_content` parameter.
          // String? utmContent = queryParams["utm_content"];
          // print("hereee");
          // print(utmContent);
        } else {
          print("Referrer is null");
        }
      } catch (e) {
        print("Error retrieving install referrer: $e");
      }
    } else if (Platform.isIOS) {
      _sub = uriLinkStream.listen((Uri? uri) async {
        if (uri != null) {
          final userId = uri.queryParameters['userId'];
          if (userId != null) {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setString("referrer", userId);
          }
        }
      }, onError: (err) {
        // Handle errors
      });
    }

    // Parse the install referrer URL to extract query parameters
    // final uri = Uri.parse('https://dummy.url/?$installReferrer');
    // final queryParams = uri.queryParameters;
    // userId = queryParams['userId'];
    // print('User ID: $userId');

    // Use the retrieved user ID as needed
    // setState(() {
    //   // Update the state with the retrieved user ID
    // });
  }

  // void openAppLink(Uri uri) {
  //   print("end");
  //   print(uri);
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()..fetchHomeSettings(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return state.when(
              init: () => const HomeLoadingWidget(),
              loading: () => const HomeLoadingWidget(),
              schemas: (SchemaSettingsModel schema) =>
                  HomePageDataWidget(schema: schema),
              error: (String error) => HomeErrorWidget(
                    error: error,
                  ));
        },
      ),
    );
  }
}
