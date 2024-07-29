import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercepal/app/app.dart';
import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/customer_loan/data/dto/financial_mark_ups_dto.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/cash_payment/presentation/cash_payment_page.dart';
import 'package:commercepal/features/cbe_birr/cbe_birr.dart';
import 'package:commercepal/features/dashboard/widgets/home_error_widget.dart';
import 'package:commercepal/features/dashboard/widgets/home_loading_widget.dart';
import 'package:commercepal/features/epg/epg_payment.dart';
import 'package:commercepal/features/hijra_bank_loan/hijra_bank.dart';
import 'package:commercepal/features/otp_payments/presentation/otp_payment_page.dart';
import 'package:commercepal/features/payment/data/dto/payment_modes_dto.dart';
import 'package:commercepal/features/payment/presentation/bloc/payment_cubit.dart';
import 'package:commercepal/features/payment/presentation/bloc/payment_state.dart';
import 'package:commercepal/features/rays_microfinance/rays_microfinance.dart';
import 'package:commercepal/features/sahay_payment/presentation/sahay_pay_page.dart';
import 'package:commercepal/features/tele_birr/tele_birr.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/utils/assets.dart';
import '../../customer_loan/presentation/customer_loan_page.dart';
import 'loan_payment_period_bs.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  static const routeName = "/payment_page";

  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  var loading = false;
  String? message;
  String? url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: Translations.translatedText(
              'Payment modes', GlobalStrings.getGlobalString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading..."); // Loading indicator while translating
            } else if (snapshot.hasError) {
              return Text('Payment Modes');
            } else {
              return Text(
                snapshot.data ?? 'Payment modes',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.black),
              );
            }
          },
        ),
        centerTitle: false,
      ),
      body: BlocProvider(
        create: (context) => getIt<PaymentCubit>()..fetchPaymentModes(),
        child: BlocConsumer<PaymentCubit, PaymentState>(
          listener: (context, state) {},
          builder: (ctx, state) {
            return state.maybeWhen(
              orElse: () => const HomeLoadingWidget(),
              error: (error) => HomeErrorWidget(error: error),
              paymentMethods: (paymentModes) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: paymentModes
                      .map((e) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<String>(
                                future: Translations.translatedText(
                                    e.name ?? '',
                                    GlobalStrings.getGlobalString()),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text(
                                        "Loading..."); // Loading indicator while translating
                                  } else if (snapshot.hasError) {
                                    return Text(e.name ?? '');
                                  } else {
                                    return Text(
                                      snapshot.data ?? e.name ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(color: Colors.black),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              Container(
                                height: e.items!.length > 3
                                    ? MediaQuery.of(context).size.height * 0.25
                                    : MediaQuery.of(context).size.height * 0.12,
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        3, // Number of items in each row
                                    crossAxisSpacing:
                                        4.0, // Spacing between columns
                                    mainAxisSpacing: 0, // Spacing between rows
                                  ),
                                  itemCount: e.items!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var item = e.items![index];

                                    return InkWell(
                                      onTap: () {
                                        _redirectUserBasedOnPaymentMethod(
                                            item, context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              height: 60,
                                              width: 60,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.bg1,
                                              ),
                                              child: item.iconUrl == "loan.png"
                                                  ? Image.asset(Assets.bank)
                                                  : CachedNetworkImage(
                                                      imageUrl:
                                                          item.iconUrl ?? '',
                                                    ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(item.name ?? ''),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _redirectUserBasedOnPaymentMethod(
      PaymentMethodItem e, BuildContext context) {
    // print(e.name);
    if (e.name!.toLowerCase().contains("sahay") == true) {
      Navigator.pushNamed(context, SahayPayPage.routeName, arguments: {
        "cash_type": e.name,
        "payment_instruction": e.paymentInstruction
      });
    } else if (e.name!.toLowerCase().contains("amole") == true) {
      Navigator.pushNamed(context, OtpPaymentPage.routeName, arguments: {
        "cash_type": e.paymentType,
        "payment_instruction": e.paymentInstruction
      });
    } else if (e.name!.toLowerCase().contains("epg") == true) {
      Navigator.pushNamed(
        context,
        EPGPayment.routeName,
      );
    } else if (e.name!.toLowerCase().contains("telebirr") == true) {
      // displaySnack(context, 'Will be available soon.');
      // if (url != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const TeleBirrPayment()));
      // }
    } else if (e.name!.toLowerCase().contains("rays microfinance") == true) {
      Navigator.pushNamed(context, RaysMicrofinance.routeName);
    } else if (e.name!.toLowerCase().contains("hijra bank") == true) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const HijraBankLoan()));
    } else if (e.paymentMode == PaymentMode.loan) {
      print(e.name!.toLowerCase());
      _showModalBottomSheet(context, e.id!, (MarkUpItem markUpItem) {
        Navigator.pushNamed(context, CustomerLoanPage.routeName, arguments: {
          "name": "Loan payment via ${e.name}",
          "institutionId": e.id,
          "markUp": markUpItem
        });
      });
    } else if (e.name!.toLowerCase().contains("cbe birr") == true) {
      Navigator.pushNamed(
        context,
        CBEBirrPayment.routeName,
      );
    } else {
      Navigator.pushNamed(context, CashPaymentPage.routeName, arguments: {
        "cash_type": e.paymentType,
        "cash_type_name": e.name,
        "payment_instruction": e.paymentInstruction
      });
    }
  }
}

void _showModalBottomSheet(
    BuildContext context, num institutionId, Function onPeriodClicked) {
  showModalBottomSheet(
    context: context,
    builder: (ctx) => LoanPaymentPeriodBs(
      institutionId: institutionId,
      onPeriodClicked: onPeriodClicked,
    ),
  );
}
