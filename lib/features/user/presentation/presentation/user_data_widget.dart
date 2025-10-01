import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/clear_cache.dart';
import 'package:commercepal/app/utils/country_manager/country_manager.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/cart-core/dao/cart_dao.dart';
import 'package:commercepal/core/translator/translator.dart';
import 'package:commercepal/features/addresses/presentation/addresses_page.dart';
import 'package:commercepal/features/change_password/presentation/change_password_page.dart';
import 'package:commercepal/features/commercepal_coins/commecepal_coins.dart';
import 'package:commercepal/features/contact_us/contact_us.dart';
import 'package:commercepal/features/dashboard/bloc/dashboard_state.dart';
import 'package:commercepal/features/dashboard/dashboard_page.dart';
import 'package:commercepal/features/install_referral/referrer.dart';
import 'package:commercepal/features/invite_friends/invite_friends.dart';
import 'package:commercepal/features/login/presentation/login_page.dart';
import 'package:commercepal/features/my_special_orders/my_special_orders.dart';
import 'package:commercepal/features/refund_policy/refund_policy_screen.dart';
import 'package:commercepal/features/splash/splash_page.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:commercepal/features/translation/translation_widget.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:commercepal/features/user/presentation/bloc/user_cubit.dart';
import 'package:commercepal/features/user/presentation/bloc/user_state.dart';
import 'package:commercepal/features/user/presentation/presentation/widgets/prompt_widget.dart';
import 'package:commercepal/features/validate_phone_email/presentation/validate_phone_email_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restart_app/restart_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/models/user_model.dart';
import '../../../dashboard/bloc/dashboard_cubit.dart';
import '../../../special_order/presentantion/list_special_orders_page.dart';
import '../../../user_orders/presentation/user_orders_page.dart';
import '../../../user_orders_new/presentation/user_orders_new_page.dart';
import 'user_menu_item.dart';
import 'widgets/personal_business_acc_widegt.dart';

class UserDataWidget extends StatefulWidget {
  final UserModel userModel;
  final Function onRefresh;

  UserDataWidget({Key? key, required this.userModel, required this.onRefresh})
      : super(key: key);

  @override
  State<UserDataWidget> createState() => _UserDataWidgetState();
}

class _UserDataWidgetState extends State<UserDataWidget> {
  List<String> list = <String>['en', 'am', 'so', 'om', 'ar'];
  String dropdownValue = "";
  String langCode = 'en';
  String valid = 'login';
  String? _selectedCurrency;
  final countryManager = CountryManager();
  String _selectedCountry = "US";
  @override
  void initState() {
    super.initState();
    checkToken();
    _loadSelectedCurrency();
    _loadSelectedCountry();
    setState(() {
      dropdownValue = list.first;
    });
    // setLangCode();
  }

  Future<void> _loadSelectedCurrency() async {
    // await countryManager.loadCountryFromPreferences();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String currency = prefs.getString("currency") ?? "";
    if (currency == "ETB") {
      _selectedCurrency = "ETB";
    } else if (currency == "AED") {
      _selectedCurrency = "AED";
    } else if (currency == "KES") {
      _selectedCurrency = "KES";
    } else if (currency == "SOS") {
      _selectedCurrency = "SOS";
    } else {
      _selectedCurrency = "USD";
    }
  }

  Future<void> _loadSelectedCountry() async {
    // await countryManager.loadCountryFromPreferences();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String country = prefs.getString("country") ?? "";
    if (country == "ET") {
      _selectedCountry = "ET";
    } else if (country == "AE") {
      _selectedCountry = "AE";
    } else if (country == "KE") {
      _selectedCountry = "KE";
    } else if (country == "SO") {
      _selectedCountry = "SO";
    } else {
      _selectedCountry = "US";
    }
  }

  Future<void> _saveSelectedCurrency(String currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("currency", currency);
    final cartDao = getIt<CartDao>();
    await cartDao.nuke();
  }

  Future<void> _saveSelectedCountry(String country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("country", country);
    final cartDao = getIt<CartDao>();
    await cartDao.nuke();
  }

  Future<void> checkToken() async {
    setState(() async {
      valid = await fetchUser1(context: context);
    });
    // if (valid == "logout") {}
  }
  // void setLangCode() async {
  //   setState(() async {
  //     langCode = await getStoredLang();
  //   });
  //   print("hereerlang");
  //   print(langCode);
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        children: [
          InkWell(
            onTap: () {
              context.read<UserCubit>().logOutUser();
              // update dashboard bottom nav bar
              context.read<DashboardCubit>().checkIfUserIsABusiness();
            },
            child:
                // Text(
                //   "Log Out",
                //   style: Theme.of(context)
                //       .textTheme
                //       .titleMedium
                //       ?.copyWith(color: AppColors.colorPrimary, fontSize: 14.sp),
                //   textAlign: TextAlign.right,
                // )
                FutureBuilder<String>(
              future: TranslationService.translate("LogOut"), // Translate hint
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("..."); // Show loading indicator for hint
                } else if (snapshot.hasError) {
                  return Text('LogOut',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.colorPrimary, fontSize: 14.sp),
                      textAlign: TextAlign.right); // Show error for hint
                } else {
                  return Text(
                    snapshot.data ?? 'LogOut',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.colorPrimary, fontSize: 14.sp),
                    textAlign: TextAlign.right,
                  ); // Display translated hint
                }
              },
            ),
            // FutureBuilder<String>(
            //   future: Translations.translatedText(
            //       "Log Out", GlobalStrings.getGlobalString()),
            //   //  translatedText("Log Out", 'en', dropdownValue),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.done) {
            //       return Text(
            //         snapshot.data ?? 'Log Out',
            //         style: Theme.of(context).textTheme.titleMedium?.copyWith(
            //             color: AppColors.colorPrimary, fontSize: 14.sp),
            //         textAlign: TextAlign.right,
            //       );
            //     } else {
            //       return Text(
            //         'Loading...',
            //         textAlign: TextAlign.right,
            //       ); // Or any loading indicator
            //     }
            //   },
            // ),
          ),

          const SizedBox(
            height: 12,
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.colorPrimary),
            child: FutureBuilder<String>(
              future: Translations.translatedText(
                  "${widget.userModel.details?.firstName?[0]}${widget.userModel.details?.lastName?[0]}",
                  'en'),
              // translateText(
              //     "${widget.userModel.details?.firstName?[0]}${widget.userModel.details?.lastName?[0]}",
              //     'en',
              //     dropdownValue),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    snapshot.data ??
                        '${widget.userModel.details?.firstName?[0]}${widget.userModel.details?.lastName?[0]}',
                    style: TextStyle(color: Colors.white, fontSize: 30.sp),
                    textAlign: TextAlign.right,
                  );
                } else {
                  return Text(
                    'Loading...',
                    textAlign: TextAlign.right,
                  ); // Or any loading indicator
                }
              },
            ),
            // Text(
            //   "${widget.userModel.details?.firstName?[0]}${widget.userModel.details?.lastName?[0]}",
            //   style: TextStyle(color: Colors.white, fontSize: 30.sp),
            // ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "${widget.userModel.details?.firstName} ${widget.userModel.details?.lastName}",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontSize: 20.sp),
            textAlign: TextAlign.center,
          ),
          // FutureBuilder<String>(
          //   future: "${widget.userModel.details?.firstName} ${widget.userModel.details?.lastName}",
          //   // translateText(
          //   //     "${widget.userModel.details?.firstName} ${widget.userModel.details?.lastName}",
          //   //     'en',
          //   //     dropdownValue),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       return Text(
          //         snapshot.data ?? 'Default Text',
          //         style: Theme.of(context)
          //             .textTheme
          //             .titleMedium
          //             ?.copyWith(fontSize: 20.sp),
          //         textAlign: TextAlign.center,
          //       );
          //     } else {
          //       return Text(
          //         'Loading...',
          //         textAlign: TextAlign.center,
          //       ); // Or any loading indicator
          //     }
          //   },
          // ),
          // Text(
          //   "${widget.userModel.details?.firstName} ${widget.userModel.details?.lastName}",
          //   style: Theme.of(context)
          //       .textTheme
          //       .titleMedium
          //       ?.copyWith(fontSize: 20.sp),
          //   textAlign: TextAlign.center,
          // ),
          const SizedBox(
            height: 10,
          ),
          // provider for toggling visibility of switch action
          BlocProvider(
            create: (context) =>
                getIt<DashboardCubit>()..checkIfUserIsABusiness(),
            child: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (ctx, state) {
                // print(state.isBusiness);
                return state is DashboardBusinessState && state.isBusiness
                    ? const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        child: Column(
                          children: [
                            PersonalBusinessAccWidget(),
                          ],
                        ),
                      )
                    : const SizedBox();
              },
            ),
          ),

          const SizedBox(
            height: 15,
          ),
          _buildPromptWidgets(context),
          const SizedBox(
            height: 20,
          ),
          UserMenuItem(
            icon: Icons.list_alt_outlined,
            title: "My Orders",
            language: dropdownValue,
            onClick: () {
              if (valid == "logout") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(fromCart: false)));
                // Navigator.pushNamed(context, LoginPage.routeName);
              } else {
                Navigator.pushNamed(context, UserOrdersNewPage.routeName);
              }
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: Icons.attach_money_outlined,
            title: "Commecepal Coins",
            language: dropdownValue,
            onClick: () {
              if (valid == "logout") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(fromCart: false)));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CommecepalCoins()));
              }
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: Icons.share_outlined,
            title: "Share App/ Invite Friends",
            language: dropdownValue,
            onClick: () async {
              if (valid == "logout") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(fromCart: false)));
                // Navigator.pushNamed(context, LoginPage.routeName);
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InviteFriends()));
                // String? link = await getReferralLink();
                // print(link);
                // Share.share("Check out this app: $link");
              }
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => CommecepalCoins()));
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: Icons.production_quantity_limits_outlined,
            title: "Special Orders",
            language: dropdownValue,
            onClick: () {
              if (valid == "logout") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(fromCart: false)));
                // Navigator.pushNamed(context, LoginPage.routeName);
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewSpecialOrders()));
              }
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: Icons.contact_support_outlined,
            title: "Contact Us",
            language: dropdownValue,
            onClick: () {
              if (valid == "logout") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(fromCart: false)));
                // Navigator.pushNamed(context, LoginPage.routeName);
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactUsPage()));
              }
            },
          ),
          const Divider(),

          UserMenuItem(
            icon: Icons.maps_home_work_outlined,
            title: "Addresses",
            language: dropdownValue,
            onClick: () {
              if (valid == "logout") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(fromCart: false)));
                // Navigator.pushNamed(context, LoginPage.routeName);
              } else {
                Navigator.pushNamed(context, AddressesPage.routeName);
              }
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: Icons.password_outlined,
            title: "Change Password",
            language: dropdownValue,
            onClick: () {
              if (valid == "logout") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(fromCart: false)));
                // Navigator.pushNamed(context, LoginPage.routeName);
              } else {
                Navigator.pushNamed(context, ChangePasswordPage.routeName)
                    .then((value) {
                  widget.onRefresh.call();
                });
              }
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: Icons.currency_exchange_outlined,
            title: "Change Currency",
            language: dropdownValue,
            onClick: () {
              _buildCurrencyDialog(context);
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: Icons.public,
            title: "Change Country",
            language: dropdownValue,
            onClick: () {
              _buildCountryDialog(context);
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: Icons.cleaning_services_outlined,
            title: "Clear Cache",
            language: dropdownValue,
            onClick: () async {
              bool clear = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: FutureBuilder<String>(
                          future: TranslationService.translate("Clear Cache"),
                          builder: (context, snapshot) {
                            return Text(snapshot.data ?? "Clear Cache");
                          },
                        ),
                        content: FutureBuilder<String>(
                          future: TranslationService.translate(
                              "Are you sure you want to clear the cache? This action cannot be undone."),
                          builder: (context, snapshot) {
                            return Text(snapshot.data ??
                                "Are you sure you want to clear the cache? This action cannot be undone.");
                          },
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: FutureBuilder<String>(
                                future: TranslationService.translate("Cancel"),
                                builder: (context, snapshot) {
                                  return Text(snapshot.data ?? "Cancel");
                                },
                              )),
                          TextButton(
                              onPressed: () {
                                // CacheUtil.clearAllCache();
                                Navigator.pop(context, true);
                              },
                              child: FutureBuilder<String>(
                                future: TranslationService.translate("Clear"),
                                builder: (context, snapshot) {
                                  return Text(snapshot.data ?? "Clear");
                                },
                              )),
                        ],
                      ));
              if (clear) {
                try {
                  // Show loading indicator
                  await clearAllData(context);
                  // Show success message
                } catch (e) {
                  // Show error message
                }
              }
            },
          ),
          const Divider(),

          BlocProvider(
            create: (context) => getIt<UserCubit>(),
            child: BlocConsumer<UserCubit, UserState>(
              listener: (ctx, state) {
                if (state is UserStateError) {
                  displaySnack(ctx, state.error);
                }
              },
              builder: (ctx, state) {
                return UserMenuItem(
                  icon: Icons.edit_document,
                  title: "Privacy Policy",
                  language: dropdownValue,
                  onClick: () {
                    ctx.read<UserCubit>().openPrivatePolicy();
                  },
                );
              },
            ),
          ),
          const Divider(),

          UserMenuItem(
            icon: Icons.edit_document,
            title: "Refund Policy",
            language: dropdownValue,
            onClick: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RefundPolicyScreen()));
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: Icons.delete,
            title: "Delete Your Account",
            language: dropdownValue,
            onClick: () {
              displaySnackWithAction(
                  context, "Your account will be deleted", "Continue", () {
                displaySnack(context, "Account deleted successfully");
                context.read<UserCubit>().logOutUser();

                Navigator.popAndPushNamed(context, DashboardPage.routeName);
              });
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: FontAwesomeIcons.language,
            title: "Change Language",
            language: dropdownValue,
            onClick: () {
              buildLanguageDialog(context);
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           const FaIcon(FontAwesomeIcons.language,
          //               color: Colors.black45),
          //           const SizedBox(width: 5),
          //           SizedBox(
          //             width: MediaQuery.sizeOf(context).width * 0.5,
          //             child: FutureBuilder<String>(
          //               future: Translations.translatedText(
          //                   'Language', 'am'), // Adjust language code as needed
          //               builder: (context, snapshot) {
          //                 if (snapshot.connectionState ==
          //                     ConnectionState.done) {
          //                   return Text(
          //                     snapshot.data ?? 'Default Text',
          //                     // Add your styling here
          //                   );
          //                 } else {
          //                   return Text(
          //                     'Loading...', // Or any loading indicator
          //                     // Add your styling here
          //                   );
          //                 }
          //               },
          //             ),
          //           ),
          //         ],
          //       ),
          //       DropdownButton<String>(
          //         value: dropdownValue,
          //         icon: const Icon(Icons.arrow_downward),
          //         elevation: 16,
          //         style: const TextStyle(color: Colors.grey),
          //         onChanged: (String? value) {
          //           // This is called when the user selects an item.
          //           setState(() {
          //             dropdownValue = value!;
          //           });
          //         },
          //         items: list.map<DropdownMenuItem<String>>((String value) {
          //           return DropdownMenuItem<String>(
          //             value: value,
          //             child: Text(value),
          //           );
          //         }).toList(),
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  "Personal Details",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.secondaryTextColor),
                ),
                const Spacer(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "${widget.userModel.details?.firstName} ${widget.userModel.details?.lastName}",
                "${widget.userModel.details?.email}",
                "${widget.userModel.details?.phoneNumber}",
                "${widget.userModel.details?.country}",
                "${widget.userModel.details?.city}",
              ]
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          e,
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.sp),
                        ),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _buildCurrencyDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Currency"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: GestureDetector(
                  onTap: () {
                    _saveSelectedCurrency("ETB");
                    _selectedCurrency = "ETB";
                    Navigator.of(context).pop();
                  },
                  child: const Text("ETB"),
                ),
                leading: Radio<String>(
                  value: "ETB",
                  groupValue: _selectedCurrency,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCurrency = value;
                        _saveSelectedCurrency(value);
                      });
                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                ),
              ),
              ListTile(
                title: GestureDetector(
                  onTap: () {
                    _saveSelectedCurrency("USD");
                    _selectedCurrency = "USD";
                    Navigator.of(context).pop();
                  },
                  child: const Text("USD"),
                ),
                leading: Radio<String>(
                  value: "USD",
                  groupValue: _selectedCurrency,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCurrency = value;
                        _saveSelectedCurrency(value);
                      });
                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                ),
              ),
              ListTile(
                title: GestureDetector(
                  onTap: () {
                    _saveSelectedCurrency("AED");
                    _selectedCurrency = "AED";
                    Navigator.of(context).pop();
                  },
                  child: const Text("AED"),
                ),
                leading: Radio<String>(
                  value: "AED",
                  groupValue: _selectedCurrency,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCurrency = value;
                        _saveSelectedCurrency(value);
                      });
                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                ),
              ),
              ListTile(
                title: GestureDetector(
                  onTap: () {
                    _saveSelectedCurrency("KES");
                    _selectedCurrency = "KES";
                    Navigator.of(context).pop();
                  },
                  child: const Text("KES"),
                ),
                leading: Radio<String>(
                  value: "KES",
                  groupValue: _selectedCurrency,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCurrency = value;
                        _saveSelectedCurrency(value);
                      });
                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                ),
              ),
              ListTile(
                title: GestureDetector(
                  onTap: () {
                    _saveSelectedCurrency("SOS");
                    _selectedCurrency = "SOS";
                    Navigator.of(context).pop();
                  },
                  child: const Text("SOS"),
                ),
                leading: Radio<String>(
                  value: "SOS",
                  groupValue: _selectedCurrency,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCurrency = value;
                        _saveSelectedCurrency(value);
                      });
                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                ),
              ),    
            ],
          ),
        );
      },
    );
  }

  Future<void> _buildCountryDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Country"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: GestureDetector(
                  onTap: () {
                    _saveSelectedCountry("ET");
                    _selectedCountry = "ET";
                    Navigator.of(context).pop();
                  },
                  child: const Text("ET"),
                ),
                leading: Radio<String>(
                  value: "ET",
                  groupValue: _selectedCountry,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCountry = value;
                        _saveSelectedCountry(value);
                      });
                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                ),
              ),
              ListTile(
                title: GestureDetector(
                  onTap: () {
                    _saveSelectedCountry("AE");
                    _selectedCountry = "AE";
                    Navigator.of(context).pop();
                  },
                  child: const Text("AE"),
                ),
                leading: Radio<String>(
                  value: "AE",
                  groupValue: _selectedCountry,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCountry = value;
                        _saveSelectedCountry(value);
                      });
                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                ),
              ),
              ListTile(
                title: GestureDetector(
                  onTap: () {
                    _saveSelectedCountry("KE");
                    _selectedCountry = "KE";
                    Navigator.of(context).pop();
                  },
                  child: const Text("KE"),
                ),
                leading: Radio<String>(
                  value: "KE",
                  groupValue: _selectedCountry,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCountry = value;
                        _saveSelectedCountry(value);
                      });
                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                ),
              ),
              ListTile(
                title: GestureDetector(
                  onTap: () {
                    _saveSelectedCountry("SO");
                    _selectedCountry = "SO";
                    Navigator.of(context).pop();
                  },
                  child: const Text("SO"),
                ),
                leading: Radio<String>(
                  value: "SO",
                  groupValue: _selectedCountry,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCountry = value;
                        _saveSelectedCountry(value);
                      });
                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _buildPromptWidgets(BuildContext context) {
    return Column(
      children: [
        if (widget.userModel.authStatus?.isEmailValidated == 0) ...[
          const SizedBox(
            height: 10,
          ),
          FutureBuilder<String>(
            future: _getPromptText("Validate your email",
                widget.userModel.details?.email ?? "", context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return PromptWidget(
                  text: snapshot.data ?? 'Default Text',
                  onClick: () {
                    Navigator.pushNamed(
                        context, ValidatePhoneEmailPage.routeName, arguments: {
                      "email": widget.userModel.details?.email ?? ""
                    }).then((value) {
                      widget.onRefresh.call();
                    });
                  },
                );
              } else {
                return PromptWidget(
                  text: 'Loading...', // Or any loading indicator
                  onClick: () {}, // Handle onClick accordingly
                );
              }
            },
          ),
        ],
        if (widget.userModel.authStatus?.isPhoneValidated == 0) ...[
          const SizedBox(
            height: 10,
          ),
          FutureBuilder<String>(
            future: _getPromptText("Validate your phone number",
                widget.userModel.details?.phoneNumber ?? "", context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return PromptWidget(
                  text: snapshot.data ?? 'Default Text',
                  onClick: () {
                    Navigator.pushNamed(
                        context, ValidatePhoneEmailPage.routeName, arguments: {
                      "phoneNumber": widget.userModel.details?.phoneNumber ?? ""
                    }).then((value) {
                      widget.onRefresh.call();
                    });
                  },
                );
              } else {
                return PromptWidget(
                  text: 'Loading...', // Or any loading indicator
                  onClick: () {}, // Handle onClick accordingly
                );
              }
            },
          ),
        ],
      ],
    );
  }

  Future<String> _getPromptText(
      String baseText, String dynamicValue, BuildContext context) async {
    // Adjust this part to get the appropriate translation based on the dynamic value or any other logic
    String translatedText = await Translations.translatedText(
        baseText, GlobalStrings.getGlobalString());
    return translatedText.replaceAll('%s', dynamicValue);
  }

  final List locale = [
    {'name': 'English', 'locale': "en"},
    {'name': 'አማርኛ', 'locale': "am"},
    {'name': 'Somali', 'locale': 'so'},
    {'name': 'Afaan Oromoo', 'locale': 'om'},
    {'name': 'ٱلْعَرَبِيَّة', 'locale': 'ar'},
  ];

  buildLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: FutureBuilder<String>(
            future: Translations.translatedText(
              "Choose Language",
              GlobalStrings.getGlobalString(),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(
                  snapshot.data ?? 'Default Text',
                );
              } else {
                return Text('Loading...');
              }
            },
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Text(locale[index]['name']),
                    onTap: () async {
                      String selectedLocale =
                          locale[index]['locale'].toString();
                      print(selectedLocale);

                      // Persist the selected locale and update state
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString("lang", selectedLocale);

                      // Set the global string immediately after the language change
                      GlobalStrings.setGlobalString(selectedLocale);

                      setState(() {
                        langCode =
                            selectedLocale; // Update the state for the current widget
                      });

                      // Ensure the change is applied before navigating
                      Future.delayed(Duration(milliseconds: 100), () {
                        Restart.restartApp(
                          notificationTitle: 'Restarting App',
                          notificationBody:
                              'Please tap here to open the app again after language change.',
                        );
                        // Navigator.pushNamedAndRemoveUntil(
                        //   context,
                        //   SplashPage.routeName,
                        //   (route) => false,
                        // );
                      });
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: AppColors.colorPrimaryDark,
                );
              },
              itemCount: locale.length,
            ),
          ),
        );
      },
    );
  }

  Future<void> clearAllData(BuildContext context) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Clear all storage
      await StorageClearer.clearAllStorage();

      // Close loading dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: FutureBuilder(
            future:
                TranslationService.translate('All data cleared successfully'),
            builder: (context, snapshot) {
              return Text(snapshot.data ?? 'All data cleared successfully');
            },
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error clearing data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
