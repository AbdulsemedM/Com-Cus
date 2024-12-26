import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:commercepal/features/user/presentation/bloc/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../login/presentation/login_page.dart';

class UserLandingWidget extends StatelessWidget {
  const UserLandingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.account_circle_outlined,
            size: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: FutureBuilder<String>(
              future: Translations.translatedText(
                  "Login to access your account details and orders",
                  GlobalStrings.getGlobalString()),
              //  translatedText("Log Out", 'en', dropdownValue),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    snapshot.data ?? 'Default Text',
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
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: AppButtonWidget(
              onClick: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(fromCart: false)));
                // await Navigator.pushNamed(context, LoginPage.routeName);
                if (!context.mounted) return;
                context.read<UserCubit>().getUser();
              },
              text: "Login",
            ),
          )
        ],
      ),
    );
  }
}
