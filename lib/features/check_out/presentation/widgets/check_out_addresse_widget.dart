import 'dart:convert';

import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
// import 'package:commercepal/features/addresses/presentation/bloc/address_cubit.dart';
import 'package:commercepal/features/addresses/presentation/edit_address_page.dart';
import 'package:commercepal/features/addresses/presentation/search_places.dart';
import 'package:commercepal/features/check_out/data/models/address.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translation_api.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/utils/app_colors.dart';
import '../../../addresses/presentation/add_address_page.dart';
import '../../../dashboard/widgets/home_error_widget.dart';
import '../../../dashboard/widgets/home_loading_widget.dart';
import '../bloc/check_out_cubit.dart';
import '../bloc/check_out_state.dart';
import 'package:http/http.dart' as http;

enum AddressSelectedChoices { selected, notSelcted }

class CheckOutAddressesWidget extends StatefulWidget {
  final Function onAddressClicked;
  final Function reloadPage;

  const CheckOutAddressesWidget(
      {Key? key, required this.onAddressClicked, required this.reloadPage})
      : super(key: key);

  @override
  State<CheckOutAddressesWidget> createState() =>
      _CheckOutAddressesWidgetState();
}

class _CheckOutAddressesWidgetState extends State<CheckOutAddressesWidget> {
  final AddressSelectedChoices _addSelected = AddressSelectedChoices.notSelcted;
  void initState() {
    super.initState();
    fetchHints();
    fetchCity();
  }

  bool done = false;
  bool done1 = false;
  List<CityData> cities = [];

  void fetchHints() async {
    setState(() {
      loading = true;
    });

    AddAddr = TranslationService.translate("Add address");
    Edit = TranslationService.translate("Edit");
    Country = TranslationService.translate("Country: ");
    City = TranslationService.translate("Address: ");
    SubCounty = TranslationService.translate("Sub-county: ");
    ShippBill = TranslationService.translate("Shipping and Billing");
    FillAdd = TranslationService.translate("Fill Address");
    HowDo =
        TranslationService.translate("How do you want to fill the address?");
    Automatic = TranslationService.translate("From Map");
    Manual = TranslationService.translate("Manually");
    Cancel = TranslationService.translate("Cancel");

    // Use await to get the actual string value from the futures
    AAdd = await AddAddr;
    Ed = await Edit;
    Co = await Country;
    Ci = await City;
    SC = await SubCounty;
    SBill = await ShippBill;
    FAdd = await FillAdd;
    HDO = await HowDo;
    Aut = await Automatic;
    Man = await Manual;
    Can = await Cancel;
    // print("herrerererere");
    // print(AAdd);

    setState(() {
      loading = false;
    });
  }

  var AddAddr;
  String AAdd = '';
  var Edit;
  String Ed = '';
  var Country;
  String Co = '';
  var City;
  String Ci = '';
  var SubCounty;
  String SC = '';
  var ShippBill;
  String SBill = '';
  var FillAdd;
  String FAdd = '';
  var HowDo;
  String HDO = '';
  var Automatic;
  String Aut = '';
  var Manual;
  String Man = '';
  var Cancel;
  String Can = '';
  var loading = false;
  double? latitude;
  double? longitude;

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    return BlocProvider(
      create: (context) => getIt<CheckOutCubit>()..fetchAddresses(),
      child: BlocListener<CheckOutCubit, CheckOutState>(
        listener: (context, state) async {
          if (state is CheckOutStateError) {
            if (!done1) {
              await getLocation().then((value) {
                widget.reloadPage();
                // context.read<CheckOutCubit>().getHomePageData();
                // context.read<CheckOutCubit>().fetchAddresses();
                setState(() {
                  done1 = true;
                  // done = false;
                });
              });
            }
          }
        },
        child: BlocBuilder<CheckOutCubit, CheckOutState>(
          builder: (ctx, state) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    loading
                        ? const Text("Loading...")
                        : Text(
                            SBill,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontSize: 20.sp),
                          ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: loading
                                  ? const Text("Loading...")
                                  : Text(FAdd),
                              content: Column(
                                mainAxisSize: MainAxisSize
                                    .min, // Set the mainAxisSize to min
                                children: [
                                  loading
                                      ? const Text("Loading...")
                                      : Text(HDO),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: sHeight * 0.02,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(context,
                                                  SearchPlacesScreen.routeName)
                                              .then((value) =>
                                                  widget.reloadPage());
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.colorPrimaryDark),
                                        child: loading
                                            ? const Text("Loading...")
                                            : Text(
                                                Aut,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                      ),
                                      SizedBox(
                                        height: sHeight * 0.02,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(context,
                                                  AddAddressPage.routeName)
                                              .then((value) =>
                                                  widget.reloadPage());
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.colorPrimaryDark),
                                        child: loading
                                            ? const Text("Loading...")
                                            : Text(
                                                Man,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(false); // User does not confirm
                                  },
                                  child: loading
                                      ? const Text("Loading...")
                                      : Text(
                                          Can,
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: loading
                          ? const Text("Loading...")
                          : Text(AAdd,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: AppColors.colorPrimary)),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                ),
                state.maybeWhen(
                    orElse: () => const Padding(
                          padding: EdgeInsets.all(20),
                          child: HomeLoadingWidget(),
                        ),
                    error: (error) => Container(),
                    addresses: (adds) {
                      if (adds.isNotEmpty &&
                          !adds.any((address) => address.selected == true) &&
                          !loading) {
                        _markSelectedAddress(ctx, adds.last, adds, true);
                      } else if (adds.last.selected && !done) {
                        done = true;
                        widget.onAddressClicked.call(adds.last);
                      }
                      return Column(
                        children: adds
                            .map((address) => Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: ListTile(
                                        onTap: () {
                                          _markSelectedAddress(
                                              ctx, address, adds, false);
                                        },
                                        leading: Radio<AddressSelectedChoices>(
                                          value: address.selected != true
                                              ? AddressSelectedChoices.selected
                                              : AddressSelectedChoices
                                                  .notSelcted,
                                          groupValue: _addSelected,
                                          onChanged: (value) {
                                            _markSelectedAddress(
                                                ctx, address, adds, false);
                                          },
                                        ),
                                        title: Text(
                                          "${address.name}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                                text: TextSpan(children: [
                                              TextSpan(
                                                  text: loading
                                                      ? "Loading..."
                                                      : Co,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                          color: AppColors
                                                              .secondaryTextColor)),
                                              TextSpan(
                                                  text: "${address.country}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith())
                                            ])),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            RichText(
                                                text: TextSpan(children: [
                                              TextSpan(
                                                  text: loading
                                                      ? "Loading..."
                                                      : Ci,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                          color: AppColors
                                                              .secondaryTextColor)),
                                              TextSpan(
                                                  text:
                                                      "${address.physicalAddress}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith())
                                            ])),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            // RichText(
                                            //     text: TextSpan(children: [
                                            //   TextSpan(
                                            //       text: loading
                                            //           ? "Loading..."
                                            //           : SC,
                                            //       style: Theme.of(context)
                                            //           .textTheme
                                            //           .titleSmall
                                            //           ?.copyWith(
                                            //               color: AppColors
                                            //                   .secondaryTextColor)),
                                            //   TextSpan(
                                            //       text: "${address.subCounty}",
                                            //       style: Theme.of(context)
                                            //           .textTheme
                                            //           .titleSmall
                                            //           ?.copyWith())
                                            // ]))
                                          ],
                                        ),
                                        trailing: InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                    EditAddressPage.routeName,
                                                    arguments:
                                                        address.toAddressItem())
                                                .then((value) => ctx
                                                    .read<CheckOutCubit>()
                                                    .fetchAddresses());
                                          },
                                          child: loading
                                              ? const Text("Loading...")
                                              : Text(
                                                  Ed,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall
                                                      ?.copyWith(
                                                          color: AppColors
                                                              .colorPrimary,
                                                          fontSize: 16.sp),
                                                ),
                                        ),
                                      ),
                                    ),
                                    if (adds.indexOf(address) ==
                                        adds.length - 1)
                                      const SizedBox(
                                        height: 100,
                                      )
                                  ],
                                ))
                            .toList(),
                      );
                    })
              ],
            );
          },
        ),
      ),
    );
  }

  void _markSelectedAddress(
      BuildContext ctx, Address address, List<Address> adds, bool nill) {
    if (!nill) {
      ctx
          .read<CheckOutCubit>()
          .markAddressAsSelected(address.id!.toInt(), adds);
      ctx.read<CheckOutCubit>().setSelectedAddress(address);
      // ctx.read<CheckOutCubit>().fetchAddresses();
      // ctx.read<CheckOutCubit>().getHomePageData();
    } else {
      Address last = adds.last;
      ctx.read<CheckOutCubit>().markAddressAsSelected(last.id!.toInt(), adds);
      ctx.read<CheckOutCubit>().setSelectedAddress(address);
      // ctx.read<CheckOutCubit>().fetchAddresses();
      // ctx.read<CheckOutCubit>().getHomePageData();
    }
    widget.onAddressClicked.call(address);
    setState(() {
      // done = true;
    });
  }

  Future<void> getLocation() async {
    //used to fetch and send address twice
    if (done1 == false) {
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
            done1 = true;
            latitude = position.latitude;
            longitude = position.longitude;
            // print(latitude);
            // print(longitude);
            if (latitude != null && longitude != null) {
              getAddressFromLatLng(latitude.toString(), longitude.toString());
            } else {
              displaySnack(context,
                  "Please add your address by pressing \"Add Address\"");
            }
            loading = false;
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
            "city": cities
                .firstWhere((e) => e.cityName == locality,
                    orElse: () => CityData(
                        cityId: 1, cityName: "Addis Ababa", countryId: 1))
                .cityId,
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
              setState(() {});
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

  Future<void> fetchCity() async {
    try {
      setState(() {
        loading = true;
      });
      // print("hereeee");

      final response = await http.get(Uri.https(
          "api.commercepal.com:2096", "/prime/api/v1/service/cities"));
      // print(response.body);
      var data = jsonDecode(response.body);
      cities.clear();
      for (var b in data['data']) {
        cities.add(CityData(
            cityId: b['cityId'],
            cityName: b['cityName'],
            countryId: b['countryId']));
      }
      // print(cities.length);
      setState(() {
        loading = false;
      });
      // }
    } catch (e) {
      print(e.toString());
      setState(() {
        loading = false;
      });
    }
    setState(() {
      loading = false;
    });
  }
}

class CityData {
  final String cityName;
  final int cityId;
  final int countryId;
  CityData(
      {required this.countryId, required this.cityId, required this.cityName});
}
