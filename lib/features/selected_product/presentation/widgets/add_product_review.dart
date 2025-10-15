import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:commercepal/app/utils/logger.dart';

class AddProductReview extends StatefulWidget {
  final String pId;
  const AddProductReview({required this.pId, super.key});

  @override
  State<AddProductReview> createState() => _AddProductReviewState();
}

class _AddProductReviewState extends State<AddProductReview> {
  var sent = false;
  var loading = false;
  double ratings = 2.5;
  late Future<String> tTitle;
  late Future<String> tSubTitle;
  late Future<String> tPost;
  TextEditingController description = TextEditingController();
  @override
  void initState() {
    super.initState();
    tTitle = TranslationService.translate("Add your product review here");
    tSubTitle = TranslationService.translate("Describe your experience");
    tPost = TranslationService.translate("Post");
  }

  @override
  Widget build(BuildContext context) {
    return sent
        ? Container()
        : Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<String>(
                  future: tTitle, // Translate hint
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                          "..."); // Show loading indicator for hint
                    } else if (snapshot.hasError) {
                      return Text('Add your product review here',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18)); // Show error for hint
                    } else {
                      return Text(
                          snapshot.data ?? 'Add your product review here',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18)); // Display translated hint
                    }
                  },
                ),
                // Text(
                //   "Add your product review here",
                //   style: TextStyle(color: Colors.black, fontSize: 18),
                // ),
                SizedBox(
                  height: 10,
                ),
                RatingBar.builder(
                    initialRating: 2.5,
                    minRating: 1,
                    allowHalfRating: true,
                    direction: Axis.horizontal,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        ratings = rating;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Form(
                      child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: FutureBuilder<String>(
                          future: tSubTitle, // Translate hint
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text(
                                  "..."); // Show loading indicator for hint
                            } else if (snapshot.hasError) {
                              return Text(
                                  'Describe your experience'); // Show error for hint
                            } else {
                              return Text(snapshot.data ??
                                  'Describe your experience'); // Display translated hint
                            }
                          },
                        ),
                        // Text("Describe your experience"),
                      ),
                      TextFormField(
                        controller: description,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        maxLines: 2,
                        keyboardType: TextInputType.text,
                        // onChanged: (value) {
                        //   setState(() {
                        //     description = value;
                        //   });
                        // },
                        // validator: (value) {
                        //   if (value?.isEmpty == true) {
                        //     return 'Description is required';
                        //   }
                        //   // else if (!isValidEmail(value!)) {
                        //   //   return 'Please enter a valid email';
                        //   // }
                        //   return null;
                        // },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      loading
                          ? CircularProgressIndicator(
                              color: AppColors.colorPrimaryDark,
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.colorPrimaryDark),
                                onPressed: () async {
                                  bool done = await sendData();
                                  if (done) {
                                    displaySnack(context,
                                        "Review and rating placed successfully.");
                                    setState(() {
                                      sent = true;
                                    });
                                  } else {
                                    displaySnack(context,
                                        "Something went wrong, please try again");
                                  }
                                },
                                child: FutureBuilder<String>(
                                  future: tPost, // Translate hint
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text(
                                          "..."); // Show loading indicator for hint
                                    } else if (snapshot.hasError) {
                                      return Text('Post',
                                          style: TextStyle(
                                              color: AppColors
                                                  .bgColor)); // Show error for hint
                                    } else {
                                      return Text(snapshot.data ?? 'Post',
                                          style: TextStyle(
                                              color: AppColors
                                                  .bgColor)); // Display translated hint
                                    }
                                  },
                                ),
                                // Text(
                                //   'Post',
                                //   style: TextStyle(color: AppColors.bgColor),
                                // )
                              ))
                    ],
                  )),
                )
              ],
            ),
          );
  }

  Future<bool> sendData({int retryCount = 0}) async {
    try {
      appLog('here we go again...');
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      appLog(isUserLoggedIn);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        Map<String, dynamic> payload = {
          "rating": ratings,
          "productId": widget.pId,
          "content": description.text,
          "imageUrl": "http//imageUrl", //optional
          "videoUrl": "http//videoUrl" //optional
        };
        appLog(payload);

        final response = await http.post(
          Uri.https(
            "api.commercepal.com:2096",
            "/prime/api/v1/product-reviews/add",
          ),
          body: jsonEncode(payload),
          headers: <String, String>{"Authorization": "Bearer $token"},
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
            await sendData(retryCount: retryCount + 1);
          } else {
            // Retry limit reached, handle accordingly
            setState(() {
              loading = false;
            });
            return false;
          }
        }
        return false;
      } else {
        displaySnack(context, "Please login first to review products");
      }
      return false;
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
