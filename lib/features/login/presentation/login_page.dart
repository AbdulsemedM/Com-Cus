import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/assets.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/widgets/app_button.dart';
import 'package:commercepal/features/check_out/presentation/check_out_page.dart';
import 'package:commercepal/features/dashboard/dashboard_page.dart';
import 'package:commercepal/features/forgot_password/forgot_password.dart';
import 'package:commercepal/features/login/presentation/bloc/login_cubit.dart';
import 'package:commercepal/features/login/presentation/bloc/login_state.dart';
import 'package:commercepal/features/reset_password/presentation/reset_pass_page.dart';
import 'package:commercepal/features/set_password/presentation/user_set_password_page.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translation_widget.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:commercepal/features/user_registration/presentation/user_registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/utils/app_colors.dart';
import '../../../core/widgets/input_decorations.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/login";

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _emailOrPhone;
  String? _pass;

  var loading = false;
  @override
  void initState() {
    super.initState();
    fetchHints();
  }

  void fetchHints() async {
    setState(() {
      loading = true;
    });

    physicalAddressHintFuture = Translations.translatedText(
        "Password", GlobalStrings.getGlobalString());
    subcityHint = Translations.translatedText(
        "Email or Phone Number", GlobalStrings.getGlobalString());
    addAddHint = Translations.translatedText(
        "Forgot password", GlobalStrings.getGlobalString());
    LoginHint = Translations.translatedText(
        "Login to continue", GlobalStrings.getGlobalString());
    cAccountHint = Translations.translatedText(
        "Create Account", GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    pHint = await physicalAddressHintFuture;
    cHint = await subcityHint;
    aHint = await addAddHint;
    lHint = await LoginHint;
    caHint = await cAccountHint;
    print("herrerererere");
    print(pHint);
    print(cHint);

    setState(() {
      loading = false;
    });
  }

  var physicalAddressHintFuture;
  var subcityHint;
  var addAddHint;
  var LoginHint;
  var cAccountHint;
  String caHint = '';
  String pHint = '';
  String lHint = '';
  String cHint = '';
  String aHint = '';
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => getIt<LoginCubit>(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (ctx, state) {
            if (state is LoginStateError) {
              displaySnack(context, state.message);
            }

            if (state is LoginStateSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                  context, DashboardPage.routeName, (route) => false);
            }

            if (state is LoginStateSetPin) {
              Navigator.pushNamed(context, UserSetPasswordPage.routeName,
                  arguments: {"phone": state.phoneNumber, "code": _pass});
            }
          },
          builder: (ctx, state) {
            return SafeArea(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        Assets.appIcon,
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                      // loading
                      //     ? Text("Loading...")
                      //     :
                      Text(
                        translatedStrings['continue']!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      // loading
                      //     ? const Text("Loading...")
                      //     :
                      TextFormField(
                          validator: (v) {
                            if (v?.isEmpty == true) {
                              return "Email or phone number is required";
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) {
                            setState(() {
                              _emailOrPhone = value;
                            });
                          },
                          decoration: buildInputDecoration(
                              translatedStrings['email_or_phone']!)),
                      const SizedBox(
                        height: 16,
                      ),
                      // loading
                      //     ? const Text("Loading...")
                      //     :
                      TextFormField(
                        obscureText: obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (v) {
                          if (v?.isEmpty == true) {
                            return "Password is required";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          setState(() {
                            _pass = value;
                          });
                        },
                        // decoration: buildInputDecoration(pHint),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: AppColors.fieldBorder.withOpacity(0.8),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: translatedStrings['password']!,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassword()));
                            },
                            child:
                                //  loading
                                //     ? const Text("Loading...")
                                //     :
                                Text(
                              translatedStrings['forgot_password']!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: AppColors.secondaryTextColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppButtonWidget(
                          isLoading: state is LoginStateLoading,
                          onClick: () {
                            if (_formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();

                              ctx
                                  .read<LoginCubit>()
                                  .loginUser(_emailOrPhone!, _pass!);
                            }
                          }),
                      // const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, UserRegistrationPage.routeName);
                          },
                          child:
                              // loading
                              //     ? Text('Loading...')
                              //     :
                              Text(
                            translatedStrings['create_account']!,
                            style: const TextStyle(
                              color: AppColors.colorPrimaryDark,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
