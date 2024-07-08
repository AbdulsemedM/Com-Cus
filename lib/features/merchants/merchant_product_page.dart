import 'dart:convert';

import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/features/merchants/merchant_detail_pages/about_merchant.dart';
import 'package:commercepal/features/merchants/merchant_detail_pages/products.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MerchantProducPage extends StatefulWidget {
  final String id;
  const MerchantProducPage({super.key, required this.id});

  @override
  State<MerchantProducPage> createState() => _MerchantProducPageState();
}

class MerchantProds {
  final String productId;
  final String productName;
  final String mobileThumbnail;
  final String actualPrice;
  final String minOrder;
  final String maxOrder;
  final String isOnFlashSale;
  final String unique_id;
  final String discountDescription;
  final String productRating;
  final String subProductId;
  MerchantProds(
      {required this.minOrder,
      required this.maxOrder,
      required this.isOnFlashSale,
      required this.unique_id,
      required this.productId,
      required this.productName,
      required this.mobileThumbnail,
      required this.discountDescription,
      required this.productRating,
      required this.subProductId,
      required this.actualPrice});
}

class MerchantProf {
  final String merchantName;
  final String businessPhoneNumber;
  final String cityName;
  final String shopImage;
  final String physicalAddress;
  MerchantProf(
      {required this.merchantName,
      required this.businessPhoneNumber,
      required this.cityName,
      required this.physicalAddress,
      required this.shopImage});
}

class _MerchantProducPageState extends State<MerchantProducPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<MerchantProds> myMerchantProducts = [];
  MerchantProf? myMerchant;
  int _selectedIndex = 0;
  var loading = false;
  final List<Tab> _tabs = const [
    Tab(text: "Products"),
    Tab(text: "About"),
  ];
  List<Widget> _pages = [];
  // final List<Widget> _pages = [
  //   MerchantProducts(
  //     id: widget.id,
  //   ),
  //   AboutMerchant(),
  // ];
  @override
  void initState() {
    super.initState();
    fetchProducts();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    _pages = [
      MerchantProducts(
        id: widget.id,
        products: loading ? [] : myMerchantProducts,
      ),
      AboutMerchant(
        id: widget.id,
      ),
    ];
  }

  void _handleTabSelection() {
    setState(() {
      _selectedIndex = _tabController!.index; // Update selected index variable
    });
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Items"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              indicatorColor: AppColors.colorPrimaryDark,
              labelColor: AppColors.colorPrimaryDark,
              controller: _tabController,
              tabs: _tabs,
            ),
            SizedBox(
              height: sHeight * 0.85,
              child: TabBarView(
                controller: _tabController,
                children: _pages,
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> fetchProducts() async {
    try {
      setState(() {
        loading = true;
      });
      final response = await http.get(
        Uri.https(
          "api.commercepal.com:2096",
          "/prime/api/v1/merchant/${widget.id}/products",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('hererererer');
      var datas = jsonDecode(response.body);
      print(datas);
      if (datas['statusCode'] == "000") {
        print("hereare");
        setState(() {
          for (var i in datas['data']['products']) {
            myMerchantProducts.add(MerchantProds(
              productId: i['ProductId'].toString(),
              subProductId: i['subProductId'].toString(),
              minOrder: i['minOrder'].toString(),
              maxOrder: i['maxOrder'].toString(),
              isOnFlashSale: i['isOnFlashSale'].toString(),
              productName: i['productName'].toString(),
              unique_id: i['unique_id'].toString(),
              mobileThumbnail: i['mobileImage'].toString(),
              actualPrice: i['actualPrice'].toString(),
              discountDescription: i['discountDescription'].toString(),
              productRating: i['productRating'].toString(),
            ));
            // if (myOrders.isEmpty) {
            //   throw 'No special orders found';
          }
        });
        print(myMerchantProducts.length);
        setState(() {
          myMerchant = MerchantProf(
              merchantName: datas['data']['merchantAbout']['merchantName'],
              businessPhoneNumber: datas['data']['merchantAbout']
                  ['businessPhoneNumber'],
              cityName: datas['data']['merchantAbout']['cityName'],
              physicalAddress: datas['data']['merchantAbout']
                  ['physicalAddress'],
              shopImage: datas['data']['merchantAbout']['shopImage']);
        });
        print(myMerchant!.merchantName);
        setState(() {
          loading = false;
        });
      } else {
        throw datas['statusDescription'] ?? 'Error fetching special orders';
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
