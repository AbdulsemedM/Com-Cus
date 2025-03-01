import 'dart:convert';

import 'package:commercepal/app/app2.dart';
import 'package:commercepal/app/data/network/api_provider.dart';
import 'package:commercepal/app/data/network/end_points.dart';
import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/country_manager/country_manager.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:commercepal/features/products/data/dto/Products_dto.dart';
import 'package:commercepal/features/products/domain/product.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/session/domain/session_repo.dart';
import '../domain/products_repository.dart';

@Injectable(as: ProductRepository)
class ProductsRepositoryImpl implements ProductRepository {
  final ApiProvider apiProvider;
  final SessionRepo sessionRepo;

  ProductsRepositoryImpl(this.sessionRepo, this.apiProvider);
  final countryManager = CountryManager();
  @override
  Future<List<Product>> getProducts(
      num? subCatId, Map? queryParams, bool? filter) async {
    if (filter == true) {
      print(queryParams!['maxPrice']);
      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      print(isUserLoggedIn);
      if (isUserLoggedIn) {
        try {
          final token = await prefsData.readData(PrefsKeys.userToken.name);
          final response = await http.get(
            Uri.https(
              "api.commercepal.com:2096",
              "/prime/api/v1/products/search/by-price-range",
              // {
              //   'minPrice': queryParams['minPrice'],
              //   'maxPrice': queryParams['maxPrice'],
              //   "size": "100",
              //   "subCategoryId": queryParams['subCategoryId'],
              // },
            ),
            headers: <String, String>{
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );
          print('hererererer');
          var datas = jsonDecode(response.body);
          print(datas);
          final products = datas['data']['products'];
          print(products);
          if (datas['statusCode'] == '000') {
            final myProducts = {
              "statusDescription": "success",
              "details": products,
              "statusMessage": "Request Successful",
              "statusCode": "000"
            };
            // await countryManager.loadCountryFromPreferences();
            // final String currentCountry = countryManager.country;
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            final String currentCountry = prefs.getString("currency") ?? "ETB";
            final prodObjs = ProductsDto.fromJson(myProducts, currentCountry);
            print("yesss");
            if (prodObjs.details?.isEmpty == true) {
              throw 'No products found';
            }
            return prodObjs.details!
                .where((element) => element.quantity != 0)
                .map((e) => e.toProduct())
                .toList();
          } else {
            if (datas['statusCode'] == '004') {
              throw 'No products found';
            }
            throw products['statusMessage'];
          }
        } catch (e) {
          rethrow;
        }
      } else {
        throw 'No products found';
      }
    } else {
      try {
        String? queryString;
        queryParams?.forEach((key, value) {
          // check if there is a value
          if (queryString != null) {
            queryString = "&&$key=$value";
          } else {
            // first value
            queryString = "$key=$value";
          }
        });
        final isUserBusiness = await sessionRepo.hasUserSwitchedToBusiness();
        print(queryString);
        final products = await apiProvider.get(
            "${isUserBusiness ? EndPoints.businessProducts.url : EndPoints.products.url}?${queryString ?? 'subCat=$subCatId'}");
        // final response = await http.get(
        //   Uri.https(
        //     "api.commercepal.com:2096",
        //     "/prime/api/v1/app/mobile/get-list",
        //     {
        //       'subCat': subCatId,
        //       // 'maxPrice': queryParams['maxPrice'],
        //       // "size": "100",
        //       // "subCategoryId": queryParams['subCategoryId'],
        //     },
        //   ),
        //   headers: <String, String>{
        //     'Content-Type': 'application/json; charset=UTF-8',
        //   },
        // );

        print("products");
        print(products);
        // var products = jsonDecode(response.body);
        // await countryManager.loadCountryFromPreferences();
        // final String currentCountry = countryManager.country;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String currentCountry = prefs.getString("currency") ?? "ETB";
        if (products["statusCode"] == "000") {
          final prodObjs = ProductsDto.fromJson(products, currentCountry);
          print("hrreeerr");
          // print(jsonDecode(products));
          print("hrreeerr");
          if (prodObjs.details?.isEmpty == true) {
            throw 'No products found';
          }
          // print(prodObjs.details!
          //     .where((element) => element.quantity != 0)
          //     .map((e) => e.toProduct())
          //     .toList()[0]
          //     .currency);

          return prodObjs.details!
              .where((element) => element.productId != null)
              .map((e) => e.toProduct())
              .toList();
        } else {
          if (products['statusCode'] == '004') {
            throw 'No products found';
          }
          throw products['statusMessage'];
        }
      } catch (e) {
        rethrow;
      }
    }
  }

  @override
  Future<List<Product>> searchByImage(String? image) async {
    print("here is the image");
    print(image);
    if (image!.startsWith("http")) {
      try {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://api.commercepal.com:2096/prime/api/v1/app/products/search-by-image'));
        request.fields['imageUrl'] = image;
        // request.fields['userType'] = userType;
        // request.fields['userId'] = userId;

        // Add the image file
        // var file = await http.MultipartFile.fromPath('image', image);
        // request.files.add(file);
        var response = await request.send();
        // Logging request details
        print("Request URL: ${request.url}");
        print("Request method: ${request.method}");
        print("Request headers: ${request.headers}");
        print("Request fields: ${request.fields}");
        print("Request files: ${request.files.map((file) => file.filename)}");
        var responseBody = await response.stream.bytesToString();
        print(responseBody);
        // Add your logic to handle the response here
        var products = jsonDecode(responseBody);
        print(products["statusCode"]);
        if (products["statusCode"] == "000") {
          // await countryManager.loadCountryFromPreferences();
          // final String currentCountry = countryManager.country;
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String currentCountry = prefs.getString("currency") ?? "ETB";
          final prodObjs = ProductsDto.fromJson(products, currentCountry);
          if (prodObjs.details?.isEmpty == true) {
            throw 'No products found by that image URL';
          }
          print("New count");
          print(prodObjs.details!.length);
          return prodObjs.details!.map((e) {
            return e.toProduct();
          }).toList();
        } else {
          if (products['statusCode'] == '004') {
            throw 'No products found by that image URL';
          }
          throw products['statusMessage'];
        }
        // ...
      } catch (e) {
        print(e.toString());
        rethrow;
        // Add your error handling logic here
        // ...
      }
    } else {
      try {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://api.commercepal.com:2096/prime/api/v1/app/products/search-by-image'));
        // request.fields['fileType'] = fileType;
        // request.fields['userType'] = userType;
        // request.fields['userId'] = userId;

        // Add the image file
        var file = await http.MultipartFile.fromPath('image', image);
        request.files.add(file);
        var response = await request.send();
        // Logging request details
        print("Request URL: ${request.url}");
        print("Request method: ${request.method}");
        print("Request headers: ${request.headers}");
        print("Request fields: ${request.fields}");
        print("Request files: ${request.files.map((file) => file.filename)}");
        var responseBody = await response.stream.bytesToString();
        print(responseBody);
        // Add your logic to handle the response here
        var products = jsonDecode(responseBody);
        print(products["statusCode"]);
        if (products["statusCode"] == "000") {
          // await countryManager.loadCountryFromPreferences();
          // final String currentCountry = countryManager.country;
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String currentCountry = prefs.getString("currency") ?? "ETB";
          final prodObjs = ProductsDto.fromJson(products, currentCountry);
          if (prodObjs.details?.isEmpty == true) {
            throw 'No products found by that image';
          }
          print("New count");
          print(prodObjs.details!.length);
          return prodObjs.details!.map((e) {
            return e.toProduct();
          }).toList();
        } else {
          if (products['statusCode'] == '004') {
            throw 'No products found by that image';
          }
          throw products['statusMessage'];
        }
        // ...
      } catch (e) {
        print(e.toString());
        rethrow;
        // Add your error handling logic here
        // ...
      }
    }
    // Return an empty list if no products found or an error occurred
  }

  Future<void> uploadImage({
    required String imageFile,
    required String fileType,
    required String userType,
    required String userId,
  }) async {
    final prefsData = getIt<PrefsData>();
    final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
    if (isUserLoggedIn) {
      final token = await prefsData.readData(PrefsKeys.userToken.name);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://api.commercepal.com:2096/prime/api/v1/distributor/upload-docs',
        ),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['fileType'] = fileType;
      request.fields['userType'] = userType;
      request.fields['userId'] = userId;

      // Add the image file
      var image = await http.MultipartFile.fromPath('file', imageFile);
      request.files.add(image);
      try {
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();

        print(response);

        if (responseBody == '000') {
          print('Image uploaded successfully');
        } else {
          print('Failed to upload image. Status code: ${response.statusCode}');
          print('Error message: $responseBody');
        }
      } catch (error) {
        print('Error uploading image: $error');
      }
    }

    // Add other fields
  }

  @override
  Future<List<Product>> searchProduct(String? search, num? size) async {
    try {
      final isUserBusiness = await sessionRepo.hasUserSwitchedToBusiness();
      print(size);
      // final products = await apiProvider.get(
      //     "${isUserBusiness ? EndPoints.businessSearchProducts.url : EndPoints.searchProduct.url}?reqName=$search");
      final response =
          // isUserBusiness
          //     ? await EndPoints.businessSearchProducts.url
          //     :
          await http.get(
        Uri.https(
          "api.commercepal.com:2096",
          "/prime/api/v1/data/products",
          {
            'page': size == null ? "1" : "2",
            'size': size != null ? size.toString() : '100',
            "query": search,
          },
        ),
        headers: <String, String>{
          // 'Authorization': 'Bearer $token',
          // 'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // final countryManager = CountryManager();
      // await countryManager.loadCountryFromPreferences();
      // final String currentCountry = countryManager.country;

      var products = jsonDecode(response.body);
      // print("Current country from prod: ${currentCountry}"); // Added this line
      print(products);
      if (products["statusCode"] == "000") {
        // await countryManager.loadCountryFromPreferences();
        // final String currentCountry = countryManager.country;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String currentCountry = prefs.getString("currency") ?? "ETB";
        final prodObjs = ProductsDto.fromJson(products, currentCountry);
        if (prodObjs.details?.isEmpty == true) {
          throw 'No products found by that name';
        }
        print("New count");
        print(prodObjs.details!.length);
        return prodObjs.details!.map((e) {
          return e.toProduct();
        }).toList();
      } else {
        if (products['statusCode'] == '004') {
          throw 'No products found by that name';
        }
        throw products['statusMessage'];
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
