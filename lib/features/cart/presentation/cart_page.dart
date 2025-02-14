import 'dart:convert';

import 'package:commercepal/app/data/network/api_provider.dart';
import 'package:commercepal/app/data/network/end_points.dart';
import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/app/utils/string_utils.dart';
import 'package:commercepal/core/addresses-core/data/dto/addresses_dto.dart';
import 'package:commercepal/core/cart-core/bloc/cart_core_cubit.dart';
import 'package:commercepal/core/cart-core/bloc/cart_core_state.dart';
import 'package:commercepal/core/cart-core/dao/cart_dao.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/core/translator/translator.dart';
import 'package:commercepal/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:commercepal/features/check_out/presentation/check_out_page.dart';
import 'package:commercepal/features/check_out/presentation/widgets/check_out_addresse_widget.dart';
import 'package:commercepal/features/dashboard/widgets/home_error_widget.dart';
import 'package:commercepal/features/login/presentation/login_page.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/widgets/product_price_widget.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void initState() {
    super.initState();
    // checkToken();
    fetchHints();
    fetchAddresses();
    // fetchUser1();
  }

  double calculateTotalPrice(
      double itemPrice, double baseMarkup, int quantity) {
    double totalPrice = 0; // Initialize total price to 0
    // print("itemPrice: from cart page");
    // print(itemPrice);
    // print("baseMarkup: from cart page");
    // print(baseMarkup);
    for (int itemIndex = 1; itemIndex <= quantity; itemIndex++) {
      if (itemIndex == 1) {
        totalPrice +=
            itemPrice + baseMarkup; // For the first item, price + full markup
        print(itemPrice + baseMarkup);
      } else if (itemIndex == 2) {
        // For subsequent items, price + half markup (rounded to 2 decimal places)
        double halfMarkup = baseMarkup * 0.2;
        totalPrice += itemPrice + baseMarkup - halfMarkup;
        // print(itemPrice + baseMarkup - halfMarkup);
      } else if (itemIndex == 3) {
        double halfMarkup = baseMarkup * 0.35;
        totalPrice += itemPrice + baseMarkup - halfMarkup;
        // print(itemPrice + baseMarkup - halfMarkup);
      } else if (itemIndex == 4) {
        double halfMarkup = baseMarkup * 0.4;
        totalPrice += itemPrice + baseMarkup - halfMarkup;
        // print(itemPrice + baseMarkup - halfMarkup);
      } else if (itemIndex == 5) {
        double halfMarkup = baseMarkup * 0.45;
        totalPrice += itemPrice + baseMarkup - halfMarkup;
        // print(itemPrice + baseMarkup - halfMarkup);
      } else if (itemIndex >= 6) {
        double halfMarkup = baseMarkup * 0.5;
        totalPrice += itemPrice + baseMarkup - halfMarkup;
        // print(itemPrice + baseMarkup - halfMarkup);
      }
    }
    print("totalPrice: $totalPrice");
    // Round to 2 decimal places
    return double.parse((totalPrice).toStringAsFixed(2));
  }

  Future<void> checkToken() async {
    String valid = await fetchUser1(context: context);
    if (valid == "logout") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginPage(fromCart: true)));
      // Navigator.pushNamed(context, LoginPage.routeName);
    }
  }

  void fetchHints() async {
    context.read<CartCoreCubit>().getAllItem();
    // await fetchAddresses();
    // Listen to state changes to check and filter cart items
    final cartState = context.read<CartCoreCubit>().state;
    cartState.maybeWhen(
      cartItems: (items) async {
        print('Checking Cart Items:');
        final now = DateTime.now();
        final sixHoursAgo = now.subtract(const Duration(hours: 6));
        try {
          for (var item in items) {
            final createdAt = DateTime.parse(item.createdAt!);
            if (createdAt.isBefore(sixHoursAgo)) {
              // Remove item if it's older than 6 hours
              context.read<CartCoreCubit>().deleteItem(item);
              print('Removed expired item: ${item.name}');
            } else {
              print('Valid item: ${item.name}, Created: ${item.createdAt}');
            }
          }
        } catch (e) {
          final cartDao = getIt<CartDao>();
          await cartDao.nuke();
        }
      },
      orElse: () => print('No items available or loading'),
    );

    // Listen to state changes to print cart items
    final cartState2 = context.read<CartCoreCubit>().state;
    cartState2.maybeWhen(
      cartItems: (items) {
        print('Fetched Cart Items:');
        for (var item in items) {
          print(
              'Item: ${item.name}, Quantity: ${item.quantity}, Price: ${item.createdAt}');
        }
      },
      orElse: () => print('No items available or loading'),
    );

    setState(() {
      loading = true;
    });
    Shopping = TranslationService.translate("Shopping Cart");
    items = TranslationService.translate("Item");

    // Use await to get the actual string value from the futures
    sCart = await Shopping;
    it = await items;
    // print("herrerererere");
    // print(sCart);

    setState(() {
      loading = false;
    });
  }

  Future<void> fetchAddresses() async {
    try {
      setState(() {
        loading = true;
      });
      final prefsData = getIt<PrefsData>();
      // final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      final token = await prefsData.readData(PrefsKeys.userToken.name);
      final addresses = await http.get(
          Uri.https("api.commercepal.com:2096",
              "/prime/api/v1/customer/get-delivery-address"),
          headers: <String, String>{
            "Authorization": "Bearer $token",
            "Content-type": "application/json; charset=utf-8"
          });
      print("fetchAddresses");
      print(addresses.body);
      final addressesResponse = jsonDecode(addresses.body);
      if (addressesResponse['statusCode'] == '000') {
        final aObject = AddressesDto.fromJson(addressesResponse);
        print("addressesResponse");
        print(aObject.data);
        if (aObject.data?.isEmpty == true) {
          getLocation();
          return;
        }
        setState(() {
          loading = false;
        });
        return;
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      return;
    }
  }

  var Shopping;
  String sCart = '';
  var items;
  String it = '';
  var loading = false;
  String logout = "login";

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCoreCubit, CartCoreState>(
      listener: (ctx, state) async {
        if (state is CartCoreStateSuccess) {
          String mess = await setMyState(state.success);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(mess),
          ));
        }
        if (state is CartCoreStateLoginUser) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(fromCart: true)));
          // Navigator.pushNamed(ctx, LoginPage.routeName);
        }

        if (state is CartCoreStateCheckOutUser) {
          Navigator.pushNamed(context, CheckOutPage.routeName);
        }
      },
      builder: (ctx, state) {
        return state.maybeWhen(
          orElse: () => const SizedBox(),
          error: (error) => HomeErrorWidget(error: error),
          cartItems: (cartItems) {
            // print("cartItems");
            // print(cartItems[0].createdAt);
            // print(cartItems[0].baseMarkup);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                  child: loading
                      ? CircularProgressIndicator()
                      : Text(
                          sCart,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.secondaryTextColor),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Text(
                    "${cartItems.map((e) => e.quantity).fold(0, (previousValue, element) => previousValue + element!)} ${loading ? '' : it}",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 12.sp),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (ctx, index) {
                      return CartItemWidget(
                        cartItem: cartItems[index],
                      );
                    },
                  ),
                ),
                ProductPriceWidget(
                  items: cartItems,
                  subTitle:
                      "Delivery Charges: ${cartItems.first.currency ?? "ETB"} 0",
                  // totalPrice: cartItems
                  //     .map((e) => e.quantity! * double.parse(e.price!))
                  //     .fold(
                  //         0.0,
                  //         (previousValue, element) =>
                  //             previousValue + element.toDouble())
                  //     .formatCurrency(cartItems.first.currency),
                  totalPrice: cartItems
                      .map((e) => calculateTotalPrice(double.parse(e.price!),
                          double.parse(e.baseMarkup!), e.quantity!))
                      .fold(
                          0.0,
                          (previousValue, element) =>
                              previousValue + element.toDouble())
                      .formatCurrency(cartItems.first.currency),
                  onClick: () async {
                    final firstCurrency = cartItems.first.currency;
                    final isCurrencyConsistent = cartItems
                        .every((item) => item.currency == firstCurrency);

                    if (!isCurrencyConsistent) {
                      displaySnack(
                          context, "All items must have the same currency.");
                      return;
                    }
                    if (loading) {
                      displaySnack(context,
                          "Please wait until we get your delivery location");
                      return;
                    }

                    String valid = await fetchUser1(context: context);
                    if (valid == "logout") {
                      displaySnack(context, "Login to your account.");
                      print(
                          "CartPage: Navigating to login with from_cart=true");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(fromCart: true)));
                      // Navigator.pushNamed(ctx, LoginPage.routeName,
                      //     arguments: const LoginPage(fromCart: true));
                    }
                    ctx.read<CartCoreCubit>().isUserLoggedIn();
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<String> setMyState(String mymess) async {
    try {
      String trans = await Translations.translatedText(
          mymess, GlobalStrings.getGlobalString());
      return trans;
    } catch (e) {
      return mymess;
    }
  }

  // Future<void> fetchUser1({int retryCount = 0, BuildContext? context}) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   try {
  //     await prefs.remove("promocode");
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   try {
  //     setState(() {
  //       loading = true;
  //     });
  //     final prefsData = getIt<PrefsData>();
  //     final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
  //     if (isUserLoggedIn) {
  //       final token = await prefsData.readData(PrefsKeys.userToken.name);
  //       final response = await http.get(
  //         Uri.https(
  //           "api.commercepal.com:2096",
  //           "prime/api/v1/get-details",
  //           {"userType": "BUSINESS"},
  //         ),
  //         headers: <String, String>{"Authorization": "Bearer $token"},
  //       );

  //       var data = jsonDecode(response.body);
  //       print(data);

  //       if (data['statusCode'] == '000') {
  //         // Handle the case when statusCode is '000'
  //         setState(() {
  //           loading = false;
  //         });
  //       } else {
  //         // Retry logic
  //         // if (retryCount < 5) {
  //         //   // Retry after num + 1 seconds
  //         //   await Future.delayed(Duration(seconds: retryCount++));
  //         //   // Call the function again with an increased retryCount
  //         //   await fetchUser(retryCount: retryCount + 1);

  //         // Retry limit reached, handle accordingly
  //         setState(() async {
  //           loading = false;
  //           logout = "logout";
  //         });

  //         // ignore: use_build_context_synchronously
  //         // Navigator.pushReplacement(context!,
  //         //     MaterialPageRoute(builder: (context) => const LoginPage()));
  //       }
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     setState(() {
  //       loading = false;
  //     });
  //     // Handle other exceptions
  //   }
  // }

  Future<void> getLocation() async {
    //used to fetch and send address twice
    try {
      setState(() {
        loading = true;
      });
      // print("here we go");
      var status = await Permission.location.request();
      print(status.isPermanentlyDenied);
      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        print("position");
        print(position);
        setState(() {
          final latitude = position.latitude;
          final longitude = position.longitude;
          // print(latitude);
          // print(longitude);
          if (latitude != null && longitude != null) {
            getAddressFromLatLng(latitude.toString(), longitude.toString());
          } else {
            displaySnack(
                context, "Please add your address by pressing \"Add Address\"");
            setState(() {
              loading = false;
            });
          }
        });
        // print(latitude);
        // print(longitude);
      } else {
        displaySnack(
            context, "Please add your address by pressing \"Add Address\"");
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      displaySnack(
          context, "Please add your address by pressing \"Add Address\"");
      setState(() {
        loading = false;
      });
      print('Error getting location: $e');
    }
  }

  Future<String> getAddressFromLatLng(String latitude, String longitude) async {
    double lat = double.parse(latitude);
    double lng = double.parse(longitude);

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      // print(placemarks);
      // print("object");
      for (Placemark placemark in placemarks) {
        String street = placemark.street ??
            ""; // Access the "Street" property and handle null values
        print("Street: $street");
      }

      if (placemarks.isNotEmpty) {
        // Placemark place = placemarks[0];
        Placemark place =
            (placemarks.length > 3) ? placemarks[3] : placemarks[0];

        // Extract street information
        String street = place.street ?? '';
        String subLocality = place.administrativeArea ?? '';
        String locality = place.locality ?? '';
        String subLocal = place.subLocality ?? '';
        String country = place.country ?? '';
        // print(
        //     "Street: $street, SubLocality: $subLocality, Locality: $locality, SubLocal: $subLocal, Country: $country");
        try {
          setState(() {
            loading = true;
          });
          // context.read<AddressCubit>().addAddress(
          //     '1',
          //     street.isNotEmpty ? street : subLocal!,
          //     1,
          //     1,
          //     country,
          //     latitude,
          //     longitude);
          Map<String, dynamic> payload = {
            "regionId": 1,
            "city": "1",
            "country": country,
            "physicalAddress": street.isNotEmpty ? street : subLocal,
            "latitude": latitude,
            "longitude": longitude
          };
          // print(payload);
          final prefsData = getIt<PrefsData>();
          final isUserLoggedIn =
              await prefsData.contains(PrefsKeys.userToken.name);
          if (isUserLoggedIn) {
            final token = await prefsData.readData(PrefsKeys.userToken.name);
            final response = await http.post(
              Uri.https(
                "api.commercepal.com:2096",
                "/prime/api/v1/customer/add-delivery-address",
              ),
              body: jsonEncode(payload),
              headers: <String, String>{"Authorization": "Bearer $token"},
            );

            var data = jsonDecode(response.body);
            // print(data);

            if (data['statusCode'] == '000') {
              setState(() {
                loading = false;
              });
              // setState(() {});
              // context.read<CheckOutCubit>().fetchAddresses();

              // Handle the case when statusCode is '000'
            } else {
              return "No street address found";
            }
          }
        } catch (e) {
          print(e.toString());
          setState(() {
            loading = false;
          });
          return "No street address found";
          // Handle other exceptions
        }
        // Concatenate the street information
        String address = "$street, $subLocality, $locality, $country";

        // Remove leading commas and spaces
        address = address.replaceAll(RegExp(r'^[,\s]+'), '');

        return address.isNotEmpty ? address : "No street address found";
      } else {
        return "No street address found";
      }
    } catch (e) {
      print("Error getting address: $e");
      return "No street address found";
    }
  }
}
