import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/app/utils/string_utils.dart';
import 'package:commercepal/core/widgets/app_button.dart';
import 'package:commercepal/core/widgets/commercepal_app_bar.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/input_decorations.dart';
import '../../dashboard/dashboard_page.dart';
import '../../redirected_payment/presentation/redirection_dialog_box.dart';
import 'bloc/otp_payment_cubit.dart';
import 'bloc/otp_payment_state.dart';

class OtpPaymentPage extends StatefulWidget {
  static const routeName = "/otp_page";

  const OtpPaymentPage({Key? key}) : super(key: key);

  @override
  State<OtpPaymentPage> createState() => _OtpPaymentPageState();
}

class _OtpPaymentPageState extends State<OtpPaymentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _phoneNumber;
  String _paymentType = "";
  String? _otp;
  bool _displayOtp = false;
  List<String> _paymentInstructions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args['payment_instruction'] != null) {
      _paymentInstructions =
          (args['payment_instruction'] as String).convertStringToList('data');
      setState(() {});
    }
    if (args['cash_type'] != null) {
      _paymentType = args['cash_type'];
      setState(() {});
    }
  }

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
        "Phone Number", GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    pHint = await physicalAddressHintFuture;

    print(pHint);

    setState(() {
      loading = false;
    });
  }

  var physicalAddressHintFuture;
  String pHint = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildCommerceAppBar(context, "$_paymentType Pay", null, false),
      body: BlocProvider(
        create: (context) => getIt<OtpPaymentCubit>(),
        child: BlocConsumer<OtpPaymentCubit, OtpPaymentState>(
          listener: (ctx, state) {
            if (state is OtpPaymentStateError) {
              displaySnack(ctx, state.message);
            }

            if (state is OtpPaymentStateOtp) {
              setState(() {
                _displayOtp = true;
              });
            }
            if (state is OtpPaymentStateRedirect) {
              _showCustomDialog(context, _paymentType, _phoneNumber);
              // Navigator.pop(context);
            }
            if (state is OtpPaymentStateSuccess) {
              displaySnack(context, state.message);

              Navigator.of(context).pushNamedAndRemoveUntil(
                  DashboardPage.routeName, (Route<dynamic> route) => false);
            }
          },
          builder: (ctx, state) {
            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.sizeOf(context).height * 1.10,
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildPaymentInstructions(),
                      if (_paymentInstructions.isNotEmpty) Divider(),
                      FutureBuilder<String>(
                        future: Translations.translatedText(
                            'Enter your phone number below',
                            GlobalStrings.getGlobalString()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                                "Loading..."); // Loading indicator while translating
                          } else if (snapshot.hasError) {
                            return Text('Enter your phone number below');
                          } else {
                            return Text(
                              snapshot.data ?? 'Enter your phone number below',
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      loading
                          ? Container()
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
                      if (_displayOtp) _buildOtpWidget(),
                      AppButtonWidget(
                        isLoading: state is OtpPaymentStateLoading,
                        onClick: () {
                          if (_formKey.currentState?.validate() == true) {
                            FocusManager.instance.primaryFocus?.unfocus();

                            ctx.read<OtpPaymentCubit>().submitRequest(
                                _phoneNumber, _otp, _paymentType);
                          }
                        },
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
        FutureBuilder<String>(
          future: Translations.translatedText(
              'Enter OTP sent to the above phone number',
              GlobalStrings.getGlobalString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading..."); // Loading indicator while translating
            } else if (snapshot.hasError) {
              return Text('Enter OTP sent to the above phone number');
            } else {
              return Text(
                snapshot.data ?? 'Enter OTP sent to the above phone number',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: AppColors.secondaryTextColor),
              );
            }
          },
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
      return Container(
        padding: const EdgeInsets.all(10),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Instructions",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _paymentInstructions
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

void _showCustomDialog(BuildContext context, String? cashType, String? phone) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(cashType: cashType!, phone: phone);
    },
  );
}
