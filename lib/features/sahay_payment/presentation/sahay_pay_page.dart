import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/app/utils/string_utils.dart';
import 'package:commercepal/core/widgets/app_button.dart';
import 'package:commercepal/core/widgets/commercepal_app_bar.dart';
import 'package:commercepal/features/sahay_payment/presentation/bloc/sahay_payment_cubit.dart';
import 'package:commercepal/features/sahay_payment/presentation/bloc/sahay_payment_state.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/input_decorations.dart';
import '../../dashboard/dashboard_page.dart';
import 'package:commercepal/app/utils/logger.dart';

class SahayPayPage extends StatefulWidget {
  static const routeName = "/sahay_page";

  const SahayPayPage({Key? key}) : super(key: key);

  @override
  State<SahayPayPage> createState() => _SahayPayPageState();
}

class _SahayPayPageState extends State<SahayPayPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _phoneNumber;
  String? _otp;
  String? _displayConfirmation;
  bool _displayOtp = false;
  List<String> _paymentInstructions = [];
  List<String> _paymentInstructionsT = [];

  void instr(List<String> trr) async {
    appLog("funcallled");
    for (var e in trr) {
      addAddHint =
          await Translations.translatedText(e, GlobalStrings.getGlobalString());
      appLog("funtranslated");
      aHint = await addAddHint;
      appLog(aHint);
      setState(() {
        _paymentInstructionsT.add(addAddHint);
      });
    }
    // appLog(_paymentInstructionsT);
    // _paymentInstructionsT.add(aHint);
  }

  void fetchHints() async {
    setState(() {
      loading = true;
    });

    physicalAddressHintFuture = Translations.translatedText(
        "Phone Number", GlobalStrings.getGlobalString());
    subcityHint = Translations.translatedText(
        "Payment Instructions", GlobalStrings.getGlobalString());
    enterHint = Translations.translatedText(
        "Enter your phone number below", GlobalStrings.getGlobalString());
    nameHint = Translations.translatedText(
        "Account Holder", GlobalStrings.getGlobalString());
    secondHint = Translations.translatedText(
        "Enter OTP sent to the above phone number",
        GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    pHint = await physicalAddressHintFuture;
    cHint = await subcityHint;
    bHint = await enterHint;
    dHint = await nameHint;
    eHint = await secondHint;
    // aHint =  _paymentInstructionsT;
    appLog("herrerererere");
    appLog(pHint);
    appLog(cHint);
    appLog(aHint);

    setState(() {
      loading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args['payment_instruction'] != null) {
      _paymentInstructions =
          (args['payment_instruction'] as String).convertStringToList('data');
      instr(_paymentInstructions);

      setState(() {});
    }
  }

  var loading = false;
  @override
  void initState() {
    super.initState();
    fetchHints();
  }

  var physicalAddressHintFuture;
  var subcityHint;
  var addAddHint;
  var enterHint;
  var nameHint;
  var secondHint;
  String pHint = '';
  String cHint = '';
  String aHint = '';
  String bHint = '';
  String dHint = '';
  String eHint = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildCommerceAppBar(context, "Sahay Pay", null, false),
      body: BlocProvider(
        create: (context) => getIt<SahayPaymentCubit>(),
        child: BlocConsumer<SahayPaymentCubit, SahayPaymentState>(
          listener: (ctx, state) {
            if (state is SahayPaymentStateError) {
              displaySnack(ctx, state.message);
            }

            if (state is SahayPaymentStateConfirmation) {
              setState(() {
                _displayConfirmation = state.name;
              });
            }

            // Skip OTP display since we're going directly to payment checkout
            // if (state is SahayPaymentStateOtp) {
            //   setState(() {
            //     _displayOtp = true;
            //   });
            // }

            if (state is SahayPaymentStateSuccess) {
              displaySnack(context, "Order placed seccessfully");

              Navigator.of(context).pushNamedAndRemoveUntil(
                  DashboardPage.routeName, (Route<dynamic> route) => false);
            }
          },
          builder: (ctx, state) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildPaymentInstructions(),
                    if (_paymentInstructions.isNotEmpty) Divider(),
                    Text(bHint),
                    const SizedBox(
                      height: 10,
                    ),
                    loading
                        ? const Text('Loading...')
                        : TextFormField(
                            keyboardType: TextInputType.phone,
                            validator: (v) {
                              if (v?.isEmpty == true) {
                                return "Phone number is required";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              setState(() {
                                _phoneNumber = value;
                              });
                            },
                            decoration: buildInputDecoration(pHint),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_displayConfirmation != null)
                      _buildConfirmationWidget(_displayConfirmation!),
                    // OTP widget removed since we skip OTP verification
                    // if (_displayOtp) _buildOtpWidget(),
                    AppButtonWidget(
                        isLoading: state is SahayPaymentStateLoading,
                        onClick: () {
                          if (_formKey.currentState?.validate() == true) {
                            FocusManager.instance.primaryFocus?.unfocus();

                            ctx
                                .read<SahayPaymentCubit>()
                                .submitRequest(_phoneNumber, null);
                          }
                        })
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildConfirmationWidget(String name) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                AppColors.colorPrimary.withOpacity(0.1),
                AppColors.colorPrimary.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.colorPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account Holder Confirmed',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: AppColors.colorPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ready to proceed with payment',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.secondaryTextColor,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.colorPrimary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dHint,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.secondaryTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.colorPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        const Divider(),
        const SizedBox(
          height: 5,
        ),
        Text(
          eHint,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: AppColors.secondaryTextColor),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v?.isEmpty == true) {
              return "OTP is required";
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            setState(() {
              _otp = value;
            });
          },
          decoration: buildInputDecoration("OTP"),
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget _buildPaymentInstructions() {
    if (_paymentInstructions.isNotEmpty) {
      // final trr = Translations.translatedText(
      //     'Payment Instruction', GlobalStrings.getGlobalString());
      // final trrr = _paymentInstructions.map((e) =>
      //     Translations.translatedText('- $e', GlobalStrings.getGlobalString()));
      appLog("mytransssss");
      appLog(_paymentInstructionsT);
      return Container(
        padding: const EdgeInsets.all(10),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(cHint),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _paymentInstructionsT
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("- $e"),
                      ))
                  .toList(),
            ),
            const Divider(),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
