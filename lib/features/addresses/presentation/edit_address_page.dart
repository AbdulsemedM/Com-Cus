import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/addresses-core/data/dto/addresses_dto.dart';
import 'package:commercepal/features/addresses/presentation/bloc/address_state.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/cities-core/presentation/select_city_widget.dart';
import '../../../core/cities-core/presentation/select_country_widget.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/input_decorations.dart';
import 'bloc/address_cubit.dart';

class EditAddressPage extends StatefulWidget {
  static const routeName = "/edit_address_page";

  const EditAddressPage({Key? key}) : super(key: key);

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
        "Physical address", GlobalStrings.getGlobalString());
    subcityHint = Translations.translatedText(
        "Sub city", GlobalStrings.getGlobalString());
    addAddHint = Translations.translatedText(
        "Add Address", GlobalStrings.getGlobalString());
    EditAddress = Translations.translatedText(
        "Edit Address", GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    pHint = await physicalAddressHintFuture;
    cHint = await subcityHint;
    aHint = await addAddHint;
    eAddr = await EditAddress;
    print("herrerererere");
    print(pHint);
    print(cHint);

    setState(() {
      loading = false;
    });
  }

  String? _subCity;
  String? _physicalAddress;

  String? _countryName;
  num? _cityId;
  num? _countryId;
  var physicalAddressHintFuture;
  var subcityHint;
  var addAddHint;
  var EditAddress;
  String pHint = '';
  String cHint = '';
  String aHint = '';
  String eAddr = '';

  AddressItem? _addressItem;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _addressItem = ModalRoute.of(context)?.settings.arguments as AddressItem;
    _subCity = _addressItem?.subCity;
    _physicalAddress = _addressItem?.physicalAddress;
    _countryName = _addressItem?.country;
    _cityId = _addressItem?.cityId;
    _countryId = _addressItem?.regionId;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: loading
            ? const Text("Loading...")
            : Text(
                eAddr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
      ),
      body: BlocProvider(
        create: (context) => getIt<AddressCubit>(),
        child: BlocConsumer<AddressCubit, AddressState>(
          listener: (ctx, state) {
            if (state is AddressStateError) {
              displaySnack(ctx, state.error);
            }

            if (state is AddressStateSuccess) {
              displaySnack(ctx, state.msg);
              Navigator.pop(context);
            }
          },
          builder: (ctx, state) {
            return Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: ListView(
                  children: [
                    SelectCountryWidget(
                      initialValue: _addressItem?.country,
                      selectedCountry: (countryName) {
                        _countryName = countryName;
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SelectCityWidget(
                      initialValue: _addressItem?.city,
                      selectedCity: (cityId, countryId) {
                        _cityId = cityId;
                        _countryId = countryId;
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    loading
                        ? Container()
                        : TextFormField(
                            initialValue: _addressItem?.subCity,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v?.isEmpty == true) {
                                return "Sub city is required";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              setState(() {
                                _subCity = value;
                              });
                            },
                            decoration: buildInputDecoration(cHint)),
                    const SizedBox(
                      height: 20,
                    ),
                    loading
                        ? Container()
                        : TextFormField(
                            initialValue: _addressItem?.physicalAddress,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v?.isEmpty == true) {
                                return "Physical address is required";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              setState(() {
                                _physicalAddress = value;
                              });
                            },
                            decoration: buildInputDecoration(pHint)),
                    const SizedBox(
                      height: 20,
                    ),
                    AppButtonWidget(
                        text: "Update",
                        isLoading: state is AddressStateLoading,
                        onClick: () {
                          if (_formKey.currentState!.validate()) {
                            ctx.read<AddressCubit>().updateAddress(
                                _addressItem!.addressId!,
                                _subCity!,
                                _physicalAddress!,
                                _cityId,
                                _countryId,
                                _countryName);
                          }
                        }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
