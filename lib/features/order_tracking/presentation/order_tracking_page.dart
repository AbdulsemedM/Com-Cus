import 'package:another_stepper/another_stepper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:commercepal/app/app.dart';
import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/assets.dart';
import 'package:commercepal/features/dashboard/widgets/home_error_widget.dart';
import 'package:commercepal/features/dashboard/widgets/home_loading_widget.dart';
import 'package:commercepal/features/order_tracking/presentation/bloc/order_tracking_cubit.dart';
import 'package:commercepal/features/order_tracking/presentation/bloc/order_tracking_state.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderTrackingPage extends StatefulWidget {
  static const routeName = "/order_tracking_page";

  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  late final OrderTrackingCubit _orderTrackingCubit;
  late num orderId;
  late String orderRef;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map args = ModalRoute.of(context)?.settings.arguments as Map;
    orderId = args['order_id'];
    orderRef = args['order_ref'];
    _orderTrackingCubit = getIt<OrderTrackingCubit>()
      ..fetchTrackingData(orderId);
  }

  @override
  void dispose() {
    _orderTrackingCubit.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchHints();
  }

  void fetchHints() async {
    setState(() {
      loading = true;
    });

    physicalAddressHintFuture =
        Translations.translatedText("Order", GlobalStrings.getGlobalString());
    subcityHint = Translations.translatedText(
        "order reference: ", GlobalStrings.getGlobalString());
    addAddHint = Translations.translatedText(
        "Payment: ", GlobalStrings.getGlobalString());
    productHint =
        Translations.translatedText("Product", GlobalStrings.getGlobalString());
    totalHint =
        Translations.translatedText("Total: ", GlobalStrings.getGlobalString());
    shippmentHint = Translations.translatedText(
        "Shipmment Status", GlobalStrings.getGlobalString());
    proccessingHint = Translations.translatedText(
        "Proccessing on Warehouse", GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    pHint = await physicalAddressHintFuture;
    cHint = await subcityHint;
    aHint = await addAddHint;
    prHint = await productHint;
    tHint = await totalHint;
    sHint = await shippmentHint;
    prHint = await proccessingHint;
    print("herrerererere");
    print(pHint);
    print(cHint);

    setState(() {
      loading = false;
    });
  }

  var physicalAddressHintFuture;
  var subcityHint;
  var addAddHint;
  var productHint;
  var totalHint;
  var shippmentHint;
  var proccessingHint;
  String pHint = '';
  String cHint = '';
  String aHint = '';
  String prHint = '';
  String tHint = '';
  String sHint = '';
  String pwHint = '';
  var loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: BlocProvider(
          create: (context) => _orderTrackingCubit,
          child: BlocConsumer<OrderTrackingCubit, OrderTrackingState>(
            listener: (ctx, state) {},
            builder: (ctx, state) {
              return state.maybeWhen(
                orElse: () => const HomeLoadingWidget(),
                error: (String error) => HomeErrorWidget(error: error),
                trackingData: (data) {
                  List<IconData> icons = [
                    Icons.payments_outlined,
                    Icons.inventory_outlined,
                    Icons.contact_emergency_outlined,
                    Icons.local_shipping_outlined,
                    Icons.check_circle
                  ];
                  List<StepperData> stepperData = [];
                  for (var val
                      in data.orderItems?.first.shipmentStatusList ?? []) {
                    stepperData.add(
                      StepperData(
                        title: StepperText(
                          "${val.shipmentStatusWord}",
                          textStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        subtitle: StepperText(DateFormat('MMMM d, y')
                            .format(DateTime.parse(val.shipStatusDate))),
                        iconWidget: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                              color: Color(0xFF890c4d),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: Icon(
                              icons.elementAt(
                                  (stepperData.length) % icons.length),
                              color: Colors.white),
                        ),
                      ),
                    );
                  }
                  return SafeArea(
                    child: ListView(
                      children: [
                        loading
                            ? const Text("Loading...")
                            : _buildTitle(context, pHint),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: loading ? "Loading..." : cHint,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.secondaryTextColor),
                          ),
                          TextSpan(
                            text: orderRef,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          )
                        ])),
                        const SizedBox(
                          height: 5,
                        ),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: loading ? "Payment: " : aHint,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.secondaryTextColor),
                          ),
                          TextSpan(
                            text: "${data.paymentMethod}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          )
                        ])),
                        const Divider(),
                        loading
                            ? const Text("Loading...")
                            : _buildTitle(context, prHint),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6)),
                                  border: Border.all(
                                      color: AppColors.secondaryTextColor
                                          .withOpacity(0.5),
                                      width: 0.5)),
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                height: 80,
                                width: 80,
                                placeholder: (_, __) => Container(
                                  color: AppColors.bg1,
                                ),
                                errorWidget: (_, __, ___) =>
                                    Image.asset(Assets.appIcon),
                                imageUrl:
                                    "${data.orderItems?.first.product?.webImage}",
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${data.orderItems?.first.product?.productName}",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                      "${data.orderItems?.first.product?.shortDescription}"),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                      text: loading ? "Loading..." : tHint,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.normal,
                                              color:
                                                  AppColors.secondaryTextColor),
                                    ),
                                    TextSpan(
                                      text: "ETB ${data.totalPrice}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(),
                                    )
                                  ])),
                                ],
                              ),
                            )
                          ],
                        ),
                        const Divider(),
                        loading
                            ? const Text("Loading...")
                            : _buildTitle(context, sHint),
                        Text(
                          "${data.orderItems?.first.shipmentStatusWord}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.colorPrimary),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: AnotherStepper(
                            stepperList: stepperData,
                            stepperDirection: Axis.vertical,
                            iconWidth: 40,
                            iconHeight: 40,
                            activeBarColor: const Color(0xFFa96687),
                            inActiveBarColor: Colors.grey,
                            inverted: false,
                            verticalGap: 23,
                            activeIndex: stepperData.length,
                            barThickness: 4,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontSize: 24.sp, color: AppColors.secondaryTextColor),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
