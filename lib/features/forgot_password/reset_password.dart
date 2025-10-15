import 'dart:convert';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/features/login/presentation/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:commercepal/app/utils/logger.dart';

class ResetPassword extends StatefulWidget {
  final String jwttoken;
  final String email;
  const ResetPassword({Key? key, required this.jwttoken, required this.email})
      : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? password;
  String? cpassword;
  var loading = false;
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
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("New Password")],
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
                        "Password",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Password is required';
                        }

                        // Password complexity requirements
                        String pattern =
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                        RegExp regex = new RegExp(pattern);

                        if (!regex.hasMatch(value!)) {
                          return '''Password must contain at least 
                                    one uppercase letter, 
                                    one lowercase letter, 
                                    one digit, 
                                    one special character, 
                                    and be at least 8 characters''';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          password = value;
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
                        hintText: "Enter your new password",
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                      child: Text(
                        "Confirm Password",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'Confirm password is required';
                        }

                        if (value != password) {
                          return 'Passwords do not match';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          cpassword = null;
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
                        hintText: "Re-enter your new password",
                      ),
                      keyboardType: TextInputType.visiblePassword,
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
                                      bool done = await sendPassword();
                                      if (done) {
                                        // ignore: use_build_context_synchronously
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => LoginPage(
                                                    fromCart: false)));
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

  Future<bool> sendPassword({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      Map<String, dynamic> payload = {
        "email": widget.email,
        "password": password.toString(),
      };
      appLog(payload);

      final response = await http.post(
        Uri.https(
          "api.commercepal.com:2096",
          "/prime/api/v1/reset-password",
        ),
        body: jsonEncode(payload),
        headers: <String, String>{"Authorization": "Bearer ${widget.jwttoken}"},
      );

      var data = jsonDecode(response.body);
      appLog(data);

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
          await sendPassword(retryCount: retryCount + 1);
        } else {
          // Retry limit reached, handle accordingly
          setState(() {
            loading = false;
          });
          return false;
        }
        return false;
      }
    } catch (e) {
      appLog(e.toString());
      setState(() {
        loading = false;
      });
      // Handle other exceptions
      return false;
    }
  }
}
