import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/assets.dart';
import 'package:commercepal/core/session/presentation/session_bloc.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../dashboard/dashboard_page.dart';
import 'bloc/splash_page_cubit.dart';
import 'bloc/splash_page_state.dart';

class SplashPage extends StatefulWidget {
  static const routeName = "/slash_page";

  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    context.read<SessionCubit>().saveHash();
    super.initState();
    _initializeSplash();
  }

  Future<void> _initializeSplash() async {
    // Fetch and apply the language every time SplashPage is loaded
    String lang = await getStoredLang();
    GlobalStrings.setGlobalString(lang);
    setState(() {}); // Ensure the UI is updated with the new language
    context.read<SessionCubit>().saveHash();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SplashPageCubit>()..redirectToDashboard(),
      child: BlocListener<SplashPageCubit, SplashPageState>(
        listener: (context, state) {
          state.whenOrNull(redirectToDashboard: () async {
            // await translateStrings();
            Navigator.popAndPushNamed(context, DashboardPage.routeName);
          });
        },
        child: Scaffold(
          body: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.appIcon,
                  width: 150,
                  height: 150,
                ),
                AnimatedTextKit(
                    totalRepeatCount: 1,
                    displayFullTextOnTap: true,
                    animatedTexts: [
                      TypewriterAnimatedText("Reinventing the wheel",
                          textStyle: Theme.of(context).textTheme.displaySmall,
                          speed: const Duration(milliseconds: 90)),
                      TypewriterAnimatedText("CommercePal",
                          textStyle: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.colorPrimary),
                          speed: const Duration(milliseconds: 100))
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
