import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:commercepal/app/di/injector.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../dashboard/bloc/dashboard_cubit.dart';
import '../../../../dashboard/bloc/dashboard_state.dart';
import '../../../../dashboard/dashboard_page.dart';

class PersonalBusinessAccWidget extends StatefulWidget {
  const PersonalBusinessAccWidget({
    Key? key,
  }) : super(key: key);

  @override
  _PersonalBusinessAccWidgetState createState() =>
      _PersonalBusinessAccWidgetState();
}

class _PersonalBusinessAccWidgetState extends State<PersonalBusinessAccWidget> {
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
          return AppButtonWidget(
            isLoading: state is DashboardLoadingState,
            onClick: () async {
              ctx.read<DashboardCubit>().toggleBusinessUserAcc();

              Future.delayed(const Duration(seconds: 1)).then((value) {
                Navigator.popAndPushNamed(context, DashboardPage.routeName);
              });
            },
            text: state is DashboardUserSwicthedState && state.switched
                ? "Switch To Personal"
                : "Switch To Business",
          );
        },
      ),
    );
  }

  // _getButtonText(BuildContext context, DashboardState state) async {
  //   // Adjust this part to get the appropriate translation based on the current state
  //   if (state is DashboardUserSwicthedState && state.switched) {
  //     return cHint;
  //   } else {
  //     return pHint;
  //   }
  // }
}
