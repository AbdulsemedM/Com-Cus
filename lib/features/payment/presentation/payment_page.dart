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
import 'package:commercepal/features/commercepal_coins_checkout/commercepal_coins_checkout.dart';
import 'package:commercepal/features/dashboard/widgets/home_error_widget.dart';
import 'package:commercepal/features/dashboard/widgets/home_loading_widget.dart';
import 'package:commercepal/features/edahab/edahab.dart';
import 'package:commercepal/features/epg/epg_payment.dart';
import 'package:commercepal/features/hijra_bank_loan/hijra_bank.dart';
import 'package:commercepal/features/ipya/ipay.dart';
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
  String currency = "";
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map args = ModalRoute.of(context)?.settings.arguments as Map;
    currency = args['currency'];
    print(currency);
  }

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
        create: (context) => getIt<PaymentCubit>()..fetchPaymentModes(currency),
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
                                height: e.items!.length >= 9
                                    ? MediaQuery.of(context).size.height * 0.52
                                    : e.items!.length > 3
                                        ? MediaQuery.of(context).size.height *
                                            0.25
                                        : MediaQuery.of(context).size.height *
                                            0.12,
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
                                      onTap: () async {
                                        if (item.hasVariant != null) {
                                          print(item.name);
                                          if (item.hasVariant!) {
                                            var variant =
                                                await showVariantsDialog(
                                                    context,
                                                    item.itemVariants!);
                                            if (variant != null && mounted) {
                                              final e = PaymentMethodItem(
                                                  name: variant.name,
                                                  paymentMethod:
                                                      variant.paymentMethod,
                                                  paymentInstruction: variant
                                                      .paymentInstruction,
                                                  iconUrl: variant.iconUrl,
                                                  paymentType:
                                                      variant.paymentType);
                                              // print(e.name);
                                              // print(e.paymentMethod);
                                              // print(e.paymentInstruction);
                                              // print(e.paymentType);
                                              _redirectUserBasedOnPaymentMethod(
                                                  e, context);
                                            }
                                          } else {
                                            _redirectUserBasedOnPaymentMethod(
                                                item, context);
                                          }
                                        } else {
                                          _redirectUserBasedOnPaymentMethod(
                                              item, context);
                                        }
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
    print(e);
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
    } else if (e.name!.toLowerCase().contains("m-pesa") == true) {
      displaySnack(context, "Coming soon");
    } else if (e.name!.toLowerCase().contains("mastercard") == true) {
      displaySnack(context, "Coming soon");
    } else if (e.name!.toLowerCase().contains("visa card") == true) {
      displaySnack(context, "Coming soon");
    } else if (e.name!.toLowerCase().contains("unionpay") == true) {
      displaySnack(context, "Coming soon");
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
    } else if (e.name!.toLowerCase().contains("commercepal commission coin") ==
        true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CommercepalCoinsCheckout()));
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
    } else if (e.name!.toLowerCase().contains("ipay") == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Ipay(),
          settings: RouteSettings(
            arguments: {
              "cash_type": e.paymentType,
              "cash_type_name": e.name,
              "payment_instruction": e.paymentInstruction
            },
          ),
        ),
      );
    } else if (e.name!.toLowerCase().contains("edahab") == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const Edahab(),
              settings: RouteSettings(
                arguments: {
                  "cash_type": e.paymentType,
                  "cash_type_name": e.name,
                  "payment_instruction": e.paymentInstruction
                },
              )));
    } else {
      // print("it is e-birr");
      // print(e.itemVariants![1].name);
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

Future<ItemVariant?> showVariantsDialog(
    BuildContext context, List<ItemVariant> variants) {
  return showDialog<ItemVariant>(
    context: context,
    builder: (BuildContext context) {
      int rowCount = (variants.length / 2).ceil(); // Assuming 2 items per row
      double dialogHeight =
          (rowCount * 100.0) + 100.0; // Height per row + padding
      return AlertDialog(
        title: Text("Select a Variant"),
        content: SizedBox(
          width: double.maxFinite,
          height: dialogHeight,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: variants.length,
            itemBuilder: (context, index) {
              final variant = variants[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context, variant); // Return the variant
                },
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        variant.iconUrl ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, size: 80),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      variant.name ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Return null
            child: Text("Cancel"),
          ),
        ],
      );
    },
  );
}
