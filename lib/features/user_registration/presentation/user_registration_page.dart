import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/capitalizer.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/cities-core/presentation/select_city_widget.dart';
import 'package:commercepal/core/widgets/app_button.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:commercepal/features/user_registration/presentation/bloc/user_registration_cubit.dart';
import 'package:commercepal/features/user_registration/presentation/bloc/user_registration_state.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/cities-core/presentation/select_country_widget.dart';
import '../../../core/widgets/input_decorations.dart';
import '../../set_password/presentation/user_set_password_page.dart';

class UserRegistrationPage extends StatefulWidget {
  static const routeName = "/user_registration_page";

  const UserRegistrationPage({Key? key}) : super(key: key);

  @override
  State<UserRegistrationPage> createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _countryName;
  String? _fName;
  String? _sName;
  String? _email;
  String? _phoneNumber;
  String? _city;
  var loading = false;
  Country? _selectedCountry;

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
        "Creat Account", GlobalStrings.getGlobalString());
    subcityHint = Translations.translatedText(
        "First name", GlobalStrings.getGlobalString());
    addAddHint = Translations.translatedText(
        "Last name", GlobalStrings.getGlobalString());
    phoneHint = Translations.translatedText(
        "Phone number", GlobalStrings.getGlobalString());
    emailHint = Translations.translatedText(
        "Email address (Optional)", GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    pHint = await physicalAddressHintFuture;
    cHint = await subcityHint;
    aHint = await addAddHint;
    dHint = await phoneHint;
    eHint = await emailHint;
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
  var phoneHint;
  var emailHint;
  String pHint = '';
  String cHint = '';
  String aHint = '';
  String dHint = '';
  String eHint = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: loading
            ? const Text("Loading...")
            : Text(
                pHint,
                style: Theme.of(context).textTheme.titleMedium,
              ),
      ),
      body: BlocProvider(
        create: (context) => getIt<UserRegistrationCubit>(),
        child: BlocConsumer<UserRegistrationCubit, UserRegistrationState>(
          listener: (ctx, state) {
            if (state is UserRegistrationStateError) {
              displaySnack(context, state.msg);
            }

            if (state is UserRegistrationStateSuccess) {
              Navigator.popAndPushNamed(context, UserSetPasswordPage.routeName,
                  arguments: {
                    "phone": state.msg,
                    // parsed phone number is passed as msg, probably create another state for this
                    "email": _email
                  });
            }
          },
          builder: (ctx, state) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _buildNamesField(),
                    const SizedBox(
                      height: 14,
                    ),
                    _buildEmailField(),
                    const SizedBox(
                      height: 14,
                    ),
                    _buildPhoneNumberField(),
                    const SizedBox(
                      height: 14,
                    ),
                    SelectCountryWidget(
                      selectedCountry: (countryName) {
                        _countryName = countryName;
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SelectCityWidget(
                      selectedCity: (cityId, countryId) {
                        _city = "$cityId";

                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppButtonWidget(
                        isLoading: state is UserRegistrationStateLoading,
                        onClick: () {
                          if (_formKey.currentState?.validate() == true) {
                            ctx.read<UserRegistrationCubit>().createAccount(
                                _fName,
                                _sName,
                                _email,
                                _phoneNumber,
                                _countryName,
                                _city);
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

  _buildNamesField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            inputFormatters: [CapitalizeEachWordInputFormatter()],
            keyboardType: TextInputType.text,
            validator: (v) {
              if (v?.isEmpty == true) {
                return "First name is required";
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              setState(() {
                _fName = value;
              });
            },
            decoration: buildInputDecoration(loading ? "Loading..." : cHint),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextFormField(
            inputFormatters: [CapitalizeEachWordInputFormatter()],
            keyboardType: TextInputType.text,
            validator: (v) {
              if (v?.isEmpty == true) {
                return "Last name is required";
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              setState(() {
                _sName = value;
              });
            },
            decoration: buildInputDecoration(loading ? "Loading..." : aHint),
          ),
        ),
      ],
    );
  }

  _buildPhoneNumberField() {
    return Row(
      children: [
        // Country selector
        Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () {
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                searchAutofocus: true,
                onSelect: (Country country) {
                  // print("country: ${country.}");
                  setState(() {
                    _selectedCountry = country;
                  });
                },
                countryListTheme: CountryListThemeData(
                  flagSize: 25,
                  backgroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16),
                  bottomSheetHeight: 500,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  inputDecoration: InputDecoration(
                    labelText: 'Search',
                    hintText: 'Start typing to search',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFF8C98A8).withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_selectedCountry != null) ...[
                    Text(_selectedCountry!.flagEmoji),
                    const SizedBox(width: 8),
                    Text('+${_selectedCountry!.phoneCode}'),
                  ] else
                    const Text('🏳️ +?'),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Phone number input field
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.phone,
            validator: (v) {
              if (v?.isEmpty == true) {
                return "Phone number is required";
              }
              if (_selectedCountry == null) {
                return "Please select country";
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              setState(() {
                _phoneNumber = value;
                final completePhoneNumber =
                    '${_selectedCountry?.phoneCode}$_phoneNumber';
                print("completePhoneNumber: $completePhoneNumber");
              });
            },
            decoration: buildInputDecoration(loading ? "Loading..." : dHint),
          ),
        ),
      ],
    );
  }

  // _buildPhoneNumberField() {
  //   return TextFormField(
  //     keyboardType: TextInputType.phone,
  //     validator: (v) {
  //       if (v?.isEmpty == true) {
  //         return "Phone number is required";
  //       }
  //       return null;
  //     },
  //     autovalidateMode: AutovalidateMode.onUserInteraction,
  //     onChanged: (value) {
  //       setState(() {
  //         _phoneNumber = value;
  //       });
  //     },
  //     decoration: buildInputDecoration(loading ? "Loading..." : dHint),
  //   );
  // }

  _buildEmailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (v) {
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        setState(() {
          _email = value;
        });
      },
      decoration: buildInputDecoration(loading ? "Loading..." : eHint),
    );
  }
}
