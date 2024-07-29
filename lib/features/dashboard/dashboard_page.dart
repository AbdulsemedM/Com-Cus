import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/assets.dart';
import 'package:commercepal/core/cart-core/bloc/cart_core_cubit.dart';
import 'package:commercepal/features/cart/presentation/cart_page.dart';
import 'package:commercepal/features/dashboard/bloc/dashboard_state.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:commercepal/features/user/user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform/platform.dart';
import 'package:upgrader/upgrader.dart';

import '../../core/cart-core/bloc/cart_core_state.dart';
import '../categories/presentation/dashboard_categories.dart';
import '../home/dashboard_home.dart';
import 'bloc/dashboard_cubit.dart';

class DashboardPage extends StatefulWidget {
  static const routeName = "/dashboard";

  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool shouldUpdate = false;
  int _selectedTab = 0;
  bool redirect = false;
  bool _hasUserSwitchedToBusiness = false;

  final List _dWidgets = [
    const DashboardHomePage(),
    const DashboardCategories(),
    const CartPage(),
    const UserPage()
  ];

  final List _bWidgets = [
    const DashboardCategories(),
    const CartPage(),
    const UserPage()
  ];

  @override
  void initState() {
    // use this to refresh the carts state
    context.read<CartCoreCubit>().getItems();
    super.initState();
    fetchHints();
    fetchLatestVersion();
  }

  var physicalAddressHintFuture;
  var subcityHint;
  var addAddHint;
  var userHint;
  String pHint = '';
  String cHint = '';
  String aHint = '';
  String uHint = '';
  var loading = false;
  @override
  void fetchHints() async {
    setState(() {
      loading = true;
    });

    physicalAddressHintFuture =
        Translations.translatedText("Home", GlobalStrings.getGlobalString());
    subcityHint = Translations.translatedText(
        "Category", GlobalStrings.getGlobalString());
    addAddHint =
        Translations.translatedText("Cart", GlobalStrings.getGlobalString());
    userHint = Translations.translatedText(
        "Settings", GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    pHint = await physicalAddressHintFuture;
    cHint = await subcityHint;
    aHint = await addAddHint;
    uHint = await userHint;
    print("herrerererere");
    print(pHint);
    print(cHint);

    setState(() {
      loading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (ModalRoute.of(context)?.settings.arguments != null) {
      final args = ModalRoute.of(context)?.settings.arguments as Map;
      if (args.containsKey("redirect_to")) {
        if (args['redirect_to'] == 'cart') {
          redirect = true;
          print(_hasUserSwitchedToBusiness);
          print("_hasUserSwitchedToBusiness");
          _selectedTab = _hasUserSwitchedToBusiness ? 1 : 2;
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      showLater: shouldUpdate == true ? false : true,
      showIgnore: false,
      child: BlocProvider(
        create: (context) => getIt<DashboardCubit>()..hasUserSwitchedAccounts(),
        child: BlocConsumer<DashboardCubit, DashboardState>(
          listener: (ctx, state) {
            /// This code block is checking if the current state of the
            /// `DashboardCubit` is an instance of `DashboardUserSwicthedState`. If it
            /// is, it adjusts the `_selectedTab` index to match the new list of
            /// widgets based on whether the user has switched accounts or not. If the
            /// user has switched accounts, the `_selectedTab` index is adjusted to
            /// remove the `DashboardHomePage` widget from the list. If the user has
            /// not switched accounts, the `_selectedTab` index is adjusted to include
            /// the `DashboardHomePage` widget in the list. The `_isUserBusiness`
            /// variable is also updated to reflect the new user account status, and
            /// `setState()` is called to rebuild the widget tree with the updated
            /// state.
            if (state is DashboardUserSwicthedState) {
              // adjust index to match new list
              if (state.switched) {
                if (_selectedTab == 3) {
                  print(" Switched hererrer");
                  _selectedTab = _selectedTab - 1;
                }
                if (redirect) {
                  _selectedTab = _selectedTab - 1;
                }
              } else {
                ////////////////////////////////////////////////////////
                // if (_selectedTab == 2) _selectedTab = _selectedTab + 1;
                ////////////////////////////////////////////////////////
              }
              _hasUserSwitchedToBusiness = state.switched;
              setState(() {});
            }
          },
          builder: (ctx, state) {
            return Scaffold(
                body: SafeArea(
                  child: state is DashboardUserSwicthedState && state.switched
                      ? _bWidgets[_selectedTab]
                      : _dWidgets[_selectedTab],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    if (!_hasUserSwitchedToBusiness)
                      BottomNavigationBarItem(
                        label: pHint,
                        icon: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _selectedTab == 0
                                ? AppColors.colorPrimaryDark
                                : Colors.transparent,
                          ),
                          child: SvgPicture.asset(
                            Assets.home,
                            color: _selectedTab == 0
                                ? Colors.white
                                : AppColors.secondaryTextColor,
                          ),
                        ),
                      ),
                    BottomNavigationBarItem(
                      label: cHint,
                      icon: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selectedTab ==
                                  (_hasUserSwitchedToBusiness ? 0 : 1)
                              ? AppColors.colorPrimaryDark
                              : Colors.transparent,
                        ),
                        child: SvgPicture.asset(
                          Assets.category,
                          color: _selectedTab ==
                                  (_hasUserSwitchedToBusiness ? 0 : 1)
                              ? Colors.white
                              : AppColors.secondaryTextColor,
                        ),
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: aHint,
                      icon: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selectedTab ==
                                      (_hasUserSwitchedToBusiness ? 1 : 2)
                                  ? AppColors.colorPrimaryDark
                                  : Colors.transparent,
                            ),
                            child: SvgPicture.asset(
                              Assets.cart,
                              color: _selectedTab ==
                                      (_hasUserSwitchedToBusiness ? 1 : 2)
                                  ? Colors.white
                                  : AppColors.secondaryTextColor,
                            ),
                          ),
                          BlocBuilder<CartCoreCubit, CartCoreState>(
                            builder: (context, state) {
                              return state.maybeWhen(
                                orElse: () => const SizedBox(),
                                cartItems: (cartItems) => Positioned(
                                  top: -1,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: AppColors.colorPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      "${cartItems.map((e) => e.quantity).fold(0, (previousValue, element) => previousValue + element!)}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: uHint,
                      icon: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selectedTab ==
                                  (_hasUserSwitchedToBusiness ? 2 : 3)
                              ? AppColors.colorPrimaryDark
                              : Colors.transparent,
                        ),
                        child: SvgPicture.asset(
                          Assets.user,
                          color: _selectedTab ==
                                  (_hasUserSwitchedToBusiness ? 2 : 3)
                              ? Colors.white
                              : AppColors.secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                  currentIndex: _selectedTab,
                  onTap: (int index) {
                    setState(() {
                      _selectedTab = index;
                    });
                  },
                  selectedItemColor: AppColors.colorPrimaryDark,
                  unselectedItemColor: AppColors.secondaryTextColor,
                ));
          },
        ),
      ),
    );
  }

  Future<String> fetchLatestVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    final NewVersionPlus newVersion = NewVersionPlus(
        androidId: 'com.commercepal.commercepal', iOSId: 'com.commercepal');

    final platform = LocalPlatform();
    String latestVersion;

    if (platform.isAndroid) {
      final status = await newVersion.getVersionStatus();
      latestVersion = status?.storeVersion ?? '';
      UpdateInfo updateInfo =
          determineUpdateType(currentVersion, latestVersion);
      setState(() {
        shouldUpdate = updateInfo.isMandatory;
      });
      // print("here is the update");
      // print(latestVersion);
      // print(updateInfo.isMandatory);
    } else if (platform.isIOS) {
      final status = await newVersion.getVersionStatus();
      latestVersion = status?.storeVersion ?? '';
      UpdateInfo updateInfo =
          determineUpdateType(currentVersion, latestVersion);

      setState(() {
        shouldUpdate = updateInfo.isMandatory;
      });
    } else {
      throw Exception('Unsupported platform');
    }

    if (latestVersion.isEmpty) {
      throw Exception('Failed to fetch latest version');
    }

    return latestVersion;
  }

  UpdateInfo determineUpdateType(String currentVersion, String latestVersion) {
    List<int> currentVersionParts =
        currentVersion.split('.').map((e) => int.parse(e)).toList();
    List<int> latestVersionParts =
        latestVersion.split('.').map((e) => int.parse(e)).toList();

    bool isMandatory = false;

    if (latestVersionParts[0] > currentVersionParts[0] ||
        latestVersionParts[1] > currentVersionParts[1]) {
      isMandatory = true;
    }

    return UpdateInfo(latestVersion: latestVersion, isMandatory: isMandatory);
  }
}

class UpdateInfo {
  final String latestVersion;
  final bool isMandatory;

  UpdateInfo({required this.latestVersion, required this.isMandatory});
}
