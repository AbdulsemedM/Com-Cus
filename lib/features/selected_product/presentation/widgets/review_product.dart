import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/selected_product/presentation/widgets/product_review_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:commercepal/app/utils/logger.dart';

class ReviewProduct extends StatefulWidget {
  final String pId;
  const ReviewProduct({required this.pId, super.key});

  @override
  State<ReviewProduct> createState() => _ReviewProductState();
}

class ProductReview {
  final String? title;
  final String? userImage;
  final String? name;
  final num? rating;
  final String? description;
  final String? date;

  ProductReview({
    required this.title,
    required this.userImage,
    required this.name,
    required this.rating,
    required this.description,
    required this.date,
  });
}

class _ReviewProductState extends State<ReviewProduct> {
  var loading = false;
  List<ProductReview> myReviews = [];
  @override
  void initState() {
    super.initState();
    fetchProductReview();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
            childCount: myReviews.length,
            (context, index) => ProductReviewItemWidget(
                  title: myReviews[index].title,
                  name: myReviews[index].name,
                  userImage: myReviews[index].userImage,
                  description: myReviews[index].description,
                  date: myReviews[index].date,
                  rating: myReviews[index].rating,
                )));
  }

  Future<void> fetchProductReview() async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      appLog(isUserLoggedIn);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.get(
          Uri.https(
            "api.commercepal.com:2096",
            "/prime/api/v1/product-reviews/by-product/${widget.pId}",
          ),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        appLog('hererererer');
        var datas = jsonDecode(response.body);
        appLog(datas);
        if (datas['statusCode'] == "000") {
          for (var i in datas['data']) {
            myReviews.add(ProductReview(
              title: i['helpfulCount'].toString(),
              userImage: i['imageUrl'] ?? '',
              description: i['content'] ?? '',
              name: i['customerName'] ?? '',
              rating: i['rating'] ?? '',
              date: i['createdAt'] ?? '',
            ));
          }
          // if (myOrders.isEmpty) {
          //   throw 'No special orders found';
          // }
          appLog("Here we go");
          appLog(myReviews.length);
        } else {
          throw datas['statusDescription'] ?? 'Error fetching special orders';
        }
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      appLog(e.toString());
      rethrow;
    }
  }
}
