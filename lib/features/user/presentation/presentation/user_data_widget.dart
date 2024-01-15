import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/features/addresses/presentation/addresses_page.dart';
import 'package:commercepal/features/change_password/presentation/change_password_page.dart';
import 'package:commercepal/features/dashboard/bloc/dashboard_state.dart';
import 'package:commercepal/features/dashboard/dashboard_page.dart';
import 'package:commercepal/features/user/presentation/bloc/user_cubit.dart';
import 'package:commercepal/features/user/presentation/bloc/user_state.dart';
import 'package:commercepal/features/user/presentation/presentation/widgets/prompt_widget.dart';
import 'package:commercepal/features/validate_phone_email/presentation/validate_phone_email_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

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
  _UserDataWidgetState createState() => _UserDataWidgetState();
}

class _UserDataWidgetState extends State<UserDataWidget> {
  GoogleTranslator tr = GoogleTranslator();
  var loading = false;
  @override
  void initState() {
    super.initState();
  }

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
              "Logout",
              textAlign: TextAlign.right,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.colorPrimary, fontSize: 14.sp),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.colorPrimary),
            child: Text(
              "${widget.userModel.details?.firstName?[0]}${widget.userModel.details?.lastName?[0]}",
              style: TextStyle(color: Colors.white, fontSize: 30.sp),
            ),
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
          const SizedBox(
            height: 10,
          ),
          // provider for toggling visibility of switch action
          BlocProvider(
            create: (context) =>
                getIt<DashboardCubit>()..checkIfUserIsABusiness(),
            child: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (ctx, state) {
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
            icon: Icons.production_quantity_limits_outlined,
            title: "Special Orders",
            onClick: () {
              Navigator.pushNamed(context, ListSpecialOrdersPage.routeName);
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: Icons.list_alt_outlined,
            title: "My Orders",
            onClick: () {
              Navigator.pushNamed(context, UserOrdersPage.routeName);
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: Icons.maps_home_work_outlined,
            title: "Addresses",
            onClick: () {
              Navigator.pushNamed(context, AddressesPage.routeName);
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: Icons.password_outlined,
            title: "Change Password",
            onClick: () {
              Navigator.pushNamed(context, ChangePasswordPage.routeName)
                  .then((value) {
                widget.onRefresh.call();
              });
            },
          ),
          const Divider(),
          UserMenuItem(
            icon: FontAwesomeIcons.language,
            title: "Change Language",
            onClick: () {
              buildLanguageDialog(context);
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
            title: "Delete your account",
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
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text('Personal Details',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.secondaryTextColor)),
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
        if (widget.userModel.authStatus?.isEmailValidated == 0)
          const SizedBox(
            height: 10,
          ),
        if (widget.userModel.authStatus?.isEmailValidated == 0)
          PromptWidget(
            text: "Validate your email",
            onClick: () {
              Navigator.pushNamed(context, ValidatePhoneEmailPage.routeName,
                  arguments: {
                    "email": widget.userModel.details?.email ?? ""
                  }).then((value) {
                widget.onRefresh.call();
              });
            },
          ),
        if (widget.userModel.authStatus?.isPhoneValidated == 0)
          const SizedBox(
            height: 10,
          ),
        if (widget.userModel.authStatus?.isPhoneValidated == 0)
          PromptWidget(
            text: "Validate your phone number",
            onClick: () {
              Navigator.pushNamed(context, ValidatePhoneEmailPage.routeName,
                  arguments: {
                    "phoneNumber": widget.userModel.details?.phoneNumber ?? ""
                  }).then((value) {
                widget.onRefresh.call();
              });
            },
          ),
      ],
    );
  }

  final List locale = [
    {'name': 'English', 'locale': Locale('en', 'US')},
    {'name': 'ٱلْعَرَبِيَّة', 'locale': Locale('ar', 'SA')},
    {'name': 'አማርኛ', 'locale': Locale('am', 'ET')},
    {'name': 'Somali', 'locale': Locale('en', 'US')},
    {'name': 'Afaan Oromoo', 'locale': Locale('or', 'ET')},
  ];
  buildLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          title: Text('Choose Language'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Text(locale[index]['name']),
                    onTap: () async {
                      // Get the selected locale and call the setLanguage method
                      String selectedLocale = locale[index]['name'];
                      // print(selectedLocale);
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString("lang", selectedLocale);
                      print(selectedLocale);
                      Navigator.pop(context);
                      // setState(() {});
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: AppColors.colorPrimary,
                );
              },
              itemCount: locale.length,
            ),
          ),
        );
      },
    );
  }

  Future<String> trans(String text) async {
    setState(() {
      loading = true;
    });
    Translation trns =
        await tr.translate(text, to: 'am'); //translating to hi = hindi
    print(trns);
    setState(() {
      loading = false;
    });
    return trns.text;
  }
}
