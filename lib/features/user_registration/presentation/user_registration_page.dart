import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/capitalizer.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/widgets/app_button.dart';
import 'package:commercepal/features/dashboard/dashboard_page.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:commercepal/features/user_registration/presentation/bloc/user_registration_cubit.dart';
import 'package:commercepal/features/user_registration/presentation/bloc/user_registration_state.dart';
import 'package:country_picker/country_picker.dart';
import 'package:country_picker/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/input_decorations.dart';
import '../../set_password/presentation/user_set_password_page.dart';

// Local copy of countryList from country_picker package
final List<Country> countryList = [
  Country(
    name: 'Afghanistan',
    countryCode: 'AF',
    phoneCode: '93',
    e164Key: '93',
    e164Sc: 93,
    geographic: true,
    level: 1,
    example: '93012345678',
    displayName: 'Afghanistan',
    displayNameNoCountryCode: 'Afghanistan',
  ),
  Country(
    name: 'Albania',
    countryCode: 'AL',
    phoneCode: '355',
    e164Key: '355',
    e164Sc: 355,
    geographic: true,
    level: 1,
    example: '3551234567',
    displayName: 'Albania',
    displayNameNoCountryCode: 'Albania',
  ),
  // ... (add all other countries as needed, or copy the full list from the package)
  Country(
    name: 'Ethiopia',
    countryCode: 'ET',
    phoneCode: '251',
    e164Key: '251',
    e164Sc: 251,
    geographic: true,
    level: 1,
    example: '251911111111',
    displayName: 'Ethiopia',
    displayNameNoCountryCode: 'Ethiopia',
  ),
  Country(
    name: 'Kenya',
    countryCode: 'KE',
    phoneCode: '254',
    e164Key: '254',
    e164Sc: 254,
    geographic: true,
    level: 1,
    example: '254712345678',
    displayName: 'Kenya',
    displayNameNoCountryCode: 'Kenya',
  ),
  Country(
    name: 'Somalia',
    countryCode: 'SO',
    phoneCode: '252',
    e164Key: '252',
    e164Sc: 252,
    geographic: true,
    level: 1,
    example: '252612345678',
    displayName: 'Somalia',
    displayNameNoCountryCode: 'Somalia',
  ),
  Country(
    name: 'United Arab Emirates',
    countryCode: 'AE',
    phoneCode: '971',
    e164Key: '971',
    e164Sc: 971,
    geographic: true,
    level: 1,
    example: '971501234567',
    displayName: 'United Arab Emirates',
    displayNameNoCountryCode: 'United Arab Emirates',
  ),
  // ... (add the rest of the countries as needed)
];

class UserRegistrationPage extends StatefulWidget {
  static const routeName = "/user_registration_page";

  const UserRegistrationPage({Key? key}) : super(key: key);

  @override
  State<UserRegistrationPage> createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // String? _countryName;
  String? _fName;
  String? _sName;
  String? _email;
  String? _phoneNumber;
  // String? _city;
  var loading = false;
  Country? _selectedCountry;
  String? _password;
  String? _confirmPassword;
  // List of preferred countries
  final List<Map<String, String>> _preferredCountries = [
    {'name': 'Ethiopia', 'code': 'ET', 'flag': '🇪🇹', 'phoneCode': '251'},
    {'name': 'Kenya', 'code': 'KE', 'flag': '🇰🇪', 'phoneCode': '254'},
    {'name': 'Somalia', 'code': 'SO', 'flag': '🇸🇴', 'phoneCode': '252'},
    {
      'name': 'United Arab Emirates',
      'code': 'AE',
      'flag': '🇦🇪',
      'phoneCode': '971'
    },
  ];

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
        "Email address", GlobalStrings.getGlobalString());

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
              // Navigator.popAndPushNamed(context, UserSetPasswordPage.routeName,
              //     arguments: {
              //       "phone": state.msg,
              //       // parsed phone number is passed as msg, probably create another state for this
              //       "email": _email
              //     });
              Navigator.pushNamedAndRemoveUntil(
                  context, DashboardPage.routeName, (route) => false);
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
                    _buildCountryDropdown(),
                    const SizedBox(height: 14),
                    _buildNamesField(),
                    const SizedBox(height: 14),
                    _buildEmailField(),
                    const SizedBox(height: 14),
                    _buildPhoneNumberField(),
                    const SizedBox(height: 14),
                    _buildPasswordField(),
                    const SizedBox(height: 14),
                    _buildConfirmPasswordField(),
                    const SizedBox(height: 20),
                    AppButtonWidget(
                        isLoading: state is UserRegistrationStateLoading,
                        onClick: () async {
                          if (_formKey.currentState?.validate() == true) {
                            // Ethiopia logic: require at least one of phone or email
                            if (_selectedCountry?.countryCode == 'ET') {
                              if ((_phoneNumber == null ||
                                      _phoneNumber!.isEmpty) &&
                                  (_email == null || _email!.isEmpty)) {
                                displaySnack(context,
                                    'Either phone number or email is required for Ethiopia');
                                return;
                              }
                            } else {
                              // Other countries: email required
                              if (_email == null || _email!.isEmpty) {
                                displaySnack(context,
                                    'Email is required for selected country');
                                return;
                              }
                            }
                            // Password validation
                            if (_password == null || _password!.isEmpty) {
                              displaySnack(context, 'Password is required');
                              return;
                            }
                            if (_confirmPassword == null ||
                                _confirmPassword!.isEmpty) {
                              displaySnack(
                                  context, 'Confirm password is required');
                              return;
                            }
                            if (_password != _confirmPassword) {
                              displaySnack(context, 'Passwords do not match');
                              return;
                            }
                            final completePhoneNumber = (_selectedCountry
                                            ?.phoneCode !=
                                        null &&
                                    _phoneNumber != null &&
                                    _phoneNumber!.isNotEmpty)
                                ? '${_selectedCountry?.phoneCode}$_phoneNumber'
                                : null;
                            // print("completePhoneNumber: $_phoneNumber");
                            // print("countryCode: ${_selectedCountry?.phoneCode}");
                            // print("selectedCountry: ${_selectedCountry?.name}");
                            // print("password: $_password");
                            // print("confirmPassword: $_confirmPassword");
                            // print("email: $_email");
                            // print("fName: $_fName");
                            // print("sName: $_sName");
                            ctx.read<UserRegistrationCubit>().createAccount(
                                _fName,
                                _sName,
                                _email,
                                _phoneNumber,
                                _selectedCountry?.countryCode,
                                "city",
                                _password,
                                _selectedCountry?.phoneCode,
                                _confirmPassword);
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

  Widget _buildCountryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Country', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        InkWell(
          onTap: () {
            showCountryPicker(
              context: context,
              showPhoneCode: true,
              favorite: ['ET', 'KE', 'SO', 'AE'],
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
              onSelect: (Country country) {
                setState(() {
                  _selectedCountry = country;
                });
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                if (_selectedCountry != null) ...[
                  Text(_selectedCountry!.flagEmoji),
                  const SizedBox(width: 8),
                  Text(_selectedCountry!.name),
                ] else ...[
                  const Text('Select country'),
                ],
                const Spacer(),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildPhoneNumberField() {
    return Row(
      children: [
        // Phone code prefix (immutable)
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              Text(_selectedCountry?.flagEmoji ?? '🏳️'),
              const SizedBox(width: 8),
              Text(_selectedCountry != null
                  ? '+${_selectedCountry!.phoneCode}'
                  : '+?'),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Phone number input field
        Expanded(
          child: TextFormField(
            enabled: _selectedCountry != null,
            keyboardType: TextInputType.phone,
            validator: (v) {
              // Phone number is only required if Ethiopia is selected and email is empty
              if (_selectedCountry?.countryCode == 'ET') {
                if ((v == null || v.isEmpty) &&
                    (_email == null || _email!.isEmpty)) {
                  return 'Phone number or email is required for Ethiopia';
                }
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              setState(() {
                _phoneNumber = value;
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
        // For Ethiopia, email is only required if phone is empty
        if (_selectedCountry?.countryCode == 'ET') {
          if ((v == null || v.isEmpty) &&
              (_phoneNumber == null || _phoneNumber!.isEmpty)) {
            return 'Email or phone number is required for Ethiopia';
          }
        } else {
          // For other countries, email is required
          if (v == null || v.isEmpty) {
            return 'Email is required for selected country';
          }
        }
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

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: true,
      validator: (v) {
        if (v == null || v.isEmpty) {
          return 'Password is required';
        }
        if (v.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _password = value;
        });
      },
      decoration: buildInputDecoration('Password'),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      obscureText: true,
      validator: (v) {
        if (v == null || v.isEmpty) {
          return 'Confirm password is required';
        }
        if (v != _password) {
          return 'Passwords do not match';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _confirmPassword = value;
        });
      },
      decoration: buildInputDecoration('Confirm Password'),
    );
  }
}
