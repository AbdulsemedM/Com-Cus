import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/features/addresses/presentation/addresses_page.dart';
import 'package:commercepal/features/change_password/presentation/change_password_page.dart';
import 'package:commercepal/features/commercepal_coins/commecepal_coins.dart';
import 'package:commercepal/features/dashboard/bloc/dashboard_state.dart';
import 'package:commercepal/features/dashboard/dashboard_page.dart';
import 'package:commercepal/features/my_special_orders/my_special_orders.dart';
import 'package:commercepal/features/splash/splash_page.dart';
import 'package:commercepal/features/translation/get_lang.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/models/user_model.dart';
import '../../../dashboard/bloc/dashboard_cubit.dart';
import '../../../special_order/presentantion/list_special_orders_page.dart';
import '../../../user_orders/presentation/user_orders_page.dart';
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

  @override
  void initState() {
    super.initState();
    setState(() {
      dropdownValue = list.first;
    });
    // setLangCode();
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
              child: Text(
                translatedStrings['logout']!,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.colorPrimary, fontSize: 14.sp),
                textAlign: TextAlign.right,
              )
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
            icon: Icons.attach_money_outlined,
            title: translatedStrings['commercepal_coins']!,
            language: dropdownValue,
            onClick: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CommecepalCoins()));
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: Icons.production_quantity_limits_outlined,
            title: translatedStrings['special_orders']!,
            language: dropdownValue,
            onClick: () {
              // Navigator.pushNamed(context, ListSpecialOrdersPage.routeName);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewSpecialOrders()));
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: Icons.list_alt_outlined,
            title: translatedStrings['my_orders']!,
            language: dropdownValue,
            onClick: () {
              Navigator.pushNamed(context, UserOrdersPage.routeName);
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: Icons.maps_home_work_outlined,
            title: translatedStrings['addresses']!,
            language: dropdownValue,
            onClick: () {
              Navigator.pushNamed(context, AddressesPage.routeName);
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: Icons.password_outlined,
            title: translatedStrings['change_password']!,
            language: dropdownValue,
            onClick: () {
              Navigator.pushNamed(context, ChangePasswordPage.routeName)
                  .then((value) {
                widget.onRefresh.call();
              });
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
                  title: translatedStrings['privacy_policy']!,
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
            icon: Icons.delete,
            title: translatedStrings['delete_account']!,
            language: dropdownValue,
            onClick: () {
              displaySnackWithAction(
                  context, "Your account will deleted", "Continue", () {
                displaySnack(context, "Account deleted successfully");
                context.read<UserCubit>().logOutUser();

                Navigator.popAndPushNamed(context, DashboardPage.routeName);
              });
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: FontAwesomeIcons.language,
            title: translatedStrings['change_language']!,
            language: dropdownValue,
            onClick: () {
              buildLanguageDialog(context);
            },
          ),
          //language dropdown
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
                  translatedStrings['personal_details']!,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.secondaryTextColor),
                ),
                // FutureBuilder<String>(
                //   future: Translations.translatedText(
                //       'Personal Details',
                //       GlobalStrings
                //           .getGlobalString()), // Adjust language code as needed
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.done) {
                //       return Text(
                //         snapshot.data ?? 'Personal Details',
                //         style: Theme.of(context)
                //             .textTheme
                //             .titleMedium
                //             ?.copyWith(color: AppColors.secondaryTextColor),
                //       );
                //     } else {
                //       return Text(
                //         'Loading...', // Or any loading indicator
                //         style: Theme.of(context)
                //             .textTheme
                //             .titleMedium
                //             ?.copyWith(color: AppColors.secondaryTextColor),
                //       );
                //     }
                //   },
                // ),
                const Spacer(),
                // Text(
                //   'Edit',
                //   style: Theme.of(context)
                //       .textTheme
                //       .titleMedium
                //       ?.copyWith(color: AppColors.colorPrimary),
                // )
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
    // {'name': 'Afaan Oromoo', 'locale': 'om'},
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
                  "Choose Language", GlobalStrings.getGlobalString()),
              //  translatedText("Log Out", 'en', dropdownValue),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    snapshot.data ?? 'Default Text',
                  );
                } else {
                  return Text(
                    'Loading...',
                  ); // Or any loading indicator
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
                          GlobalStrings.setGlobalString(selectedLocale);
                          setState(() {
                            langCode = selectedLocale;
                          });
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString("lang", selectedLocale);
                          // await prefs.setBool('repeat', true);
                          // ignore: use_build_context_synchronously
                          // await translateStrings();
                          Navigator.pushNamedAndRemoveUntil(
                              context, SplashPage.routeName, (route) => false);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: AppColors.colorPrimaryDark,
                    );
                  },
                  itemCount: locale.length),
            ),
          );
        });
  }
}
