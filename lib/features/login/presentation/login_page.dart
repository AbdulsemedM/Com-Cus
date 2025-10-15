import 'dart:async';
import 'dart:convert';
// import 'dart:convert';
import 'dart:io';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/assets.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/core/widgets/app_button.dart';
// import 'package:commercepal/features/check_out/presentation/check_out_page.dart';
import 'package:commercepal/features/affiliate_register/presentation/affiliate_register_page.dart';
import 'package:commercepal/features/dashboard/dashboard_page.dart';
import 'package:commercepal/features/forgot_password/forgot_password.dart';
import 'package:commercepal/features/login/data/social_media_login.dart';
import 'package:commercepal/features/login/presentation/bloc/login_cubit.dart';
import 'package:commercepal/features/login/presentation/bloc/login_state.dart';
import 'package:commercepal/features/login/provide_phoneNumber_dialog.dart/provide_phoneNumber.dart';
import 'package:commercepal/features/push_notification/push_notification.dart';
// import 'package:commercepal/features/reset_password/presentation/reset_pass_page.dart';
import 'package:commercepal/features/set_password/presentation/user_set_password_page.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translation_api.dart';
// import 'package:commercepal/features/translation/translation_widget.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:commercepal/features/user_registration/presentation/user_registration_page.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../app/utils/app_colors.dart';
import '../../../core/widgets/input_decorations.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:commercepal/app/utils/logger.dart';
// import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  static const routeName = "/login";
  final bool fromCart;

  const LoginPage({Key? key, required this.fromCart}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ]);

  // final _googleSignIn = GoogleSignIn();
// var googleAccount = GoogleSignInAccount();
  // GoogleSignInAccount? _currentUser;
  String? name;

  String? _emailOrPhone;
  String? _pass;
  String deviceId = 'Unknown';
  String deviceToken = "";

  var loading = false;

  // Add this variable to track the login mode
  bool isPhoneMode = true;
  Country selectedCountry = Country(
    phoneCode: "251",
    countryCode: "ET",
    e164Sc: 251,
    geographic: true,
    level: 1,
    name: "Ethiopia",
    example: "912345678",
    displayName: "Ethiopia (ET) [+251]",
    displayNameNoCountryCode: "Ethiopia (ET)",
    e164Key: "251-ET-0",
  );

  @override
  void initState() {
    super.initState();
    initializePushNotification();

    // _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
    //   setState(() {
    //     _currentUser = account;
    //   });
    // });
    // _googleSignIn.signInSilently();
    appLog("initState _fromCart: ${widget.fromCart}");
    fetchHints();
    _handleSignOut();
    logOutFromFacebook();
  }

  void sendDeviceToken() async {
    try {
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      appLog(isUserLoggedIn);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.post(
          Uri.https(
            "api.commercepal.com:2096",
            "/prime/api/v1/device-tokens/register",
          ),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"deviceToken": deviceToken}),
        );
        var datas = jsonDecode(response.body);
        appLog('hererererer is the token');
        appLog(datas);
        // if (datas['statusCode'] == "000") {}
      }
    } catch (e) {
      appLog(e.toString());
    }
  }

  initializePushNotification() async {
    appLog("initializePushNotification");
    if (Platform.isAndroid) {
      PushNotificationService pushNotificationService =
          PushNotificationService();
      String? token =
          await pushNotificationService.generateDeviceRecognitionToken();
      pushNotificationService.startListeningForNewNotifications(context);
      // const storage = FlutterSecureStorage();
      // storage.read(key: 'fcmToken').then((value) {
      appLog('FCM Token from dashboard: $token');
      deviceToken = token ?? "";
      // BlocProvider.of<DashboardBloc>(context).add(SendFcmTokenEvent(token!));
      // });
    } else {
      // Firebase.initializeApp();
      await NotificationManager().requestPermissions();
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        appLog("APNS Token: $apnsToken");
      } else {
        appLog("APNS token not available.");
      }
      // Proceed to get FCM token
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      appLog("FCM Token: $fcmToken");
      deviceToken = fcmToken ?? "";
      // FirebaseMessaging.instance.requestPermission();
      // FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;
      // String? deviceToken = await _firebaseMessage.getToken();
      // appLog("deviceToken from dashboard: $deviceToken");
    }
  }

  Future<void> signInWithFacebook() async {
    await FacebookAuth.instance.logOut();
    final LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile']);

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    appLog("facebookAuthCredential");
    appLog(facebookAuthCredential);
    var userData = await FacebookAuth.instance.getUserData();
    appLog("hereistheemail");
    final String firstName = userData['name'] ?? "";
    // final String lastName = userData['last_name'];
    final String email = userData['email'] ?? "";
    final String id = userData['id'] ?? "";
    appLog(firstName);
    // appLog(lastName);
    appLog(email);
    appLog(id);
    var channel = Platform.isIOS ? "IOS" : "ANDROID";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId;
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id; // Unique ID on Android
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor!; // Unique ID on iOS
    } else {
      deviceId = 'Unsupported platform';
    }
    setState(() {
      deviceId = id;
    });
    _emailOrPhone = userData['email'];
    await getUserToken(
        channel,
        "FACEBOOK",
        userData['id'],
        userData['email'],
        userData['name']?.split(' ')[0] ?? "",
        userData['name']?.split(' ')[1] ?? '',
        deviceId);
    // return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.disconnect();
  }

  Future<void> logOutFromFacebook() async {
    await FacebookAuth.instance.logOut();
  }

  Future<void> _handleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        appLog('User is signed in!');
        appLog('Display Name: ${account.photoUrl}');
        var channel = Platform.isIOS ? "IOS" : "ANDROID";
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        String id;
        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          id = androidInfo.id; // Unique ID on Android
        } else if (Platform.isIOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          id = iosInfo.identifierForVendor!; // Unique ID on iOS
        } else {
          id = 'Unsupported platform';
        }
        setState(() {
          deviceId = id;
        });
        _emailOrPhone = account.email;
        await getUserToken(
            channel,
            "GOOGLE",
            account.id,
            account.email,
            account.displayName?.split(' ')[0] ?? "",
            account.displayName?.split(' ')[1] ?? '',
            deviceId);
      }
    } catch (error) {
      appLog('Error signing in: $error');
    }
  }

  // Future<void> _handleSignIn() async {
  //   try {
  //     await _googleSignIn.signIn();
  //     if (_googleSignIn.currentUser != null) {
  //       setState(() {
  //         name = _currentUser!.displayName;
  //       });
  //       appLog('User is signed in!');
  //       appLog('Display Name: ${_googleSignIn.currentUser!.displayName}');
  //       // Here you can use the display name as needed, e.g., update UI
  //     }
  //   } catch (error) {
  //     appLog('Error signing in: $error');
  //   }
  // }
  // Future<void> _handleSignIn() async {
  //   try {
  //     _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
  //       setState(() {
  //         _currentUser = account;
  //       });
  //     });
  //     appLog("Signed in");
  //     // appLog(_currentUser!.displayName);
  //     await _googleSignIn.signIn();
  //     appLog("Signed in");
  //   } catch (error) {
  //     appLog("here is the error");
  //     appLog(error);
  //   }
  // }

  void fetchHints() async {
    setState(() {
      loading = true;
    });

    physicalAddressHintFuture = Translations.translatedText(
        "Password", GlobalStrings.getGlobalString());
    subcityHint = Translations.translatedText(
        "Email or Phone Number", GlobalStrings.getGlobalString());
    addAddHint = Translations.translatedText(
        "Forgot password", GlobalStrings.getGlobalString());
    LoginHint = Translations.translatedText(
        "Login to continue", GlobalStrings.getGlobalString());
    cAccountHint = Translations.translatedText(
        "Create Account", GlobalStrings.getGlobalString());

    pHint = await physicalAddressHintFuture;
    cHint = await subcityHint;
    aHint = await addAddHint;
    lHint = await LoginHint;
    caHint = await cAccountHint;
    appLog("herrerererere");
    appLog(pHint);
    appLog(cHint);

    setState(() {
      loading = false;
    });
  }

  var physicalAddressHintFuture;
  var subcityHint;
  var addAddHint;
  var LoginHint;
  var cAccountHint;
  String caHint = '';
  String pHint = '';
  String lHint = '';
  String cHint = '';
  String aHint = '';
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => getIt<LoginCubit>(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (ctx, state) {
            if (state is LoginStateError) {
              displaySnack(context, state.message);
            }

            if (state is LoginStateSuccess) {
              if (widget.fromCart) {
                if (deviceToken != "") {
                  sendDeviceToken();
                }
                Navigator.pushNamedAndRemoveUntil(
                    context, DashboardPage.routeName, (route) => false,
                    arguments: {"redirect_to": "cart"});
              } else {
                if (deviceToken != "") {
                  sendDeviceToken();
                }
                Navigator.pushNamedAndRemoveUntil(
                    context, DashboardPage.routeName, (route) => false);
              }
            }

            if (state is LoginStateSetPin) {
              if (deviceToken != "") {
                sendDeviceToken();
              }
              Navigator.pushNamed(context, UserSetPasswordPage.routeName,
                  arguments: {"phone": state.phoneNumber, "code": _pass});
            }
            if (state is LoginStateprovidePhone) {
              if (deviceToken != "") {
                sendDeviceToken();
              }
              showDialog(
                  context: context,
                  builder: (context) {
                    return ProvidePhoneNumberDialog(
                      provide: state.provide,
                    );
                  });
              // if (result != null) {
              //   Navigator.pushNamedAndRemoveUntil(
              //       context, DashboardPage.routeName, (route) => false);
              // }
            }
          },
          builder: (ctx, state) {
            return SafeArea(
              child: SingleChildScrollView(
                  child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        Assets.appIcon,
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.18,
                      ),
                      Text(
                        lHint,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Add segmented button for phone/email selection
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SegmentedButton<bool>(
                              segments: const [
                                ButtonSegment(
                                    value: true, label: Text('Phone')),
                                ButtonSegment(
                                    value: false, label: Text('Email')),
                              ],
                              selected: {isPhoneMode},
                              onSelectionChanged: (Set<bool> newSelection) {
                                setState(() {
                                  isPhoneMode = newSelection.first;
                                  _emailOrPhone = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Replace the existing TextFormField with conditional rendering
                      if (isPhoneMode)
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
                                    _emailOrPhone = value;
                                  });
                                },
                                decoration:
                                    buildInputDecoration("Enter phone number"),
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ],
                        )
                      else
                        TextFormField(
                          validator: (v) {
                            if (v?.isEmpty == true) {
                              return "Email is required";
                            }
                            final emailRegExp =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegExp.hasMatch(v!)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _emailOrPhone = value;
                            });
                          },
                          decoration:
                              buildInputDecoration("Enter email address"),
                          keyboardType: TextInputType.emailAddress,
                        ),

                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        obscureText: obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (v) {
                          if (v?.isEmpty == true) {
                            return "Password is required";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          setState(() {
                            _pass = value;
                          });
                        },
                        // decoration: buildInputDecoration(pHint),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: AppColors.fieldBorder.withOpacity(0.8),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: pHint,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassword()));
                            },
                            child:
                                //  loading
                                //     ? const Text("Loading...")
                                //     :
                                FutureBuilder<String>(
                              future: TranslationService.translate(
                                  "Forgot Password"), // Translate hint
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text(
                                      "..."); // Show loading indicator for hint
                                } else if (snapshot.hasError) {
                                  return Text('Forgot Password',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: AppColors
                                                  .secondaryTextColor)); // Show error for hint
                                } else {
                                  return Text(
                                      snapshot.data ?? 'Forgot Password',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: AppColors
                                                  .secondaryTextColor)); // Display translated hint
                                }
                              },
                            ),
                            // Text(
                            //   "Forgot Password",
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .bodyMedium
                            //       ?.copyWith(
                            //           color: AppColors.secondaryTextColor),
                            // ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AppButtonWidget(
                          isLoading: state is LoginStateLoading,
                          onClick: () {
                            if (_formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              if (_emailOrPhone!.startsWith("0")) {
                                _emailOrPhone = _emailOrPhone!.substring(1);
                              }

                              ctx.read<LoginCubit>().loginUser(
                                  isPhoneMode
                                      ? selectedCountry.phoneCode +
                                          _emailOrPhone!
                                      : _emailOrPhone!,
                                  _pass!);
                              // appLog("loginUser");
                              // appLog(isPhoneMode
                              //     ? selectedCountry.phoneCode + _emailOrPhone!
                              //     : _emailOrPhone!);
                            }
                          }),
                      Padding(
                        padding: EdgeInsets.all(6.0),
                        child: FutureBuilder<String>(
                          future: TranslationService.translate(
                              "or sign in with"), // Translate hint
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text(
                                  "..."); // Show loading indicator for hint
                            } else if (snapshot.hasError) {
                              return Text(
                                  'or sign in with'); // Show error for hint
                            } else {
                              return Text(snapshot.data ??
                                  'or sign in with'); // Display translated hint
                            }
                          },
                        ),
                        // Text("or sign in with"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await _handleSignIn(context);
                              ctx
                                  .read<LoginCubit>()
                                  .loginUser(_emailOrPhone!, "social media");
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.15,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Image(
                                  image: AssetImage(
                                "assets/images/google.png",
                              )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await signInWithFacebook();
                              ctx
                                  .read<LoginCubit>()
                                  .loginUser(_emailOrPhone!, "social media");
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.15,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Image(
                                  fit: BoxFit.contain,
                                  height: 60,
                                  width: 50,
                                  image: AssetImage(
                                    "assets/images/facebook.png",
                                  )),
                            ),
                          ),
                          // Container(
                          //   height: MediaQuery.of(context).size.height * 0.06,
                          //   width: MediaQuery.of(context).size.width * 0.15,
                          //   decoration: BoxDecoration(
                          //       color: Colors.grey[200],
                          //       borderRadius: BorderRadius.circular(10)),
                          //   child: const Image(
                          //       image: AssetImage(
                          //     "assets/images/twitter.png",
                          //   )),
                          // ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, UserRegistrationPage.routeName);
                          },
                          child:
                              // loading
                              //     ? Text('Loading...')
                              //     :

                              FutureBuilder<String>(
                            future: TranslationService.translate(
                                "Create Account"), // Translate hint
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text(
                                    "..."); // Show loading indicator for hint
                              } else if (snapshot.hasError) {
                                return Text('Create Account',
                                    style: const TextStyle(
                                      color: AppColors.colorPrimaryDark,
                                      decoration: TextDecoration.underline,
                                    )); // Show error for hint
                              } else {
                                return Text(snapshot.data ?? 'Create Account',
                                    style: const TextStyle(
                                      color: AppColors.colorPrimaryDark,
                                      decoration: TextDecoration.underline,
                                    )); // Display translated hint
                              }
                            },
                          ),
                          // Text(
                          //   "Create Account",
                          //   style: const TextStyle(
                          //     color: AppColors.colorPrimaryDark,
                          //     decoration: TextDecoration.underline,
                          //   ),
                          // ),
                        ),
                      ),
                      // Creative NEW Badge positioned above affiliate button
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Affiliate Registration Button with Creative Design
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15.0, top: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF8B1538), // Primary color
                                    Color(0xFFB91C47), // Lighter shade
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF8B1538)
                                        .withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: () async {
                                    final result = await Navigator.pushNamed(
                                      context,
                                      AffiliateRegisterPage.routeName,
                                    );
                                    // If registration was successful, show success message
                                    if (result == true) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Affiliate registration successful! Please login with your credentials.'),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                      vertical: 16.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Twinkling star icon
                                        TwinklingIcon(
                                          icon: Icons.star,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),

                                        // Main text
                                        FutureBuilder<String>(
                                          future: TranslationService.translate(
                                              "Become Affiliate Partner"),
                                          builder: (context, snapshot) {
                                            return Text(
                                              snapshot.data ??
                                                  "Become Affiliate Partner",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
                                              ),
                                            );
                                          },
                                        ),

                                        const SizedBox(width: 12),

                                        // Arrow icon with subtle animation
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Creative "NEW" Badge positioned at top-right corner
                          Positioned(
                            top: 0,
                            right: 20,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF6B35), // Vibrant orange
                                    Color(0xFFFF8E53), // Lighter orange
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF6B35)
                                        .withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Sparkle icon
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: TwinklingIcon(
                                      icon: Icons.auto_awesome,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),

                                  // NEW text with pulsing animation
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 6.0,
                                    ),
                                    child: PulsingBadge(
                                      text: "NEW",
                                    ),
                                  ),

                                  // Fire icon
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: TwinklingIcon(
                                      icon: Icons.local_fire_department,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
            );
          },
        ),
      ),
    );
  }
}

class NotificationManager {
  Future<void> requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }
}

// Custom Twinkling Icon Widget
class TwinklingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const TwinklingIcon({
    Key? key,
    required this.icon,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  _TwinklingIconState createState() => _TwinklingIconState();
}

class _TwinklingIconState extends State<TwinklingIcon>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Icon(
            widget.icon,
            color: widget.color,
            size: widget.size,
          ),
        );
      },
    );
  }
}

// Custom Pulsing Badge Widget
class PulsingBadge extends StatefulWidget {
  final String text;

  const PulsingBadge({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  _PulsingBadgeState createState() => _PulsingBadgeState();
}

class _PulsingBadgeState extends State<PulsingBadge>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFD700), // Gold
                    Color(0xFFFFA500), // Orange
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.6),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
