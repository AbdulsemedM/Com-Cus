import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/app/utils/string_utils.dart';
import 'package:commercepal/core/widgets/commercepal_app_bar.dart';
import 'package:commercepal/features/cash_payment/presentation/bloc/cash_payment_cubit.dart';
import 'package:commercepal/features/cash_payment/presentation/bloc/cash_payment_state.dart';
import 'package:commercepal/features/dashboard/dashboard_page.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_picker/country_picker.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/input_decorations.dart';

class CashPaymentPage extends StatefulWidget {
  static const routeName = "/cash_payment";

  const CashPaymentPage({Key? key}) : super(key: key);

  @override
  State<CashPaymentPage> createState() => _CashPaymentPageState();
}

class _CashPaymentPageState extends State<CashPaymentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _phoneNumber;
  String? _cashType;
  String? _cashTypeName;
  bool _validatePayment = false;
  List<String> _instructions = [];
  List<String> _paymentInstructionsT = [];

  Country selectedCountry = Country(
    phoneCode: "251",
    countryCode: "ET",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Ethiopia",
    example: "912345678",
    displayName: "Ethiopia (ET) [+251]",
    displayNameNoCountryCode: "Ethiopia (ET)",
    e164Key: "",
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map args = ModalRoute.of(context)?.settings.arguments as Map;
    _cashType = args['cash_type'];
    _cashTypeName = args['cash_type_name'];
    if (args['payment_instruction'] != null) {
      _instructions =
          (args['payment_instruction'] as String).convertStringToList('data');
      instr(_instructions);
      setState(() {});
    }
  }

  var loading = false;
  @override
  void initState() {
    super.initState();
    fetchHints();
  }

  void instr(List<String> trr) async {
    // print("funcallled");
    for (var e in trr) {
      addAddHint =
          await Translations.translatedText(e, GlobalStrings.getGlobalString());
      // print("funtranslated");
      aHint = await addAddHint;
      // print(aHint);
      setState(() {
        _paymentInstructionsT.add(addAddHint);
      });
    }
    // print(_paymentInstructionsT);
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
    validateHint = Translations.translatedText(
        "Finished making your hello cash payment! Press below button to complete your payment",
        GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    pHint = await physicalAddressHintFuture;
    cHint = await subcityHint;
    bHint = await enterHint;
    dHint = await validateHint;

    // print(pHint);

    setState(() {
      loading = false;
    });
  }

  var physicalAddressHintFuture;
  var subcityHint;
  var addAddHint;
  var enterHint;
  var validateHint;
  String pHint = '';
  String cHint = '';
  String aHint = '';
  String bHint = '';
  String dHint = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          buildCommerceAppBar(context, "$_cashTypeName Payment", null, false),
      body: BlocProvider(
        create: (context) => getIt<CashPaymentCubit>(),
        child: BlocConsumer<CashPaymentCubit, CashPaymentState>(
          listener: (ctx, state) {
            if (state is CashPaymentStateError) {
              displaySnack(ctx, state.message);
            }

            if (state is CashPaymentStateSuccess) {
              displaySnack(context, state.message);

              Navigator.of(context).pushNamedAndRemoveUntil(
                  DashboardPage.routeName, (Route<dynamic> route) => false);
            }

            if (state is CashPaymentStateValidateCode) {
              _validatePayment = true;
              setState(() {});
            }
          },
          builder: (ctx, state) {
            return Container(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildPaymentInstructions(),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(bHint),
                    const SizedBox(
                      height: 10,
                    ),
                    loading
                        ? const Text('Loading...')
                        :
                        // Column(
                        //     children: [
                        //       TextFormField(
                        //         keyboardType: TextInputType.phone,
                        //         enabled: !_validatePayment,
                        //         validator: (v) {
                        //           if (v?.isEmpty == true) {
                        //             return "Phone number is required";
                        //           }
                        //           return null;
                        //         },
                        //         autovalidateMode:
                        //             AutovalidateMode.onUserInteraction,
                        //         onChanged: (value) {
                        //           setState(() {
                        //             _phoneNumber =
                        //                 "+${selectedCountry.phoneCode}$value";
                        //           });
                        //         },
                        //         decoration:
                        //             buildInputDecoration(pHint).copyWith(
                        //           prefixIcon: Container(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: InkWell(
                        //               onTap: () {
                        //                 showCountryPicker(
                        //                   context: context,
                        //                   showPhoneCode: true,
                        //                   onSelect: (Country country) {
                        //                     setState(() {
                        //                       selectedCountry = country;
                        //                     });
                        //                   },
                        //                 );
                        //               },
                        //               child: Text(
                        //                 "+ ${selectedCountry.phoneCode}",
                        //                 style: const TextStyle(
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    showCountryPicker(
                                      context: context,
                                      showPhoneCode: true,
                                      favorite: ['ET', "SO", "KE"],
                                      countryListTheme: CountryListThemeData(
                                        borderRadius: BorderRadius.circular(8),
                                        inputDecoration: InputDecoration(
                                          hintText: 'Search country',
                                          filled: true,
                                          fillColor: Colors.grey[100],
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      onSelect: (Country country) {
                                        setState(() {
                                          selectedCountry = country;
                                        });
                                      },
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down,
                                          color: Colors.black87),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  validator: (v) {
                                    if (v?.isEmpty == true) {
                                      return "Phone number is required";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _phoneNumber =
                                          "+${selectedCountry.phoneCode}$value";
                                    });
                                  },
                                  decoration: buildInputDecoration(
                                      "Enter phone number"),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (!_validatePayment)
                      AppButtonWidget(
                          isLoading: state is CashPaymentStateLoading,
                          onClick: () {
                            if (_formKey.currentState?.validate() == true) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              // print(_cashType);
                              ctx
                                  .read<CashPaymentCubit>()
                                  .submitCashPayment(_phoneNumber!, _cashType!);
                            }
                          }),
                    if (_validatePayment) _buildValidatePayment(state, ctx)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPaymentInstructions() {
    if (_instructions.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cHint),
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
            )
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  _buildValidatePayment(CashPaymentState state, BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        const Divider(),
        const SizedBox(
          height: 10,
        ),
        Text(dHint),
        const SizedBox(
          height: 10,
        ),
        AppButtonWidget(
            isLoading: state is CashPaymentStateLoading,
            text: "Complete payment",
            onClick: () {
              if (_formKey.currentState?.validate() == true) {
                FocusManager.instance.primaryFocus?.unfocus();
                ctx.read<CashPaymentCubit>().validateHelloCashPayment();
              }
            }),
        const SizedBox(
          height: 6,
        ),
        Center(
          child: TextButton(
              onPressed: () {
                ctx
                    .read<CashPaymentCubit>()
                    .submitCashPayment(_phoneNumber!, _cashType!);
              },
              child: const Text(
                "Retry payment?",
                style: TextStyle(color: AppColors.colorPrimaryDark),
              )),
        )
      ],
    );
  }
}
