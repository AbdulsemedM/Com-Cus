import 'dart:io';

import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/features/special_order/presentantion/bloc/special_order_state.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/input_decorations.dart';
import '../bloc/special_order_cubit.dart';

class SpecialOrderForm extends StatefulWidget {
  const SpecialOrderForm({Key? key}) : super(key: key);

  @override
  State<SpecialOrderForm> createState() => _SpecialOrderFormState();
}

class _SpecialOrderFormState extends State<SpecialOrderForm> {
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
        "Name of product", GlobalStrings.getGlobalString());
    subcityHint = Translations.translatedText(
        "Product Price", GlobalStrings.getGlobalString());
    addAddHint = Translations.translatedText(
        "Link to product", GlobalStrings.getGlobalString());
    productHint = Translations.translatedText(
        "Product Description", GlobalStrings.getGlobalString());
    totalHint = Translations.translatedText(
        "Pick Image", GlobalStrings.getGlobalString());
    shippmentHint = Translations.translatedText(
        "Shipmment Status", GlobalStrings.getGlobalString());
    proccessingHint = Translations.translatedText(
        "Proccessing on Warehouse", GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    pHint = await physicalAddressHintFuture;
    cHint = await subcityHint;
    aHint = await addAddHint;
    prHint = await productHint;
    tHint = await totalHint;
    sHint = await shippmentHint;
    prHint = await proccessingHint;
    print("herrerererere");
    print(pHint);
    print(cHint);

    setState(() {
      loading = false;
    });
  }

  var physicalAddressHintFuture;
  var subcityHint;
  var addAddHint;
  var productHint;
  var totalHint;
  var shippmentHint;
  var proccessingHint;
  String pHint = '';
  String cHint = '';
  String aHint = '';
  String prHint = '';
  String tHint = '';
  String sHint = '';
  String pwHint = '';
  var loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ImagePicker? _imagePicker = ImagePicker();
  XFile? _image;

  String? _pName;
  String? _pDescription;
  String? _amount;
  String? _linkToProduct;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SpecialOrderCubit>(),
      child: BlocConsumer<SpecialOrderCubit, SpecialOrderState>(
        listener: (ctx, state) {
          if (state is SpecialOrderStateError) {
            displaySnack(ctx, state.msg);
          }

          if (state is SpecialOrderStateSuccess) {
            displaySnack(ctx, state.msg);
            Navigator.pop(ctx);
          }
        },
        builder: (ctx, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    loading
                        ? const Text("Loading...")
                        : TextFormField(
                            validator: (v) {
                              if (v?.isEmpty == true) {
                                return "Name is required";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              setState(() {
                                _pName = value;
                              });
                            },
                            decoration: buildInputDecoration(pHint),
                          ),
                    const SizedBox(
                      height: 16,
                    ),
                    loading
                        ? const Text("Loading...")
                        : TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v?.isEmpty == true) {
                                return "Price of product is required";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              setState(() {
                                _amount = value;
                              });
                            },
                            decoration: buildInputDecoration(cHint),
                          ),
                    const SizedBox(
                      height: 16,
                    ),
                    loading
                        ? const Text("Loading...")
                        : TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v?.isEmpty == true) {
                                return "Link to product is required";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              setState(() {
                                _linkToProduct = value;
                              });
                            },
                            decoration: buildInputDecoration(aHint),
                          ),
                    const SizedBox(
                      height: 16,
                    ),
                    loading
                        ? const Text("Loading...")
                        : TextFormField(
                            validator: (v) {
                              if (v?.isEmpty == true) {
                                return "Product description is required";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              setState(() {
                                _pDescription = value;
                              });
                            },
                            decoration: buildInputDecoration(prHint),
                          ),
                    const SizedBox(
                      height: 16,
                    ),
                    loading
                        ? Text(
                            "Loading...",
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        : Text(
                            tHint,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                    const SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      onTap: () async {
                        _image = await _imagePicker?.pickImage(
                            source: ImageSource.gallery);
                        setState(() {});
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            color: _image == null
                                ? Colors.grey.withOpacity(0.2)
                                : Colors.transparent),
                        child: _image == null
                            ? const Icon(Icons.add_a_photo_outlined)
                            : Image.file(
                                File(_image!.path),
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppButtonWidget(
                        isLoading: state is SpecialOrderStateLoading,
                        onClick: () async {
                          if (_formKey.currentState?.validate() == true) {
                            FocusScope.of(context).unfocus();

                            ctx.read<SpecialOrderCubit>().specialOrder(
                                _image == null ? null : File(_image!.path), {
                              "ProductName": _pName,
                              "Description": _pDescription,
                              "EstimatePrice": _amount,
                              "LinkToProduct": _linkToProduct
                            });
                          }
                        }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
