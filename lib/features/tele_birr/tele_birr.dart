import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:image/image.dart' as img;

class TeleBirrPayment extends StatefulWidget {
  static const routeName = "/telebirr_payment";

  // final String url;
  const TeleBirrPayment({super.key});
  @override
  State<TeleBirrPayment> createState() => _TeleBirrPaymentState();
}

class _TeleBirrPaymentState extends State<TeleBirrPayment> {
  final GlobalKey<FormState> myKey = GlobalKey();
  String? pNumber;
  var loading = false;
  String? message;
  String url = '';
  final ScreenshotController screenshotController = ScreenshotController();
  late WebViewController _webViewController;
  @override
  void initState() {
    super.initState();
    fetchTelebirr();
  }

  @override
  Widget build(BuildContext context) {
    // var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Telebirr Pay",
          style: TextStyle(fontSize: sWidth * 0.05),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: sWidth,
                decoration: BoxDecoration(border: Border.all()),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Payment Instructions"),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                            Text("-Make the QR Code at the middle of the box."),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            "-Press the 'Capture Screenshot' button below."),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            "-You will get the captured QR Code in the gallery."),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            "-Go to your Telebirr app and goto 'Scan QR'."),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("-Choose your QR Code from the Gallery'."),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            !loading && url != ''
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Your app content goes here

                      const SizedBox(height: 20.0),
                      // Display captured screenshot
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Screenshot(
                            controller: screenshotController,
                            child: Container(
                              color: Colors.blue,
                              width: 250.0,
                              height: 250.0,
                              child: WebView(
                                gestureNavigationEnabled: true,
                                initialUrl: url,
                                javascriptMode: JavascriptMode.unrestricted,
                                onWebViewCreated:
                                    (WebViewController webViewController) {
                                  _webViewController = webViewController;

                                  // Enable zooming gestures using JavaScript
                                  _webViewController.evaluateJavascript('''
                                    document.querySelector('meta[name="viewport"]').content = 'width=device-width, initial-scale=1, maximum-scale=5.0, user-scalable=yes';
                                  ''');
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      // Button to trigger screenshot capture
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.colorPrimaryDark),
                        onPressed: () {
                          _captureScreenshot();
                        },
                        child: Text('Capture Screenshot'),
                      ),
                    ],
                  )
                : !loading && url == ''
                    ? Text(message!)
                    : Text("fetching")
          ],
        ),
      ),
    );
  }

  Future<void> _captureScreenshot() async {
    // Capture the screenshot
    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        // Convert Uint8List to Image
        final img.Image decodedImage = img.decodeImage(image)!;

        // Get the application documents directory
        final directory = await getApplicationDocumentsDirectory();

        // Include width and height in the file name
        final fileName =
            'screenshot_${decodedImage.width}x${decodedImage.height}.jpg';
        final filePath = '${directory.path}/$fileName';

        // Encode the image as PNG with transparency
        File(filePath).writeAsBytesSync(img.encodePng(decodedImage));

        // Save the screenshot to the gallery
        GallerySaver.saveImage(filePath, albumName: 'YourAlbumName')
            .then((result) {
          if (result != null && result) {
            print('Screenshot saved to gallery successfully!');
          } else {
            print('Failed to save screenshot to gallery.');
          }
        });
      } else {
        print('Failed to capture screenshot.');
      }
    });
  }

  Future<bool> fetchTelebirr({int retryCount = 0}) async {
    try {
      setState(() {
        loading = true;
      });
      print('hereweare');
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      print(isUserLoggedIn);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final orderRef = await prefsData.readData("order_ref");
        Map<String, dynamic> payload = {
          "ServiceCode": "CHECKOUT",
          "PaymentType": "TELE-BIRR",
          "PaymentMode": "TELE-BIRR",
          "UserType": "C",
          "OrderRef": orderRef,
          "Currency": "ETB"
        };
        print(payload);

        final response = await http.post(
          Uri.https(
            "api.commercepal.com:2095",
            "/payment/v1/request",
          ),
          body: jsonEncode(payload),
          headers: <String, String>{"Authorization": "Bearer $token"},
        );

        var data = jsonDecode(response.body);
        print(data);

        if (data['statusCode'] == '000') {
          setState(() {
            url = data['PaymentUrl'];
            message = data['statusMessage'] ?? '';
            loading = false;
          });
          return true;
        } else {
          // Retry logic
          if (retryCount < 5) {
            // Retry after num + 1 seconds
            await Future.delayed(Duration(seconds: retryCount++));
            // Call the function again with an increased retryCount
            await fetchTelebirr(retryCount: retryCount + 1);
          } else {
            // Retry limit reached, handle accordingly
            setState(() {
              message = data['statusMessage'] ?? "Please try again later";
              loading = false;
            });
            return false;
          }
        }
        return false;
      }
      return false;
    } catch (e) {
      message = e.toString();
      print(e.toString());
      setState(() {
        loading = false;
      });
      // Handle other exceptions
      return false;
    }
  }
}
