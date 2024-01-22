import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/addresses/presentation/bloc/address_cubit.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class SearchPlacesScreen extends StatefulWidget {
  static const routeName = "/search_places_page";

  const SearchPlacesScreen({Key? key}) : super(key: key);

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

const kGoogleApiKey = 'AIzaSyC2YukgrlGVdc0NZHY6JuRJK3GuIs5U4Ks';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  double? latitude;
  double? longitude;
  String pAddress = '';
  static late CameraPosition initialCameraPosition;

  Set<Marker> markersList = {};

  late GoogleMapController googleMapController;

  final Mode _mode = Mode.overlay;
  var loading = false;
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: Translations.translatedText(
              "Google search places", GlobalStrings.getGlobalString()),
          //  translatedText("Log Out", 'en', dropdownValue),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text(
                snapshot.data ?? 'Default Text',
                style: const TextStyle(color: AppColors.colorPrimary),
              );
            } else {
              return const Text(
                'Loading...',
                style: TextStyle(color: AppColors.colorPrimary),
              ); // Or any loading indicator
            }
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SingleChildScrollView(
                  child: loading
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: const Center(
                              child: CircularProgressIndicator(
                            color: AppColors.colorPrimaryDark,
                          )))
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: GoogleMap(
                            initialCameraPosition: initialCameraPosition,
                            markers: markersList,
                            mapType: MapType.normal,
                            onMapCreated: (GoogleMapController controller) {
                              googleMapController = controller;
                            },
                          ),
                        ),
                ),
                loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.colorPrimaryDark),
                        onPressed: () async {
                          String add = await getAddressFromLatLng(
                              latitude.toString(), longitude.toString());
                          print(add);
                          if (add == "No street address found") {
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: FutureBuilder<String>(
                          future: Translations.translatedText(
                              "Add Location", GlobalStrings.getGlobalString()),
                          //  translatedText("Log Out", 'en', dropdownValue),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Text(
                                snapshot.data ?? 'Default Text',
                              );
                            } else {
                              return const Text(
                                'Loading...',
                              ); // Or any loading indicator
                            }
                          },
                        ),
                      ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorPrimaryDark),
              onPressed: _handlePressButton,
              child: FutureBuilder<String>(
                future: Translations.translatedText(
                    "Search places", GlobalStrings.getGlobalString()),
                //  translatedText("Log Out", 'en', dropdownValue),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(
                      snapshot.data ?? 'Default Text',
                    );
                  } else {
                    return const Text(
                      'Loading...',
                    ); // Or any loading indicator
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getAddressFromLatLng(String latitude, String longitude) async {
    double lat = double.parse(latitude);
    double lng = double.parse(longitude);

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Extract street information
        String street = place.street ?? '';
        String subLocality = place.subLocality ?? '';
        String locality = place.locality ?? '';
        String country = place.country ?? '';
///////////////////////////////////////////////////////////////////////////////////////////////////
        try {
          setState(() {
            loading = true;
          });
          Map<String, dynamic> payload = {
            "region": subLocality.isNotEmpty ? subLocality : locality,
            "city": locality,
            "country": country,
            "physicalAddress": pAddress != ''
                ? pAddress
                : subLocality.isNotEmpty
                    ? subLocality
                    : locality,
            "latitude": latitude,
            "longitude": longitude
          };
          print(payload);
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
            print(data);

            if (data['statusCode'] == '000') {
              setState(() {
                loading = false;
              });
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

///////////////////////////////////////////////////////////////////////////////////////////////////
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

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
        components: [Component(Component.country, "et")]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message'),
          content: Text(response.errorMessage!),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
    print("herererererere");
    print(p.description);
    List<String> parts = p.description.toString().split(',');
    String firstPart =
        parts.isNotEmpty ? parts[0].trim() : p.description.toString();
    setState(() {
      pAddress = firstPart;
    });
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    setState(() {
      latitude = lat.toDouble();
      longitude = lng.toDouble();
    });

    markersList.clear();
    markersList.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

    googleMapController!
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  Future<void> getLocation() async {
    try {
      setState(() {
        loading = true;
      });
      var status = await Permission.location.request();
      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
          if (latitude != null && longitude != null) {
            initialCameraPosition = CameraPosition(
                target: LatLng(latitude!, longitude!), zoom: 14.0);
          } else {
            initialCameraPosition =
                CameraPosition(target: LatLng(9.0192, 38.7525), zoom: 14.0);
          }
          loading = false;
        });
        print(latitude);
        print(longitude);
      }
    } catch (e) {
      setState(() {
        initialCameraPosition =
            CameraPosition(target: LatLng(9.0192, 38.7525), zoom: 14.0);
        loading = false;
      });
      print('Error getting location: $e');
    }
  }
}
