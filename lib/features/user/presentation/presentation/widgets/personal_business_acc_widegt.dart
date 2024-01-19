import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/di/injector.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../dashboard/bloc/dashboard_cubit.dart';
import '../../../../dashboard/bloc/dashboard_state.dart';
import '../../../../dashboard/dashboard_page.dart';

class PersonalBusinessAccWidget extends StatelessWidget {
  const PersonalBusinessAccWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => getIt<DashboardCubit>()..hasUserSwitchedAccounts(),
      child: BlocConsumer<DashboardCubit, DashboardState>(
        listener: (ctx, state) {
          if (state is DashboardSuccessState) {
            displaySnack(context, "Switching your account...");
          }
        },
        builder: (ctx, state) {
          return FutureBuilder<String>(
            future: _getButtonText(context, state),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AppButtonWidget(
                  isLoading: state is DashboardLoadingState,
                  onClick: () async {
                    ctx.read<DashboardCubit>().toggleBusinessUserAcc();

                    Future.delayed(const Duration(seconds: 1)).then((value) {
                      Navigator.popAndPushNamed(
                        context,
                        DashboardPage.routeName,
                      );
                    });
                  },
                  text: snapshot.data ?? 'Default Text',
                );
              } else {
                return AppButtonWidget(
                  onClick: () async {
                    ctx.read<DashboardCubit>().toggleBusinessUserAcc();

                    Future.delayed(const Duration(seconds: 1)).then((value) {
                      Navigator.popAndPushNamed(
                          context, DashboardPage.routeName);
                    });
                  },
                  isLoading: state is DashboardLoadingState,
                  text: 'Loading...', // Or any loading indicator
                );
              }
            },
          );
        },
      ),
    );
  }

  Future<String> _getButtonText(
      BuildContext context, DashboardState state) async {
    // Adjust this part to get the appropriate translation based on the current state
    return state is DashboardUserSwicthedState && state.switched
        ? await Translations.translatedText(
            "Switch To Personal", GlobalStrings.getGlobalString())
        : await Translations.translatedText(
            "Switch To Business", GlobalStrings.getGlobalString());
  }
}
