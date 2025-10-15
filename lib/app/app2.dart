import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/assets.dart';
import 'package:commercepal/app/utils/routes.dart';
import 'package:commercepal/app/utils/app_theme.dart';
import 'package:commercepal/core/cart-core/bloc/cart_core_cubit.dart';
import 'package:commercepal/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/session/presentation/session_bloc.dart';
import '../features/splash/splash_page.dart';
import 'package:http/http.dart' as http;
import 'package:commercepal/app/utils/logger.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class CountryData {
  final String country;
  final String countryCode;
  CountryData({required this.country, required this.countryCode});
}

class _AppState extends State<App> {
  // @override
  // void initState() {
  //   super.initState();
  //   fetchCountry();
  // }

  bool _isCountryFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isCountryFetched) {
      fetchCountry();
    }
  }

  List<CountryData> countries = [];
  var loading = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          AppColors.colorPrimary, // Set your desired status bar color
    ));
    if (_isCountryFetched) {
      return ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        builder: (context, child) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<CartCoreCubit>()),
            BlocProvider(create: (_) => getIt<SessionCubit>())
          ],
          child: MaterialApp(
            theme: AppTheme.themeData(),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [],
            routes: routes,
            navigatorKey: navigationKey,
            initialRoute: SplashPage.routeName,
            home: child,
          ),
        ),
      );
    } else {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.appIcon,
                  width: 150,
                  height: 150,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<bool> fetchCountry() async {
    try {
      setState(() {
        loading = true;
      });
      final response = await http.get(Uri.https(
          "api.commercepal.com:2096", "/prime/api/v1/service/countries"));
      var data = jsonDecode(response.body);
      countries.clear();
      for (var b in data['data']) {
        countries.add(
            CountryData(countryCode: b['countryCode'], country: b['country']));
      }
      appLog(countries.length);
      setState(() {
        _isCountryFetched = true;
        loading = false;
      });
      return true; // Return true if data is fetched successfully
    } catch (e) {
      appLog(e.toString());
      setState(() {
        loading = false;
      });
      return false; // Return false if an error occurs
    }
  }
}
