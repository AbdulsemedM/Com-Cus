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
import 'package:commercepal/app/utils/logger.dart';

class PersonalBusinessAccWidget extends StatefulWidget {
  const PersonalBusinessAccWidget({
    Key? key,
  }) : super(key: key);

  @override
  _PersonalBusinessAccWidgetState createState() =>
      _PersonalBusinessAccWidgetState();
}

class _PersonalBusinessAccWidgetState extends State<PersonalBusinessAccWidget> {
  String switched = '';
  var laoding = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DashboardCubit>()..hasUserSwitchedAccounts(),
      child: BlocConsumer<DashboardCubit, DashboardState>(
        listener: (ctx, state) {
          if (state is DashboardSuccessState) {
            displaySnack(context, "Switching your account...");
          }
          if (state is DashboardUserSwicthedState) {
            appLog("heree wew go");
            if (state.switched) {
              if (mounted) {
                setState(() {
                  switched = "Switch To Personal";
                  laoding = false;
                });
              }
            } else {
              if (mounted) {
                setState(() {
                  switched = "Switch To Business";
                  laoding = false;
                });
              }
            }
          }
        },
        builder: (ctx, state) {
          return laoding
              ? CircularProgressIndicator()
              : AppButtonWidget(
                  isLoading: state is DashboardLoadingState,
                  onClick: () async {
                    if (mounted) {
                      ctx.read<DashboardCubit>().toggleBusinessUserAcc();

                      Future.delayed(const Duration(seconds: 1)).then((value) {
                        Navigator.popAndPushNamed(
                            context, DashboardPage.routeName);
                      });
                    }
                  },
                  text: switched,
                );
        },
      ),
    );
  }
}
