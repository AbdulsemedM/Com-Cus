import 'dart:convert';

import 'package:commercepal/app/data/network/api_provider.dart';
import 'package:commercepal/app/data/network/end_points.dart';
import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/features/check_out/data/dto/addresses_dto.dart';
import 'package:commercepal/features/check_out/data/models/address.dart';
import 'package:commercepal/features/check_out/domain/check_out_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/cart-core/dao/cart_dao.dart';
import '../../../../core/data/prefs_data.dart';
import '../../../../core/data/prefs_data_impl.dart';
import '../../../../core/session/domain/session_repo.dart';
import 'package:http/http.dart' as http;

@Injectable(as: CheckOutRepo)
class CheckOutRepoImpl implements CheckOutRepo {
  final ApiProvider apiProvider;
  final CartDao cartDao;
  final PrefsData pData;
  final SessionRepo sessionRepo;

  CheckOutRepoImpl(
      this.apiProvider, this.cartDao, this.pData, this.sessionRepo);

  // @override
  // Future<List<Address>> fetchAddresses() async {
  //   try {
  //     final response = await apiProvider.get(EndPoints.addresses.url);
  //     final addressesResponse = jsonDecode(response);
  //     if (addressesResponse['statusCode'] == '000') {
  //       final aObject = AddressesDto.fromJson(addressesResponse);
  //       if (aObject.data?.isEmpty == true) {
  //         throw "No addresses found. Click 'Add address' to add one";
  //       }
  //       return aObject.data!.map((e) => e.toAddress()).toList();
  //     } else {
  //       throw addressesResponse['statusDescription'];
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  @override
  Future<List<Address>> fetchAddresses() async {
    // Add caching with short TTL
    // final cacheKey = 'addresses_cache';
    // final cachedData = await pData.readData(cacheKey);
    // if (cachedData != null) {
    //   try {
    //     final cached = jsonDecode(cachedData);
    //     if (cached['timestamp'] >
    //         DateTime.now().millisecondsSinceEpoch - 300000) {
    //       // 5 min cache
    //       final cachedAddresses = (cached['addresses'] as List)
    //           .map((e) => Address.fromJson(e as Map<String, dynamic>))
    //           .toList();
    //       return cachedAddresses;
    //     }
    //   } catch (_) {}
    // }

    try {
      final response = await apiProvider.get(EndPoints.addresses.url);
      final addressesResponse = jsonDecode(response);
      if (addressesResponse['statusCode'] == '000') {
        final aObject = AddressesDto.fromJson(addressesResponse);
        if (aObject.data?.isEmpty == true) {
          throw "No addresses found. Click 'Add address' to add one";
        }

        // Cache the result
        final addresses = aObject.data!.map((e) => e.toAddress()).toList();
        // await pData.writeData(
        //     cacheKey,
        //     jsonEncode({
        //       'timestamp': DateTime.now().millisecondsSinceEpoch,
        //       'addresses': addresses.map((e) => e.toAddressItem()).toList(),
        //     }));

        return addresses;
      } else {
        throw addressesResponse['statusDescription'];
      }
    } catch (e) {
      rethrow;
    }
  }

  String determineProvider(String input) {
    if (input.startsWith('sh')) {
      return 'Shein';
    } else if (input.startsWith('alb')) {
      return 'Alibaba';
    } else {
      return 'Commercepal';
    }
  }

  @override
  Future<String> generateOrderRef() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value;
    try {
      value = prefs.getString('promocode') ?? 'none';
      // print('Value from SharedPreferences: $value');
    } catch (e) {
      print('Error accessing SharedPreferences: $e');
    }
    try {
      final isUserBusiness = await sessionRepo.hasUserSwitchedToBusiness();
      final cartItems = await cartDao.getAllItems();
      final request = {
        "paymentMethod": "Murabaha",
        // if (value != "none") "promoCode": value,
        "orderComment": "orderComment",
        "items": cartItems
            .map((e) => {
                  "itemId": e.productId.toString(),
                  "configurationId": e.subProductId.toString(),
                  "quantity": e.quantity.toString(),
                  "itemComment": "",
                  if (value != "none") "promotionId": value,
                  // "promotionId": "",
                  "provider": determineProvider(e.productId ?? "")

                  // "productId": e.productId,
                  // "subProductId": e.subProductId,
                  // "quantity": e.quantity
                })
            .toList()
      };
      // print("hererequest");
      // print(request);
// <<<<<<< New-Providers
      // final response = await apiProvider.post(
      //     request,
      //     isUserBusiness
      //         ? EndPoints.businessCheckOut.url
      //         : EndPoints.checkOut.url);
      // print(request);
      final prefsData = getIt<PrefsData>();
      // final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      print("request");
      print(request);
      final token = await prefsData.readData(PrefsKeys.userToken.name);
      final checkout = await http.post(
          Uri.https(
              "api.commercepal.com:2096", "/prime/api/v1/data/order/check-out"),
          body: jsonEncode(request),
          headers: <String, String>{
            "Authorization": "Bearer $token",
            "Content-type": "application/json; charset=utf-8"
          });
      var response = jsonDecode(checkout.body);
//       final response = await apiProvider.post(
//           request,
//           isUserBusiness
//               ? EndPoints.businessCheckOut.url
//               : EndPoints.checkOut.url);
      print("orderrefhere");
      print(response);
      // print(response['orderRef']);
      // final cResponse = jsonDecode(response);
      // print("decoded");
      // print(cResponse);
      if (response['statusCode'] == '000') {
        final orderRef = response['orderRef'];
        // save it
        pData.writeData("order_ref", orderRef);
        await pData.writeData(PrefsKeys.deliveryFee.name,
            response['priceSummary']['deliveryFee'].toString());
        return orderRef;
      } else {
        // print("here is the error");
        throw response['statusDescription'];
      }
    } catch (e) {
      // print(e.toString());
      rethrow;
    }
  }

  @override
  Future<num> getDeliveryFee(String orderRef, int? addressId) async {
    // print("getDeliveryFee");
    try {
      final isUserBusiness = await sessionRepo.hasUserSwitchedToBusiness();
      final payLoad = switch (isUserBusiness) {
        false => {
            "orderRef": orderRef,
            "PreferredLocationType": "C",
            "AddressId": addressId
          },
        true => {"orderRef": orderRef}
      };
      // print("payLoad");
      // print(payLoad);
      final prefsData = getIt<PrefsData>();
      // final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      final token = await prefsData.readData(PrefsKeys.userToken.name);
      final assign = await http.post(
          Uri.https("api.commercepal.com:2096",
              "/prime/api/v1/customer/order/assign-delivery-address"),
          body: jsonEncode(payLoad),
          headers: <String, String>{
            "Authorization": "Bearer $token",
            "Content-type": "application/json; charset=utf-8"
          });
      print("assign");
      print(assign.body);
      var response = jsonDecode(assign.body);
      // final response = await apiProvider.post(
      //     payLoad,
      //     isUserBusiness
      //         ? EndPoints.businessDeliveryFee.url
      //         : EndPoints.deliveryFee.url);
// <<<<<<< New-Providers
      // print(response['totalDeliveryFee']);
      // print("The total delivery fee is here");
      // // final dResponse = jsonDecode(response);
      // print("The changed total delivery fee is here");
      print(response);
      if (response['statusCode'] == '000') {
        if (response['totalDeliveryFee'] == null) {
// =======
//       final dResponse = (response);
//       // print("here comes the fee");
//       // print(dResponse);
//       if (dResponse['statusCode'] == '000') {
//         if (dResponse['totalDeliveryFee'] == null) {
// >>>>>>> main
          throw 'Unable to calculate delivery fee. Try again later';
        }
        // print(resp['statusCode']);
        // save delivery fee
        await pData.writeData(PrefsKeys.deliveryFee.name,
            response['totalDeliveryFee'].toString());
        return response['totalDeliveryFee'];
      } else {
        // getDeliveryFee(orderRef, addressId);
        return 0;
        // throw response['statusDescription'];
      }
    } catch (e) {
      rethrow;
    }
  }
}

class CachedAddress {
  final num? id;
  final String? physicalAddress;
  final String? country;
  final String? city;
  final String? subCity;
  final num? regionId;
  final bool isSelected;
  final String? description;
  final num? addressId;
  final num? cityId;
  final String? latitude;
  final String? longitude;
  CachedAddress({
    this.id,
    this.physicalAddress,
    this.country,
    this.city,
    this.subCity,
    this.regionId,
    this.isSelected = false,
    this.description,
    this.addressId,
    this.cityId,
    this.latitude,
    this.longitude,
  });
  // Add fromJson constructor
  factory CachedAddress.fromJson(Map<String, dynamic> json) {
    return CachedAddress(
      id: json['id'],
      physicalAddress: json['physicalAddress'],
      country: json['country'],
      city: json['city'],
      subCity: json['subCity'],
      regionId: json['regionId'],
      isSelected: json['isSelected'] ?? false,
      description: json['description'],
      addressId: json['addressId'],
      cityId: json['cityId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
  // Add toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'physicalAddress': physicalAddress,
      'country': country,
      'city': city,
      'subCity': subCity,
      'regionId': regionId,
      'isSelected': isSelected,
      'description': description,
      'addressId': addressId,
      'cityId': cityId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
