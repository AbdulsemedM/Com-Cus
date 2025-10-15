import 'dart:convert';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/check_out/presentation/check_out_page.dart';
import 'package:commercepal/features/check_out/presentation/widgets/check_out_addresse_widget.dart';
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
import 'package:commercepal/app/utils/logger.dart';

class SearchPlacesScreen extends StatefulWidget {
  static const routeName = "/search_places_page";

  const SearchPlacesScreen({Key? key}) : super(key: key);

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

const kGoogleApiKey = 'AIzaSyCIT1EnxieoKNoDmPiNvrf2kSLD6Xkohtw';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  double? latitude;
  double? longitude;
  String pAddress = '';
  static late CameraPosition initialCameraPosition;
  // List<Map<String, dynamic>> results = []; // Empty list by default

  Set<Marker> markersList = {};

  late GoogleMapController googleMapController;

  final Mode _mode = Mode.overlay;
  var loading = false;
  List<CityData> cities = [];
  @override
  void initState() {
    super.initState();
    getLocation();
    fetchCity();
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
                style: const TextStyle(
                    color: AppColors.colorPrimary, fontSize: 20),
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
                          height: MediaQuery.of(context).size.height * 0.75,
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
                          // appLog(add);
                          if (add == "No street address found") {
                            displaySnack(context, "Please try again.");
                          } else {
                            Navigator.popAndPushNamed(
                                context, CheckOutPage.routeName);
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
                                style: TextStyle(color: Colors.white),
                              );
                            } else {
                              return const Text(
                                'Loading...',
                                style: TextStyle(color: Colors.white),
                              ); // Or any loading indicator
                            }
                          },
                        ),
                      ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.colorPrimary),
                  onPressed: openPlaceSearchBottomSheet,
                  child: Row(
                    children: [
                      Icon(Icons.search),
                      FutureBuilder<String>(
                        future: Translations.translatedText(
                            "Search places", GlobalStrings.getGlobalString()),
                        //  translatedText("Log Out", 'en', dropdownValue),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Text(
                              snapshot.data ?? 'Default Text',
                              style: TextStyle(color: Colors.white),
                            );
                          } else {
                            return const Text(
                              'Loading...',
                              style: TextStyle(color: Colors.white),
                            ); // Or any loading indicator
                          }
                        },
                      ),
                    ],
                  ),
                ),
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
        appLog(locality);
        appLog(street);
        try {
          setState(() {
            loading = true;
          });
          Map<String, dynamic> payload = {
            "regionId": subLocality.isNotEmpty ? subLocality : locality,
            "city": cities
                .firstWhere((e) => e.cityName == locality,
                    orElse: () =>
                        CityData(cityId: 1, cityName: "", countryId: 1))
                .cityId,
            "country": country,
            "physicalAddress": pAddress != ''
                ? pAddress
                : subLocality.isNotEmpty
                    ? subLocality
                    : locality,
            "latitude": latitude,
            "longitude": longitude
          };
          // {
          //   "regionId": 1,
          //   "city": cities
          //       .firstWhere((e) => e.cityName == locality,
          //           orElse: () => CityData(
          //               cityId: 1, cityName: "Addis Ababa", countryId: 1))
          //       .cityId,
          //   "country": country,
          //   "physicalAddress": street.isNotEmpty ? street : subLocal,
          //   "latitude": latitude,
          //   "longitude": longitude
          // };
          // appLog(payload);
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
            // appLog(data);

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
          appLog(e.toString());
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
      appLog("Error getting address: $e");
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
    // appLog("herererererere");
    // appLog(p.description);
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

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  Future<void> getLocation() async {
    try {
      setState(() {
        loading = true;
      });
      // appLog("here we go");
      var status = await Permission.location.request();
      // appLog(status.isPermanentlyDenied);
      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
          // appLog(latitude);
          // appLog(longitude);
          if (latitude != null && longitude != null) {
            initialCameraPosition = CameraPosition(
                target: LatLng(latitude!, longitude!), zoom: 14.0);
          } else {
            initialCameraPosition =
                CameraPosition(target: LatLng(9.0192, 38.7525), zoom: 14.0);
          }
          loading = false;
        });
        // appLog(latitude);
        // appLog(longitude);
      } else {
        setState(() {
          latitude = 9.0192;
          longitude = 38.7525;
          initialCameraPosition =
              CameraPosition(target: LatLng(9.0192, 38.7525), zoom: 14.0);
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        initialCameraPosition =
            CameraPosition(target: LatLng(9.0192, 38.7525), zoom: 14.0);
        loading = false;
      });
      // appLog('Error getting location: $e');
    }
  }

  Future<void> fetchCity() async {
    try {
      setState(() {
        loading = true;
      });
      // appLog("hereeee");

      final response = await http.get(Uri.https(
          "api.commercepal.com:2096", "/prime/api/v1/service/cities"));
      // appLog(response.body);
      var data = jsonDecode(response.body);
      cities.clear();
      for (var b in data['data']) {
        cities.add(CityData(
            cityId: b['cityId'],
            cityName: b['cityName'],
            countryId: b['countryId']));
      }
      // appLog(cities.length);
      setState(() {
        loading = false;
      });
      // }
    } catch (e) {
      appLog(e.toString());
      setState(() {
        loading = false;
      });
    }
    setState(() {
      loading = false;
    });
  }

  void openPlaceSearchBottomSheet() async {
    String query = '';
    List<Map<String, dynamic>> results = [];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes it full-screen
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      query = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter place name',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (query.isNotEmpty) {
                        final places = await fetchPlaces(query);
                        setState(() {
                          results = places;
                        });
                      }
                    },
                    child: const Text('Search'),
                  ),
                  if (results.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final place = results[index];
                          return ListTile(
                            title: Text(place["name"]),
                            onTap: () {
                              setState(() {
                                latitude = place["lat"];
                                longitude = place["lon"];
                              });
                              Navigator.pop(context); // Close the bottom sheet
                              updateMapLocation(latitude!, longitude!);
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchPlaces(String query) async {
    final url =
        'https://nominatim.openstreetmap.org/search?format=json&q=$query';

    try {
      final response = await http.get(Uri.parse(url));
      appLog("response.body is here");
      appLog(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((place) {
          return {
            "name": place["display_name"],
            "lat": double.parse(place["lat"]),
            "lon": double.parse(place["lon"]),
          };
        }).toList();
      } else {
        throw Exception('Failed to fetch places');
      }
    } catch (e) {
      appLog("Error fetching places: $e");
      return [];
    }
  }

  void updateMapLocation(double lat, double lon) {
    markersList.clear();
    markersList.add(Marker(
      markerId: const MarkerId("selected_place"),
      position: LatLng(lat, lon),
      infoWindow: const InfoWindow(title: "Selected Place"),
    ));

    googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lon), 14.0),
    );

    setState(() {});
  }
}
