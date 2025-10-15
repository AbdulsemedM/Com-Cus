import 'dart:convert';
import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:commercepal/app/utils/logger.dart';

import '../../core/cart-core/dao/cart_dao.dart';

class TeleBirrNewPayment extends StatefulWidget {
  static const routeName = "/telebirr_new_payment";

  const TeleBirrNewPayment({super.key});

  @override
  State<TeleBirrNewPayment> createState() => _TeleBirrNewPaymentState();
}

class _TeleBirrNewPaymentState extends State<TeleBirrNewPayment> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _phoneNumberHint = '';
  String _payButtonText = '';
  String _titleText = '';
  String _instructionText = '';

  @override
  void initState() {
    super.initState();
    _fetchTranslations();
  }

  void _fetchTranslations() async {
    _phoneNumberHint = await Translations.translatedText(
        "Enter phone number", GlobalStrings.getGlobalString());
    _payButtonText = await Translations.translatedText(
        "Pay with TeleBirr", GlobalStrings.getGlobalString());
    _titleText = await Translations.translatedText(
        "TeleBirr Payment", GlobalStrings.getGlobalString());
    _instructionText = await Translations.translatedText(
        "Enter your TeleBirr phone number to initiate payment",
        GlobalStrings.getGlobalString());
    setState(() {});
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove leading 0 if present
    String cleanedNumber = value.startsWith('0') ? value.substring(1) : value;

    // Check if it's a valid Ethiopian phone number (9 digits after removing 0)
    if (cleanedNumber.length != 9) {
      return 'Please enter a valid Ethiopian phone number';
    }

    // Check if it contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanedNumber)) {
      return 'Phone number should contain only digits';
    }

    // Check if it starts with valid Ethiopian mobile prefixes
    List<String> validPrefixes = [
      '91',
      '92',
      '93',
      '94',
      '95',
      '96',
      '97',
      '98',
      '99'
    ];
    bool hasValidPrefix =
        validPrefixes.any((prefix) => cleanedNumber.startsWith(prefix));

    if (!hasValidPrefix) {
      return 'Please enter a valid Ethiopian mobile number';
    }

    return null;
  }

  String _formatPhoneNumber(String phoneNumber) {
    // Remove leading 0 if present
    String cleanedNumber =
        phoneNumber.startsWith('0') ? phoneNumber.substring(1) : phoneNumber;
    // Add Ethiopia country code
    return '251$cleanedNumber';
  }

  Future<void> _initiatePayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);

      if (!isUserLoggedIn) {
        _showErrorDialog('Please login to continue with payment');
        return;
      }

      final token = await prefsData.readData(PrefsKeys.userToken.name);
      final orderRef = await prefsData.readData("order_ref");

      String formattedPhoneNumber =
          _formatPhoneNumber(_phoneController.text.trim());

      Map<String, dynamic> payload = {
        "ServiceCode": "CHECKOUT",
        "PaymentType": "TELE-BIRR",
        "PaymentMode": "TELE-BIRR",
        "PhoneNumber": formattedPhoneNumber,
        "UserType": "C",
        "OrderRef": orderRef,
        "Currency": "ETB"
      };
      appLog(payload);

      final response = await http.post(
        Uri.https(
          "pay.commercepal.com",
          "/payment/v1/request",
        ),
        body: jsonEncode(payload),
        headers: <String, String>{
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      var data = jsonDecode(response.body);
      appLog('Payment response: $data');

      if (data['statusCode'] == '000') {
        _showSuccessDialog();
      } else {
        _showErrorDialog(data['statusMessage'] ??
            'Payment initiation failed. Please try again.');
      }
    } catch (e) {
      appLog('Payment error: $e');
      _showErrorDialog('An error occurred. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 30,
              ),
              SizedBox(width: 10),
              Text(
                'Payment Initiated!',
                style: TextStyle(
                  color: AppColors.colorPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your TeleBirr payment has been initiated successfully.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.colorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.colorPrimary.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Steps:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('• You will receive a USSD prompt on your phone'),
                    Text('• Enter your TeleBirr PIN to complete the payment'),
                    Text(
                        '• Your order will be processed once payment is confirmed'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.colorPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final cartDao = getIt<CartDao>();
                await cartDao.nuke();
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/dashboard', // Assuming this is the homepage route
                  (route) => false,
                );
              },
              child: Text(
                'Go to Home',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
                size: 30,
              ),
              SizedBox(width: 10),
              Text(
                'Payment Failed',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: AppColors.colorPrimary),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var sWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titleText.isNotEmpty ? _titleText : "TeleBirr Payment",
          style: TextStyle(fontSize: sWidth * 0.05, color: Colors.white),
        ),
        backgroundColor: AppColors.colorPrimary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
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
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/images/download.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.colorPrimary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  Icons.phone_android,
                                  size: 50,
                                  color: AppColors.colorPrimary,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        _instructionText.isNotEmpty
                            ? _instructionText
                            : "Enter your TeleBirr phone number to initiate payment",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.colorPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Phone Number Input
              Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorPrimary,
                ),
              ),
              SizedBox(height: 8),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(
                      10), // Max 10 digits (including leading 0)
                ],
                decoration: InputDecoration(
                  hintText: _phoneNumberHint.isNotEmpty
                      ? _phoneNumberHint
                      : "Enter phone number",
                  prefixIcon: Container(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      '+251',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorPrimary,
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.colorPrimary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: AppColors.colorPrimary, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                validator: _validatePhoneNumber,
              ),

              SizedBox(height: 20),

              // Helper Text
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You can enter your number with or without the leading 0',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40),

              // Pay Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colorPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                  ),
                  onPressed: _isLoading ? null : _initiatePayment,
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Processing...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          _payButtonText.isNotEmpty
                              ? _payButtonText
                              : "Pay with TeleBirr",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
