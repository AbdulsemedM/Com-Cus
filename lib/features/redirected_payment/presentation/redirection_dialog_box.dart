import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/features/redirected_payment/domain/redirected_payment_repo.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/cart-core/dao/cart_dao.dart';

class CustomDialog extends StatelessWidget {
  final String cashType;
  final String? phone;
  const CustomDialog({super.key, required this.cashType, this.phone,});

  void _launchURL(context) async {
    String url = "";
    try {
      url = await getIt<RedirectedPaymentRepo>().getPaymentApi(cashType,phone);
      if (await canLaunch(url)) {
        await launch(url);
        CartDao db = getIt<CartDao>();
        db.nuke();
        Navigator.pushNamed(context, '/dashboard');
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: AppColors.iconColor,
                ),
                onPressed: () => {Navigator.of(context).pop()},
              )),
          Image.asset(
            "assets/icons/app_icon.png",
            cacheHeight: (MediaQuery.sizeOf(context).width * 0.2).round(),
            cacheWidth: (MediaQuery.sizeOf(context).width * 0.2).round(),
          ),
          Text(
            'Do you want to proceed with the payment?',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Sora",
                fontSize: MediaQuery.sizeOf(context).width * 0.05),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.colorPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            onPressed: () {
              _launchURL(context);
            },
            child: const Text(
              'Make a payment',
            ),
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}
