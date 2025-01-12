import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/orders/models/orders_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderScreen extends StatefulWidget {
  final String orderRef;
  const OrderScreen({super.key, required this.orderRef});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool loading = false;
  List<OrdersModel> myOrders = [];
  @override
  void initState() {
    super.initState();
    fetchActionLogs();
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
          ? const Center(child: CircularProgressIndicator())
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
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: myOrders.length,
                    itemBuilder: (context, index) {
                      final order = myOrders[index];
                      final isLast = index == 0;
                      final isFirst = index == myOrders.length - 1;

                      return IntrinsicHeight(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                order.actionTimestamp,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isLast
                                        ? AppColors.colorPrimary
                                        : Colors.grey[300],
                                    border: Border.all(
                                      color: isLast
                                          ? AppColors.colorPrimary
                                          : Colors.grey[300]!,
                                      width: 3,
                                    ),
                                  ),
                                ),
                                if (!isFirst)
                                  Container(
                                    width: 2,
                                    height: 50,
                                    color: Colors.grey[300],
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: isLast
                                      ? Colors.blue.withOpacity(0.1)
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order.actionDescription,
                                      style: TextStyle(
                                        fontWeight: isLast
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isLast
                                            ? AppColors.colorPrimary
                                            : Colors.black87,
                                      ),
                                    ),
                                    // if (order.actionDescription != null) ...[
                                    //   const SizedBox(height: 4),
                                    //   Text(
                                    //     order.actionDescription!,
                                    //     style: TextStyle(
                                    //       color: Colors.grey[600],
                                    //       fontSize: 13,
                                    //     ),
                                    //   ),
                                    // ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
}
