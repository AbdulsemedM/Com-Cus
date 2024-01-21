import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/core/widgets/commercepal_app_bar.dart';
import 'package:commercepal/features/dashboard/widgets/home_error_widget.dart';
import 'package:commercepal/features/dashboard/widgets/home_loading_widget.dart';
import 'package:commercepal/features/order_tracking/presentation/order_tracking_page.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:commercepal/features/user_orders/data/models/user_orders_dto.dart';
import 'package:commercepal/features/user_orders/presentation/bloc/user_orders_bloc.dart';
import 'package:commercepal/features/user_orders/presentation/bloc/user_orders_state.dart';
import 'package:commercepal/features/user_orders/presentation/widgets/user_order_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserOrdersPage extends StatefulWidget {
  static const routeName = "/user_orders";

  const UserOrdersPage({Key? key}) : super(key: key);

  @override
  _UserOrdersPageState createState() => _UserOrdersPageState();
}

class _UserOrdersPageState extends State<UserOrdersPage> {
  late final UserOrdersBloc _userOrdersBloc;

  @override
  void initState() {
    _userOrdersBloc = getIt<UserOrdersBloc>()..fetchOrders();
    super.initState();
    fetchHints();
  }

  void fetchHints() async {
    setState(() {
      loading = true;
    });

    subcityHint = Translations.translatedText(
        "My Orders", GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    cHint = await subcityHint;
    print("herrerererere");
    print(cHint);

    setState(() {
      loading = false;
    });
  }

  var subcityHint;
  String cHint = '';
  var loading = false;

  @override
  void dispose() {
    _userOrdersBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildCommerceAppBar(context, cHint, null, false),
      body: BlocProvider(
        create: (context) => _userOrdersBloc,
        child: BlocBuilder<UserOrdersBloc, UserOrdersState>(
          builder: (ctx, state) {
            return state.maybeWhen(
              orElse: () => const HomeLoadingWidget(),
              error: (msg) => HomeErrorWidget(error: msg),
              orders: (orders) {
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (ctx, index) {
                    final order = orders[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          OrderTrackingPage.routeName,
                          arguments: {
                            "order_id": orders[index].orderId,
                            "order_ref": orders[index].orderRef,
                          },
                        );
                      },
                      child: UserOrderItemWidget(order: order),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
