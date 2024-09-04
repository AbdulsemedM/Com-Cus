import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/features/commercepal_coins/tabs/coin_transfer.dart';
import 'package:commercepal/features/commercepal_coins/tabs/mobile_topup.dart';
import 'package:flutter/material.dart';

class WithdrawCoinsPage extends StatefulWidget {
  const WithdrawCoinsPage({super.key});

  @override
  State<WithdrawCoinsPage> createState() => _WithdrawCoinsPageState();
}

class _WithdrawCoinsPageState extends State<WithdrawCoinsPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _selectedIndex = 0; // Variable to store the selected index
  final List<Tab> _tabs = const [
    Tab(text: "Transfer Coins"),
    Tab(text: "Mobile Topup"),
    // Tab(text: "Social funds"),
    // Tab(text: "Penalty payments"),
    // Tab(text: "Penalties"),
  ];
  final List<Widget> _pages = const [
    CoinTransfer(),
    MobileTopup(),
    // SocialFundsPayment(),
    // PenaltyPayment(),
    // PaidPenalties()
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController!.addListener(
        _handleTabSelection); // Add listener to handle tab selection
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
          title: const Text("Withdraw CommercePal coins",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17))),
      body: SingleChildScrollView(
          child: SafeArea(
              child: Column(
        children: [
          Center(
            child: TabBar(
              isScrollable: true,
              indicatorColor: AppColors.colorPrimaryDark,
              labelColor: AppColors.colorPrimaryDark,
              controller: _tabController,
              tabs: _tabs,
            ),
          ),
          SizedBox(
            height: sHeight * 0.85,
            child: TabBarView(
              controller: _tabController,
              children: _pages,
            ),
          ),
        ],
      ))),
    );
  }
}
