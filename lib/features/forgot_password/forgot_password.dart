import 'dart:convert';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/features/forgot_password/verify_otp.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? emailAddress;
  var loading = false;
  String message = '';
  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: sHeight * 0.25,
              child:
                  const Image(image: AssetImage("assets/images/app_icon.png")),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Forgot Password")],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                      child: Text(
                        "Email",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Email is required';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          emailAddress = value;
                        });
                      },
                      // title: "Password",
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        hintText: "Enter your email or phone number",
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: loading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.colorPrimaryDark),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      var regExp1 = RegExp(r'^0\d{9}$');
                                      var regExp2 = RegExp(r'^\+251\d{9}$');
                                      if (regExp1.hasMatch(emailAddress!)) {
                                        emailAddress = emailAddress!
                                            .replaceFirst(RegExp('^0'), '251');
                                        print(emailAddress);
                                      } else if (regExp2
                                          .hasMatch(emailAddress!)) {
                                        emailAddress = emailAddress!
                                            .replaceFirst(RegExp(r'^\+'), '');
                                        print(emailAddress);
                                      }
                                      bool done = await sendEmail();
                                      if (done) {
                                        // ignore: use_build_context_synchronously
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => VerifyOTP(
                                                      userName: emailAddress!,
                                                    )));
                                      } else {
                                        displaySnack(context, message);
                                      }
                                    }
                                  },
                                  child: Text("Submit")),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Future<bool> sendEmail({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      Map<String, dynamic> payload = {
        "user": emailAddress.toString(),
      };
      print(payload);

      final response = await http.post(
        Uri.https(
          "api.commercepal.com:2096",
          "/prime/api/v1/password-type-reset",
        ),
        body: jsonEncode(payload),
        // headers: <String, String>{"Authorization": "Bearer $token"},
      );

      var data = jsonDecode(response.body);
      print(data);

      if (data['statusCode'] == '000') {
        setState(() {
          loading = false;
        });
        return true;
        // Handle the case when statusCode is '000'
      } else {
        // Retry logic
        if (retryCount < 5) {
          // Retry after num + 1 seconds
          await Future.delayed(Duration(seconds: retryCount++));
          // Call the function again with an increased retryCount
          await sendEmail(retryCount: retryCount + 1);
        } else {
          // Retry limit reached, handle accordingly
          setState(() {
            message = data['statusMessage'];
            loading = false;
          });
          return false;
        }
        return false;
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
      // Handle other exceptions
      return false;
    }
  }
}
