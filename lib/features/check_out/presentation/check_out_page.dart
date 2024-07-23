import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/core/translator/translator.dart';
import 'package:commercepal/features/check_out/presentation/bloc/check_out_cubit.dart';
import 'package:commercepal/features/check_out/presentation/bloc/check_out_state.dart';
import 'package:commercepal/features/check_out/presentation/widgets/check_out_addresse_widget.dart';
import 'package:commercepal/features/payment/presentation/payment_page.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/cart-core/domain/cart_item.dart';
import '../data/models/address.dart';
import 'package:http/http.dart' as http;

class CheckOutPage extends StatefulWidget {
  static const routeName = "/check_out_page";

  const CheckOutPage({Key? key}) : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  void initState() {
    super.initState();
    fetchHints();
  }

  void fetchHints() async {
    setState(() {
      loading = true;
    });

    items = Translations.translatedText(
        "Check out", GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    it = await items;
    print("herrerererere");

    setState(() {
      loading = false;
    });
  }

  var items;
  String it = '';
  var loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: loading
            ? Text("Loading")
            : Text(
                it,
                style: Theme.of(context).textTheme.titleMedium,
              ),
      ),
      body: const CheckOutPageDataWidget(),
    );
  }
}

class CheckOutPageDataWidget extends StatefulWidget {
  const CheckOutPageDataWidget({Key? key}) : super(key: key);

  @override
  State<CheckOutPageDataWidget> createState() => _CheckOutPageDataWidgetState();
}

class _CheckOutPageDataWidgetState extends State<CheckOutPageDataWidget> {
  final List<CartItem> _cartItems = [];
  final List<Address> _addresses = [];
  double? latitude;
  double? longitude;
  String? _total;
  String? _shippingFee;
  bool _isUserBusiness = true;
  void initState() {
    super.initState();
    // getLocation();
    fetchHints();
  }

  void fetchHints() async {
    setState(() {
      loading = true;
    });

    OrderSumm = Translations.translatedText(
        "Order Summary", GlobalStrings.getGlobalString());
    ShipFee = Translations.translatedText(
        "Shipping Fee", GlobalStrings.getGlobalString());
    OrderTot = Translations.translatedText(
        "Order Total", GlobalStrings.getGlobalString());
    ShipBill = Translations.translatedText(
        "Continue", GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    OSumm = await OrderSumm;
    SFee = await ShipFee;
    OTot = await OrderTot;
    SBill = await ShipBill;
    print("herrerererere");
    print(OSumm);

    setState(() {
      loading = false;
    });
  }

  var OrderSumm;
  String OSumm = '';
  var ShipFee;
  String SFee = '';
  var OrderTot;
  String OTot = '';
  var ShipBill;
  String SBill = '';
  var loading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CheckOutCubit>()..getHomePageData(),
      child: BlocConsumer<CheckOutCubit, CheckOutState>(
        listener: (ctx, state) {
          state.maybeWhen(
              orElse: () {},
              error: (error) {
                print("hereisthererorror");
                displaySnack(context, error);
              },
              addresses: (adds) {
                setState(() {
                  _addresses
                    ..clear()
                    ..addAll(adds);
                });
              },
              totalAmount: (amount) {
                setState(() {
                  _total = amount;
                });
              },
              shippingFee: (fee) {
                setState(() {
                  _shippingFee = fee;
                  print("shippingfeeeee");
                  print(_shippingFee);
                });
              },
              //TODO: create state for redirecting to next stage
              success: (msg) {
                Navigator.pushNamed(context, PaymentPage.routeName);
              },
              isUserBusiness: (isUserBusiness) {
                setState(() {
                  _isUserBusiness = isUserBusiness;
                });
              },
              cartItems: (items) {
                setState(() {
                  _cartItems
                    ..clear()
                    ..addAll(items);
                });
              });
        },
        builder: (ctx, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    loading
                        ? const Text("Loading...")
                        : Text(
                            OSumm,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontSize: 20.sp),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: _cartItems
                          .map((cartItem) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          "${cartItem.name}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Text("x${cartItem.quantity}")),
                                    Expanded(
                                      child: Text(
                                          ((double.parse(cartItem.price!) *
                                                  (cartItem.quantity ?? 1))
                                              .toString())),
                                    )
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        loading
                            ? const Text("Loading...")
                            : Text(
                                SFee,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: AppColors.secondaryTextColor),
                              ),
                        if (_shippingFee == null)
                          const SizedBox(
                            height: 12,
                            width: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        else
                          Text(
                              _shippingFee != null
                                  ? '${_shippingFee!.startsWith('null ') ? _shippingFee = _shippingFee!.replaceFirst("null ", "ETB ") : _shippingFee}'
                                  : "....",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: AppColors.secondaryTextColor))
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        loading
                            ? const Text("Loading...")
                            : Text(OTot,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith()),
                        Text(
                          _total != null
                              ? "${_total!.startsWith('null ') ? _total = _total!.replaceFirst("null ", "ETB ") : _total}"
                              : '...',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(),
                        )
                      ],
                    ),
                    if (!_isUserBusiness)
                      const SizedBox(
                        height: 30,
                      ),
                    if (!_isUserBusiness)
                      CheckOutAddressesWidget(
                        onAddressClicked: (Address address) {
                          ctx.read<CheckOutCubit>().setSelectedAddress(address);
                          // setState(() {});
                        },
                      )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: AppColors.priceBg,
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            loading
                                ? const Text("Loading...")
                                : Text(OTot,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                            fontSize: 16.sp,
                                            color:
                                                AppColors.secondaryTextColor)),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                                _total != null
                                    ? "${_total!.startsWith('null ') ? _total = _total!.replaceFirst("null ", "ETB ") : _total}"
                                    : "",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w500)),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              print(_total);
                              // RegExp regExp = RegExp(r'\b\d+(\.\d+)?\b');
                              // Iterable<Match> matches =
                              //     regExp.allMatches(_total!);
                              // for (Match match in matches) {
                              //   // Extract the matched portion
                              //   String numericPart = match.group(0)!;
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              //   print(numericPart);
                              try {
                                await prefs.remove("promocode");
                              } catch (e) {
                                print(e.toString());
                              }
                              //   print("setted");
                              // }
                              ctx.read<CheckOutCubit>().validateCheckOut();
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => AppColors.colorPrimary)),
                            child: loading
                                ? const Text("Loading...")
                                : Text(
                                    SBill,
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  // Future<void> getLocation() async {
  //   try {
  //     setState(() {
  //       loading = true;
  //     });
  //     print("here we go");
  //     var status = await Permission.location.request();
  //     print(status.isPermanentlyDenied);
  //     if (status.isGranted) {
  //       Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high,
  //       );

  //       setState(() {
  //         latitude = position.latitude;
  //         longitude = position.longitude;
  //         print(latitude);
  //         print(longitude);
  //         if (latitude != null && longitude != null) {
  //           getAddressFromLatLng(latitude.toString(), longitude.toString());
  //         } else {
  //           displaySnack(
  //               context, "Please add your address by pressing \"Add Address\"");
  //         }
  //         loading = false;
  //       });
  //       print(latitude);
  //       print(longitude);
  //     } else {
  //       displaySnack(
  //           context, "Please add your address by pressing \"Add Address\"");
  //       setState(() {
  //         loading = false;
  //       });
  //     }
  //   } catch (e) {
  //     displaySnack(
  //         context, "Please add your address by pressing \"Add Address\"");
  //     setState(() {
  //       loading = false;
  //     });
  //     print('Error getting location: $e');
  //   }
  // }

  // Future<String> getAddressFromLatLng(String latitude, String longitude) async {
  //   double lat = double.parse(latitude);
  //   double lng = double.parse(longitude);

  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
  //     print(placemarks);
  //     print("object");
  //     for (Placemark placemark in placemarks) {
  //       String street = placemark.street ??
  //           ""; // Access the "Street" property and handle null values
  //       print("Street: $street");
  //     }

  //     if (placemarks.isNotEmpty) {
  //       Placemark place = placemarks[3];

  //       // Extract street information
  //       String street = place.street ?? '';
  //       String subLocality = place.administrativeArea ?? '';
  //       String locality = place.locality ?? '';
  //       String subLocal = place.subLocality ?? '';
  //       String country = place.country ?? '';
  //       try {
  //         setState(() {
  //           loading = true;
  //         });
  //         Map<String, dynamic> payload = {
  //           "region": subLocality.isNotEmpty ? subLocality : locality,
  //           "city": locality,
  //           "country": country,
  //           "physicalAddress": street.isNotEmpty ? street : subLocal,
  //           "latitude": latitude,
  //           "longitude": longitude
  //         };
  //         print(payload);
  //         final prefsData = getIt<PrefsData>();
  //         final isUserLoggedIn =
  //             await prefsData.contains(PrefsKeys.userToken.name);
  //         if (isUserLoggedIn) {
  //           final token = await prefsData.readData(PrefsKeys.userToken.name);
  //           final response = await http.post(
  //             Uri.https(
  //               "api.commercepal.com:2096",
  //               "/prime/api/v1/customer/add-delivery-address",
  //             ),
  //             body: jsonEncode(payload),
  //             headers: <String, String>{"Authorization": "Bearer $token"},
  //           );

  //           var data = jsonDecode(response.body);
  //           print(data);

  //           if (data['statusCode'] == '000') {
  //             setState(() {
  //               loading = false;
  //             });
  //             // Handle the case when statusCode is '000'
  //           } else {
  //             return "No street address found";
  //           }
  //         }
  //       } catch (e) {
  //         print(e.toString());
  //         setState(() {
  //           loading = false;
  //         });
  //         return "No street address found";
  //         // Handle other exceptions
  //       }
  //       // Concatenate the street information
  //       String address = "$street, $subLocality, $locality, $country";

  //       // Remove leading commas and spaces
  //       address = address.replaceAll(RegExp(r'^[,\s]+'), '');

  //       return address.isNotEmpty ? address : "No street address found";
  //     } else {
  //       return "No street address found";
  //     }
  //   } catch (e) {
  //     print("Error getting address: $e");
  //     return "No street address found";
  //   }
  // }
}
