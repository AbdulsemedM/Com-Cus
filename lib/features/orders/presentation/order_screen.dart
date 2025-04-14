import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/orders/models/order_timeline_model.dart';
import 'package:commercepal/features/orders/models/orders_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class OrderScreen extends StatefulWidget {
  final String orderRef;
  const OrderScreen({super.key, required this.orderRef});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool loading = true;
  List<OrdersModel> myOrders = [];
  List<OrderTimelineModel> myOrderTimeline = [];
  @override
  void initState() {
    super.initState();
    fetchActionLogs();
    fetchTimeline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Tracking',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
      ),
      body: loading
          ? buildShimmer()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Ref: ${widget.orderRef}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: buildTimeline(),
                  ),
                  const SizedBox(height: 20),
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   itemCount: myOrders.length,
                  //   itemBuilder: (context, index) {
                  //     final order = myOrders[index];
                  //     final isLast = index == 0;
                  //     final isFirst = index == myOrders.length - 1;

                  //     return IntrinsicHeight(
                  //       child: Row(
                  //         children: [
                  //           SizedBox(
                  //             width: 100,
                  //             child: Text(
                  //               order.actionTimestamp ?? '',
                  //               style: TextStyle(
                  //                 color: Colors.grey[600],
                  //                 fontSize: 13,
                  //               ),
                  //             ),
                  //           ),
                  //           Column(
                  //             children: [
                  //               Container(
                  //                 width: 20,
                  //                 height: 20,
                  //                 decoration: BoxDecoration(
                  //                   shape: BoxShape.circle,
                  //                   color: isLast
                  //                       ? AppColors.colorPrimary
                  //                       : Colors.grey[300],
                  //                   border: Border.all(
                  //                     color: isLast
                  //                         ? AppColors.colorPrimary
                  //                         : Colors.grey[300]!,
                  //                     width: 3,
                  //                   ),
                  //                 ),
                  //               ),
                  //               if (!isFirst)
                  //                 Container(
                  //                   width: 2,
                  //                   height: 50,
                  //                   color: Colors.grey[300],
                  //                 ),
                  //             ],
                  //           ),
                  //           const SizedBox(width: 12),
                  //           Expanded(
                  //             child: Container(
                  //               padding: const EdgeInsets.all(16),
                  //               margin: const EdgeInsets.only(bottom: 8),
                  //               decoration: BoxDecoration(
                  //                 color: isLast
                  //                     ? Colors.blue.withOpacity(0.1)
                  //                     : Colors.grey[100],
                  //                 borderRadius: BorderRadius.circular(8),
                  //               ),
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text(
                  //                     order.actionDescription ?? '',
                  //                     style: TextStyle(
                  //                       fontWeight: isLast
                  //                           ? FontWeight.bold
                  //                           : FontWeight.normal,
                  //                       color: isLast
                  //                           ? AppColors.colorPrimary
                  //                           : Colors.black87,
                  //                     ),
                  //                   ),
                  //                   // if (order.actionDescription != null) ...[
                  //                   //   const SizedBox(height: 4),
                  //                   //   Text(
                  //                   //     order.actionDescription!,
                  //                   //     style: TextStyle(
                  //                   //       color: Colors.grey[600],
                  //                   //       fontSize: 13,
                  //                   //     ),
                  //                   //   ),
                  //                   // ],
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
    );
  }

  Future<void> fetchActionLogs() async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      print(isUserLoggedIn);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.get(
          Uri.https(
            "api.commercepal.com",
            "/prime/api/v1/customer/order/action-logs",
            {
              "orderRef": widget.orderRef,
            },
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token",
          },
        );
        print('hererererer');
        var datas = jsonDecode(response.body);
        print(datas);
        if (datas['statusCode'] == '000') {
          for (var i in datas['responseData']) {
            myOrders.add(OrdersModel.fromMap(i));

            // if (myOrders.isEmpty) {
            //   throw 'No special orders found';
          }
          print("MyOrders");
          print(myOrders.length);
        } else {
          throw datas['statusDescription'] ?? 'Error fetching markups';
        }
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> fetchTimeline() async {
    try {
      setState(() {
        loading = true;
      });

      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      print(isUserLoggedIn);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.get(
          Uri.https(
            "api.commercepal.com",
            "/prime/api/v1/customer/order/timeline",
            {
              "orderRef": widget.orderRef,
            },
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer $token",
          },
        );
        print('hererererer');
        var datas = jsonDecode(response.body);
        print(datas);
        if (datas['statusCode'] == '000') {
          for (var i in datas['responseData']) {
            myOrderTimeline.add(OrderTimelineModel.fromMap(i));

            // if (myOrders.isEmpty) {
            //   throw 'No special orders found';
          }
          print("MyOrderTimeline");
          print(myOrderTimeline.length);
        } else {
          throw datas['statusDescription'] ?? 'Error fetching markups';
        }
      }

      // Fetch timeline data here
      // Example data
      // myOrderTimeline = [
      //   OrderTimelineModel(
      //       stage: "Ordered",
      //       status: "Completed",
      //       timestamp: "4/10/2025, 9:39:15 AM"),
      //   OrderTimelineModel(
      //       stage: "Payment Confirmed",
      //       status: "Completed",
      //       timestamp: "4/10/2025, 9:39:27 AM"),
      //   OrderTimelineModel(
      //       stage: "Processing",
      //       status: "Completed",
      //       timestamp: "4/11/2025, 3:45:33 PM"),
      //   OrderTimelineModel(
      //       stage: "Shipped",
      //       status: "Completed",
      //       timestamp: "4/11/2025, 3:45:58 PM"),
      //   OrderTimelineModel(
      //       stage: "Out for Delivery",
      //       status: "Pending",
      //       timestamp: "Not completed yet"),
      //   OrderTimelineModel(
      //       stage: "Delivered",
      //       status: "Pending",
      //       timestamp: "Not completed yet"),
      // ];

      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  Widget buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(backgroundColor: Colors.white),
            title: Container(height: 10, color: Colors.white),
            subtitle: Container(height: 10, color: Colors.white),
          );
        },
      ),
    );
  }

  Widget buildTimeline() {
    return ListView.builder(
      itemCount: myOrderTimeline.length,
      itemBuilder: (context, index) {
        final stage = myOrderTimeline[index];
        final isCompleted = stage.status == "Completed";

        return (stage.stage == "Returned" && stage.status == "Pending") ||
                (stage.stage == "Canceled" && stage.status == "Pending")
            ? Container()
            : ListTile(
                leading: Icon(
                  isCompleted
                      ? Icons.check_circle
                      : getIconForStage(stage.stage),
                  color: isCompleted ? Colors.green : Colors.grey,
                ),
                title: Text(
                  stage.stage!,
                  style: TextStyle(
                    color: isCompleted ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(stage.timestamp != "N/A"
                    ? stage.timestamp!
                    : "Not completed yet"),
              );
      },
    );
  }

  IconData getIconForStage(String? stage) {
    switch (stage) {
      case "Ordered":
        return Icons.shopping_cart;
      case "Payment Confirmed":
        return Icons.credit_card;
      case "Processing":
        return Icons.build;
      case "Shipped":
        return Icons.local_shipping;
      case "Out for Delivery":
        return Icons.directions_bike;
      case "Delivered":
        return Icons.check_circle;
      case "Canceled/Returned":
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String getShortNameForStage(String? stage) {
    switch (stage) {
      case "Ordered":
        return "Ordered";
      case "Payment Confirmed":
        return "Paid";
      case "Processing":
        return "Processing";
      case "Shipped":
        return "Shipped";
      case "Out for Delivery":
        return "Out for Delivery";
      case "Delivered":
        return "Delivered";
      case "Canceled/Returned":
        return "Returned";
      default:
        return "Unknown";
    }
  }
}
