import 'dart:convert';

import 'package:commercepal/app/utils/country_manager/country_manager.dart';
import 'package:commercepal/features/products/domain/product.dart';

ProductsDto productsDtoFromJson(String str) =>
    ProductsDto.fromJson(json.decode(str), null, null);

String productsDtoToJson(ProductsDto data) => json.encode(data.toJson());

class ProductsDto {
  ProductsDto({
    String? statusDescription,
    List<ProductDetails>? details,
    String? statusMessage,
    String? statusCode,
  }) {
    _statusDescription = statusDescription;
    _details = details;
    _statusMessage = statusMessage;
    _statusCode = statusCode;
  }
  void parseProducts(
      Map<String, dynamic> json, String? currency, String? country) {
    // Initialize details
    _details = [];

    // Check for products in different possible formats
    if (json['responseData'] != null &&
        json['responseData']['products'] != null) {
      // Case 1: products exist under responseData
      json['responseData']['products'].forEach((v) {
        _details?.add(ProductDetails.fromJson(v, currency, country));
      });
    } else if (json['details'] != null) {
      // Case 2: products exist directly under details
      json['details'].forEach((v) {
        _details?.add(ProductDetails.fromJson(v, currency, country));
      });
    } else if (json['products'] != null) {
      // Case 3: products exist directly under products key
      json['products'].forEach((v) {
        _details?.add(ProductDetails.fromJson(v, currency, country));
      });
    } else {
      // Case 4: No products found
      // print("No products found in the response.");
    }

    // Print details for debugging
    // print("Parsed products count: ${_details?.length}");
  }

  ProductsDto.fromJson(dynamic json, String? currency, String? country) {
    _statusDescription = json['statusDescription'];

    // print("counting");
    try {
      parseProducts(json, currency, country);
    } catch (e) {
      print("Error parsing products: $e");
    }
    // print(json['responseData']['products'] != null);
    // if (json['responseData']['products'] != null) {
    //   _details = [];
    //   json['responseData']['products'].forEach((v) {
    //     _details?.add(ProductDetails.fromJson(v));
    //     // print("counting");
    //     // print(details!.length);
    //   });
    // } else if (json['details'] != null) {
    //   json['details'].forEach((v) {
    //     _details?.add(ProductDetails.fromJson(v));
    //     print(details!.length);
    //   });
    // }
    _statusMessage = json['statusMessage'];
    _statusCode = json['statusCode'];
  }

  String? _statusDescription;
  List<ProductDetails>? _details;
  String? _statusMessage;
  String? _statusCode;

  ProductsDto copyWith({
    String? statusDescription,
    List<ProductDetails>? details,
    String? statusMessage,
    String? statusCode,
  }) =>
      ProductsDto(
        statusDescription: statusDescription ?? _statusDescription,
        details: details ?? _details,
        statusMessage: statusMessage ?? _statusMessage,
        statusCode: statusCode ?? _statusCode,
      );

  String? get statusDescription => _statusDescription;

  List<ProductDetails>? get details => _details;

  String? get statusMessage => _statusMessage;

  String? get statusCode => _statusCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusDescription'] = _statusDescription;
    if (_details != null) {
      map['responseData']['products'] =
          _details?.map((v) => v.toJson()).toList();
    }
    map['statusMessage'] = _statusMessage;
    map['statusCode'] = _statusCode;
    return map;
  }
}

ProductDetails detailsFromJson(String str) =>
    ProductDetails.fromJson(json.decode(str), str, str);

String detailsToJson(ProductDetails data) => json.encode(data.toJson());

class ProductDetails {
  ProductDetails(
      {String? specialInstruction,
      List<SubProducts>? subProducts,
      num? offerPrice,
      dynamic actualPrice,
      String? productSubCategoryIdName,
      String? productId,
      String? productName,
      dynamic minOrder,
      String? shortDescription,
      String? manufacturer,
      String? mobileVideo,
      String? webImage,
      String? webThumbnail,
      List<Reviews>? reviews,
      String? productParentCategoryIdName,
      String? discountType,
      String? currency,
      num? productRating,
      String? productType,
      List<FeatureDetails>? featureDetails,
      String? mobileImage,
      String? uniqueId,
      num? quantity,
      num? productParentCategoryId,
      String? unitOfMeasure,
      List<More>? more,
      num? productSubCategoryId,
      num? ratingCount,
      String? webVideo,
      num? discountAmount,
      num? moqValue,
      num? primarySubProduct,
      num? unitPrice,
      String? provider,
      List<String>? productImages,
      String? productCategoryIdName,
      num? productCategoryId,
      dynamic maxOrder,
      String? mobileThumbnail,
      String? productDescription,
      dynamic isDiscounted,
      num? discountValue,
      String? discountDescription,
      num? merchantId}) {
    _specialInstruction = specialInstruction;
    _subProducts = subProducts;
    _offerPrice = offerPrice;
    _actualPrice = actualPrice;
    _productSubCategoryIdName = productSubCategoryIdName;
    _productId = productId;
    _productName = productName;
    _minOrder = minOrder;
    _shortDescription = shortDescription;
    _manufacturer = manufacturer;
    _mobileVideo = mobileVideo;
    _webImage = webImage;
    _webThumbnail = webThumbnail;
    _reviews = reviews;
    _productParentCategoryIdName = productParentCategoryIdName;
    _discountType = discountType;
    _currency = currency;
    _productRating = productRating;
    _productType = productType;
    _featureDetails = featureDetails;
    _mobileImage = mobileImage;
    _uniqueId = uniqueId;
    _quantity = quantity;
    _productParentCategoryId = productParentCategoryId;
    _unitOfMeasure = unitOfMeasure;
    _more = more;
    _productSubCategoryId = productSubCategoryId;
    _ratingCount = ratingCount;
    _webVideo = webVideo;
    _discountAmount = discountAmount;
    _moqValue = moqValue;
    _primarySubProduct = primarySubProduct;
    _unitPrice = unitPrice;
    _provider = provider;
    _productImages = productImages;
    _productCategoryIdName = productCategoryIdName;
    _discountType = discountType;
    _productCategoryId = productCategoryId;
    _maxOrder = maxOrder;
    _mobileThumbnail = mobileThumbnail;
    _productDescription = productDescription;
    _isDiscounted = isDiscounted;
    _discountValue = discountValue;
    _discountDescription = discountDescription;
    _merchantId = merchantId;
  }

  ProductDetails.fromJson(dynamic json, String? currency, String? country) {
    // countryManager.loadCountryFromPreferences();
    print("the new country based search is here");
    print(json['Provider']);
    print(currency);
    print(country);
    String pid = json['ProductId'].toString();
    try {
      if (json['prices'] != null && json['prices'] is List) {
        var prices = json['prices'] as List;
        if (country == 'ET') {
          // For Ethiopia, find price with isMainCurrency = true
          var mainPrice = prices.firstWhere(
            (price) => price['countryCode'] == "ET",
            orElse: () => prices.first,
          );
          mainPrice = mainPrice['prices'];
          if (currency == "ETB") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "ETB",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          } else if (currency == "USD") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "USD",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          } else if (currency == "KES") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "KES",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          } else if (currency == "KES") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "KES",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          }
        } else if (country == "AE") {
          
          // For Arab emirates, find price with isMainCurrency = true
          var mainPrice = prices.firstWhere(
            (price) => price['countryCode'] == "AE",
            orElse: () => prices.first,
          );
          mainPrice = mainPrice['prices'];
          if (currency == "ETB") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "ETB",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          } else if (currency == "USD") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "USD",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          } else if (currency == "KES") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "KES",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          } else if (currency == "SOS") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "SOS",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          }
         
        }  else if (country == "KE") {
          
          // For Kenya, find price with isMainCurrency = true
          var mainPrice = prices.firstWhere(
            (price) => price['countryCode'] == "KE",
            orElse: () => prices.first,
          );
          mainPrice = mainPrice['prices'];
          if (currency == "ETB") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "ETB",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          } else if (currency == "USD") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "USD",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          } else if (currency == "KES") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "KES",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          } else if (currency == "SOS") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "SOS",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          }
         
        } else if (country == "SO") {
          print("did we got here");
          // For Somalia, find price with isMainCurrency = true
          var mainPrice = prices.firstWhere(
            (price) => price['countryCode'] == "SO",
            orElse: () => prices.first,
          );
          mainPrice = mainPrice['prices'];
          if (currency == "ETB") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "ETB",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          } else if (currency == "USD") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "USD",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          }else if (currency == "AED") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "AED",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          }
           else if (currency == "KES") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "KES",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          } else if (currency == "SOS") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "SOS",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          }
         
        } else {
         var mainPrice = prices.firstWhere(
            (price) => price['countryCode'] == "XX",
            orElse: () => prices.first,
          );
          mainPrice = mainPrice['prices'];
          if (currency == "ETB") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "ETB",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          } else if (currency == "USD") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "USD",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          } else if (currency == "AED") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "AED",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          }
           else if (currency == "KES") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "KES",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          } else if (currency == "SOS") {
            var fin = mainPrice.firstWhere(
              (price) => price['currencyCode'] == "SOS",
              orElse: () => mainPrice.first,
            );
            _unitPrice = fin['price'];
            _currency = fin['currencyCode'];
          }
        }
      } else {
        // Fallback to old price format
        _unitPrice = json['UnitPrice'] ?? json['unitPrice'];
        _currency = json['currency'] ?? "";
      }

      _specialInstruction = json['SpecialInstruction'] ?? "";
      if (json['subProducts'] != null) {
        _subProducts = [];
        json['subProducts'].forEach((v) {
          _subProducts?.add(SubProducts.fromJson(v));
        });
      } else {
        _subProducts = [];
      }
      _provider = json['Provider'] ??
          json['provider'] ??
          ""; //////////////////////////////////
      _offerPrice = json['offerPrice'] ?? "";
      _actualPrice = json['actualPrice'] ?? "";
      _productSubCategoryIdName = json['ProductSubCategoryIdName'] ?? "";
      //////////////////////////////////
      _productName =
          json['productName'] ?? ""; //////////////////////////////////
      _minOrder = json['minOrder'] ?? "";
      _shortDescription = json['ShortDescription'] ?? '';
      _manufacturer = json['manufacturer'] ?? "";
      _mobileVideo = json['mobileVideo'] ?? "";
      _webImage = json['webImage'] ?? ""; ////////////////////////////////////
      _webThumbnail = json['webThumbnail'] ?? "";
      if (json['reviews'] != null) {
        _reviews = [];
        json['reviews'].forEach((v) {
          _reviews?.add(Reviews.fromJson(v));
        });
      } else {
        _reviews = [];
      }
      _productParentCategoryIdName = json['ProductParentCategoryIdName'] ?? "";
      _discountType = json['discountType'] ?? "";
      // _currency =
      //     json['currency'] ?? ""; ///////////////////////////////////////
      _productRating = json['productRating'] ?? 0;
      _productType = json['productType'] ?? "";
      if (json['featureDetails'] != null) {
        _featureDetails = [];
        json['featureDetails'].forEach((v) {
          _featureDetails?.add(FeatureDetails.fromJson(v));
        });
      } else {
        _featureDetails = [];
      }
      _mobileImage = json['mobileImage'] ?? "";
      _uniqueId =
          json['unique_id'] ?? ""; //////////////////////////////////////
      _quantity = json['quantity'] ?? "";
      _productParentCategoryId = json['ProductParentCategoryId'] ?? "";
      _unitOfMeasure = json['unitOfMeasure'] ?? "";
      if (json['more'] != null) {
        _more = [];
        json['more'].forEach((v) {
          _more?.add(More.fromJson(v));
        });
      } else {
        _more = [];
      }
      _productSubCategoryId = json['ProductSubCategoryId'] ?? "";
      _ratingCount = json['ratingCount'] ?? "";
      _webVideo = json['webVideo'] ?? "";
      _discountAmount = json['DiscountAmount'] ?? "";
      _moqValue = json['moq_value'] ?? "";
      if (json['primarySubProduct'] != null) {
        _primarySubProduct = json['primarySubProduct'];
      } else {
        _primarySubProduct = 0;
      }
      if (json['PrimarySubProduct'] != null) {
        _primarySubProduct = json['PrimarySubProduct'];
      } else {
        _primarySubProduct = 0;
      }
      // _unitPrice = json['UnitPrice'] ?? json['unitPrice'];
      _productImages = json['ProductImages'] != null
          ? json['ProductImages'].cast<String>()
          : [];
      _productCategoryIdName = json['ProductCategoryIdName'] ?? "";
      _discountType = json['DiscountType'] ?? "";
      _productCategoryId = json['ProductCategoryId'] ?? "";
      _maxOrder = json['maxOrder'] ?? "";
      _mobileThumbnail = json['mobileThumbnail'] ?? "";
      _productDescription = json['ProductDescription'] ?? "";
      _isDiscounted = json['IsDiscounted'] ?? json['isDiscounted'] ?? "";
      _discountValue = json['DiscountValue'] ?? "";
      _discountDescription = json['discountDescription'] ?? "";
      _merchantId = json['merchantId'] ?? "";
      _productId = pid;
    } catch (e) {
      print(e.toString());
    }
  }

  String? _specialInstruction;
  List<SubProducts>? _subProducts;
  dynamic _offerPrice;
  dynamic _actualPrice;
  String? _productSubCategoryIdName;
  String? _productId;
  String? _productName;
  dynamic _minOrder;
  String? _shortDescription;
  String? _manufacturer;
  String? _mobileVideo;
  String? _webImage;
  String? _webThumbnail;
  List<Reviews>? _reviews;
  String? _productParentCategoryIdName;
  String? _discountType;
  String? _currency;
  dynamic _productRating;
  String? _productType;
  List<FeatureDetails>? _featureDetails;
  String? _mobileImage;
  String? _uniqueId;
  dynamic _quantity;
  dynamic _productParentCategoryId;
  String? _unitOfMeasure;
  List<More>? _more;
  dynamic _productSubCategoryId;
  dynamic _ratingCount;
  String? _webVideo;
  dynamic _discountAmount;
  dynamic _moqValue;
  dynamic _primarySubProduct;
  dynamic _unitPrice;
  String? _provider;
  List<String>? _productImages;
  String? _productCategoryIdName;
  dynamic _productCategoryId;
  dynamic _maxOrder;
  String? _mobileThumbnail;
  String? _productDescription;
  dynamic _isDiscounted;
  dynamic _discountValue;
  String? _discountDescription;
  dynamic _merchantId;

  ProductDetails copyWith(
          {String? specialInstruction,
          List<SubProducts>? subProducts,
          dynamic offerPrice,
          num? actualPrice,
          String? productSubCategoryIdName,
          String? productId,
          String? productName,
          dynamic minOrder,
          String? shortDescription,
          String? manufacturer,
          String? mobileVideo,
          String? webImage,
          String? webThumbnail,
          List<Reviews>? reviews,
          String? productParentCategoryIdName,
          String? discountType,
          String? currency,
          num? productRating,
          String? productType,
          List<FeatureDetails>? featureDetails,
          String? mobileImage,
          String? uniqueId,
          num? quantity,
          num? productParentCategoryId,
          String? unitOfMeasure,
          List<More>? more,
          num? productSubCategoryId,
          num? ratingCount,
          String? webVideo,
          num? discountAmount,
          num? moqValue,
          num? primarySubProduct,
          num? unitPrice,
          String? provider,
          List<String>? productImages,
          String? productCategoryIdName,
          num? productCategoryId,
          num? maxOrder,
          String? mobileThumbnail,
          String? productDescription,
          dynamic isDiscounted,
          num? discountValue,
          String? discountDescription,
          num? merchantId}) =>
      ProductDetails(
          specialInstruction: specialInstruction ?? _specialInstruction,
          subProducts: subProducts ?? _subProducts,
          offerPrice: offerPrice ?? _offerPrice,
          actualPrice: actualPrice ?? _actualPrice,
          productSubCategoryIdName:
              productSubCategoryIdName ?? _productSubCategoryIdName,
          productId: productId ?? _productId,
          productName: productName ?? _productName,
          minOrder: minOrder ?? _minOrder,
          shortDescription: shortDescription ?? _shortDescription,
          manufacturer: manufacturer ?? _manufacturer,
          mobileVideo: mobileVideo ?? _mobileVideo,
          webImage: webImage ?? _webImage,
          webThumbnail: webThumbnail ?? _webThumbnail,
          reviews: reviews ?? _reviews,
          productParentCategoryIdName:
              productParentCategoryIdName ?? _productParentCategoryIdName,
          discountType: discountType ?? _discountType,
          currency: currency ?? _currency,
          productRating: productRating ?? _productRating,
          productType: productType ?? _productType,
          featureDetails: featureDetails ?? _featureDetails,
          mobileImage: mobileImage ?? _mobileImage,
          uniqueId: uniqueId ?? _uniqueId,
          quantity: quantity ?? _quantity,
          productParentCategoryId:
              productParentCategoryId ?? _productParentCategoryId,
          unitOfMeasure: unitOfMeasure ?? _unitOfMeasure,
          more: more ?? _more,
          productSubCategoryId: productSubCategoryId ?? _productSubCategoryId,
          ratingCount: ratingCount ?? _ratingCount,
          webVideo: webVideo ?? _webVideo,
          discountAmount: discountAmount ?? _discountAmount,
          moqValue: moqValue ?? _moqValue,
          primarySubProduct: primarySubProduct ?? _primarySubProduct,
          unitPrice: unitPrice ?? _unitPrice,
          provider: provider ?? _provider,
          productImages: productImages ?? _productImages,
          productCategoryIdName:
              productCategoryIdName ?? _productCategoryIdName,
          productCategoryId: productCategoryId ?? _productCategoryId,
          maxOrder: maxOrder ?? _maxOrder,
          mobileThumbnail: mobileThumbnail ?? _mobileThumbnail,
          productDescription: productDescription ?? _productDescription,
          isDiscounted: isDiscounted ?? _isDiscounted,
          discountValue: discountValue ?? _discountValue,
          discountDescription: discountDescription ?? _discountDescription,
          merchantId: merchantId ?? _merchantId);

  String? get specialInstruction => _specialInstruction;

  List<SubProducts>? get subProducts => _subProducts;

  dynamic get offerPrice => _offerPrice;

  dynamic get actualPrice => _actualPrice;

  String? get productSubCategoryIdName => _productSubCategoryIdName;

  String? get productId => _productId;

  String? get productName => _productName;

  dynamic get minOrder => _minOrder;

  String? get shortDescription => _shortDescription;

  String? get manufacturer => _manufacturer;

  String? get mobileVideo => _mobileVideo;

  String? get webImage => _webImage;

  String? get webThumbnail => _webThumbnail;

  List<Reviews>? get reviews => _reviews;

  String? get productParentCategoryIdName => _productParentCategoryIdName;

  String? get discountType => _discountType;

  String? get currency => _currency;

  num? get productRating => _productRating;

  String? get productType => _productType;

  List<FeatureDetails>? get featureDetails => _featureDetails;

  String? get mobileImage => _mobileImage;

  String? get uniqueId => _uniqueId;

  num? get quantity => _quantity;

  num? get productParentCategoryId => _productParentCategoryId;

  String? get unitOfMeasure => _unitOfMeasure;

  List<More>? get more => _more;

  num? get productSubCategoryId => _productSubCategoryId;

  dynamic get ratingCount => _ratingCount;

  String? get webVideo => _webVideo;

  num? get discountAmount => _discountAmount;

  num? get moqValue => _moqValue;

  dynamic get primarySubProduct => _primarySubProduct;

  dynamic get unitPrice => _unitPrice;

  String? get provider => _provider;

  List<String>? get productImages => _productImages;

  String? get productCategoryIdName => _productCategoryIdName;

  num? get productCategoryId => _productCategoryId;

  num? get maxOrder => _maxOrder;

  String? get mobileThumbnail => _mobileThumbnail;

  String? get productDescription => _productDescription;

  dynamic get isDiscounted => _isDiscounted;

  num? get discountValue => _discountValue;

  String? get discountDescription => _discountDescription;
  num? get merchantId => _merchantId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SpecialInstruction'] = _specialInstruction;
    if (_subProducts != null) {
      map['subProducts'] = _subProducts?.map((v) => v.toJson()).toList();
    }
    map['offerPrice'] = _offerPrice;
    map['actualPrice'] = _actualPrice;
    map['ProductSubCategoryIdName'] = _productSubCategoryIdName;
    map['ProductId'] = _productId;
    map['productName'] = _productName;
    map['minOrder'] = _minOrder;
    map['ShortDescription'] = _shortDescription;
    map['manufacturer'] = _manufacturer;
    map['mobileVideo'] = _mobileVideo;
    map['webImage'] = _webImage;
    map['webThumbnail'] = _webThumbnail;
    if (_reviews != null) {
      map['reviews'] = _reviews?.map((v) => v.toJson()).toList();
    }
    map['ProductParentCategoryIdName'] = _productParentCategoryIdName;
    map['discountType'] = _discountType;
    map['currency'] = _currency;
    map['productRating'] = _productRating;
    map['productType'] = _productType;
    if (_featureDetails != null) {
      map['featureDetails'] = _featureDetails?.map((v) => v.toJson()).toList();
    }
    map['mobileImage'] = _mobileImage;
    map['unique_id'] = _uniqueId;
    map['quantity'] = _quantity;
    map['ProductParentCategoryId'] = _productParentCategoryId;
    map['unitOfMeasure'] = _unitOfMeasure;
    if (_more != null) {
      map['more'] = _more?.map((v) => v.toJson()).toList();
    }
    map['ProductSubCategoryId'] = _productSubCategoryId;
    map['ratingCount'] = _ratingCount;
    map['webVideo'] = _webVideo;
    map['DiscountAmount'] = _discountAmount;
    map['moq_value'] = _moqValue;
    map['PrimarySubProduct'] = _primarySubProduct;
    map['UnitPrice'] = _unitPrice;
    map['Provider'] = _provider;
    map['ProductImages'] = _productImages;
    map['ProductCategoryIdName'] = _productCategoryIdName;
    map['DiscountType'] = _discountType;
    map['ProductCategoryId'] = _productCategoryId;
    map['maxOrder'] = _maxOrder;
    map['mobileThumbnail'] = _mobileThumbnail;
    map['ProductDescription'] = _productDescription;
    map['IsDiscounted'] = _isDiscounted;
    map['DiscountValue'] = _discountValue;
    map['discountDescription'] = _discountDescription;
    map['merchantId'] = _merchantId;
    return map;
  }

  Product toProduct() => Product(
      webImage,
      productName,
      currency,
      unitPrice,
      // ratingCount,
      productId,
      // shortDescription,
      subProducts?.isNotEmpty == true
          ? subProducts![0].subProductId
          : primarySubProduct,
      subProducts?.length,
      // isDiscounted,
      // offerPrice,
      // _quantity,
      // _merchantId,
      minOrder.toString(),
      provider);
}

More moreFromJson(String str) => More.fromJson(json.decode(str));

String moreToJson(More data) => json.encode(data.toJson());

class More {
  More({
    String? template,
    String? catalogueType,
    String? displayName,
    List<Items>? items,
    String? key,
  }) {
    _template = template;
    _catalogueType = catalogueType;
    _displayName = displayName;
    _items = items;
    _key = key;
  }

  More.fromJson(dynamic json) {
    _template = json['template'];
    _catalogueType = json['catalogueType'];
    _displayName = json['display_name'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
    _key = json['key'];
  }

  String? _template;
  String? _catalogueType;
  String? _displayName;
  List<Items>? _items;
  String? _key;

  More copyWith({
    String? template,
    String? catalogueType,
    String? displayName,
    List<Items>? items,
    String? key,
  }) =>
      More(
        template: template ?? _template,
        catalogueType: catalogueType ?? _catalogueType,
        displayName: displayName ?? _displayName,
        items: items ?? _items,
        key: key ?? _key,
      );

  String? get template => _template;

  String? get catalogueType => _catalogueType;

  String? get displayName => _displayName;

  List<Items>? get items => _items;

  String? get key => _key;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['template'] = _template;
    map['catalogueType'] = _catalogueType;
    map['display_name'] = _displayName;
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    map['key'] = _key;
    return map;
  }
}

Items itemsFromJson(String str) => Items.fromJson(json.decode(str));

String itemsToJson(Items data) => json.encode(data.toJson());

class Items {
  Items({
    String? mobileImage,
    String? uniqueName,
    String? webImage,
    String? webThumbnail,
    String? name,
    num? id,
    String? mobileThumbnail,
    String? sectionType,
    num? categoryId,
  }) {
    _mobileImage = mobileImage;
    _uniqueName = uniqueName;
    _webImage = webImage;
    _webThumbnail = webThumbnail;
    _name = name;
    _id = id;
    _mobileThumbnail = mobileThumbnail;
    _sectionType = sectionType;
    _categoryId = categoryId;
  }

  Items.fromJson(dynamic json) {
    _mobileImage = json['mobileImage'];
    _uniqueName = json['unique_name'];
    _webImage = json['webImage'];
    _webThumbnail = json['webThumbnail'];
    _name = json['name'];
    _id = json['id'];
    _mobileThumbnail = json['mobileThumbnail'];
    _sectionType = json['sectionType'];
    _categoryId = json['categoryId'];
  }

  String? _mobileImage;
  String? _uniqueName;
  String? _webImage;
  String? _webThumbnail;
  String? _name;
  num? _id;
  String? _mobileThumbnail;
  String? _sectionType;
  num? _categoryId;

  Items copyWith({
    String? mobileImage,
    String? uniqueName,
    String? webImage,
    String? webThumbnail,
    String? name,
    num? id,
    String? mobileThumbnail,
    String? sectionType,
    num? categoryId,
  }) =>
      Items(
        mobileImage: mobileImage ?? _mobileImage,
        uniqueName: uniqueName ?? _uniqueName,
        webImage: webImage ?? _webImage,
        webThumbnail: webThumbnail ?? _webThumbnail,
        name: name ?? _name,
        id: id ?? _id,
        mobileThumbnail: mobileThumbnail ?? _mobileThumbnail,
        sectionType: sectionType ?? _sectionType,
        categoryId: categoryId ?? _categoryId,
      );

  String? get mobileImage => _mobileImage;

  String? get uniqueName => _uniqueName;

  String? get webImage => _webImage;

  String? get webThumbnail => _webThumbnail;

  String? get name => _name;

  num? get id => _id;

  String? get mobileThumbnail => _mobileThumbnail;

  String? get sectionType => _sectionType;

  num? get categoryId => _categoryId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobileImage'] = _mobileImage;
    map['unique_name'] = _uniqueName;
    map['webImage'] = _webImage;
    map['webThumbnail'] = _webThumbnail;
    map['name'] = _name;
    map['id'] = _id;
    map['mobileThumbnail'] = _mobileThumbnail;
    map['sectionType'] = _sectionType;
    map['categoryId'] = _categoryId;
    return map;
  }
}

FeatureDetails featureDetailsFromJson(String str) =>
    FeatureDetails.fromJson(json.decode(str));

String featureDetailsToJson(FeatureDetails data) => json.encode(data.toJson());

class FeatureDetails {
  FeatureDetails({
    num? featureId,
    List<String>? available,
  }) {
    _featureId = featureId;
    _available = available;
  }

  FeatureDetails.fromJson(dynamic json) {
    _featureId = json['FeatureId'];
    _available =
        json['Available'] != null ? json['Available'].cast<String>() : [];
  }

  num? _featureId;
  List<String>? _available;

  FeatureDetails copyWith({
    num? featureId,
    List<String>? available,
  }) =>
      FeatureDetails(
        featureId: featureId ?? _featureId,
        available: available ?? _available,
      );

  num? get featureId => _featureId;

  List<String>? get available => _available;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['FeatureId'] = _featureId;
    map['Available'] = _available;
    return map;
  }
}

Reviews reviewsFromJson(String str) => Reviews.fromJson(json.decode(str));

String reviewsToJson(Reviews data) => json.encode(data.toJson());

class Reviews {
  Reviews({
    String? date,
    String? reviewerName,
    num? rating,
    String? reviewerProfileImageUrl,
    String? description,
    num? id,
    String? title,
  }) {
    _date = date;
    _reviewerName = reviewerName;
    _rating = rating;
    _reviewerProfileImageUrl = reviewerProfileImageUrl;
    _description = description;
    _id = id;
    _title = title;
  }

  Reviews.fromJson(dynamic json) {
    _date = json['date'];
    _reviewerName = json['reviewerName'];
    _rating = json['rating'];
    _reviewerProfileImageUrl = json['reviewerProfileImageUrl'];
    _description = json['description'];
    _id = json['id'];
    _title = json['title'];
  }

  String? _date;
  String? _reviewerName;
  num? _rating;
  String? _reviewerProfileImageUrl;
  String? _description;
  num? _id;
  String? _title;

  Reviews copyWith({
    String? date,
    String? reviewerName,
    num? rating,
    String? reviewerProfileImageUrl,
    String? description,
    num? id,
    String? title,
  }) =>
      Reviews(
        date: date ?? _date,
        reviewerName: reviewerName ?? _reviewerName,
        rating: rating ?? _rating,
        reviewerProfileImageUrl:
            reviewerProfileImageUrl ?? _reviewerProfileImageUrl,
        description: description ?? _description,
        id: id ?? _id,
        title: title ?? _title,
      );

  String? get date => _date;

  String? get reviewerName => _reviewerName;

  dynamic get rating => _rating;

  String? get reviewerProfileImageUrl => _reviewerProfileImageUrl;

  String? get description => _description;

  dynamic get id => _id;

  String? get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = _date;
    map['reviewerName'] = _reviewerName;
    map['rating'] = _rating;
    map['reviewerProfileImageUrl'] = _reviewerProfileImageUrl;
    map['description'] = _description;
    map['id'] = _id;
    map['title'] = _title;
    return map;
  }
}

SubProducts subProductsFromJson(String str) =>
    SubProducts.fromJson(json.decode(str));

String subProductsToJson(SubProducts data) => json.encode(data.toJson());

class SubProducts {
  SubProducts({
    String? mobileImage,
    dynamic offerPrice,
    List<String>? subProductImages,
    String? webVideo,
    dynamic discountAmount,
    String? shortDescription,
    List<Features>? features,
    dynamic unitPrice,
    String? mobileVideo,
    String? webImage,
    String? webThumbnail,
    dynamic subProductId,
    String? discountType,
    String? mobileThumbnail,
    dynamic isDiscounted,
    dynamic discountValue,
    String? discountDescription,
  }) {
    _mobileImage = mobileImage;
    _offerPrice = offerPrice;
    _subProductImages = subProductImages;
    _webVideo = webVideo;
    _discountAmount = discountAmount;
    _shortDescription = shortDescription;
    _features = features;
    _unitPrice = unitPrice;
    _mobileVideo = mobileVideo;
    _webImage = webImage;
    _webThumbnail = webThumbnail;
    _subProductId = subProductId;
    _discountType = discountType;
    _mobileThumbnail = mobileThumbnail;
    _isDiscounted = isDiscounted;
    _discountValue = discountValue;
    _discountDescription = discountDescription;
  }

  SubProducts.fromJson(dynamic json) {
    _mobileImage = json['mobileImage'];
    _offerPrice = json['offerPrice'];
    _subProductImages = json['subProductImages'] != null
        ? json['subProductImages'].cast<String>()
        : [];
    _webVideo = json['webVideo'];
    _discountAmount = json['DiscountAmount'];
    _shortDescription = json['ShortDescription'];
    if (json['features'] != null) {
      _features = [];
      json['features'].forEach((v) {
        _features?.add(Features.fromJson(v));
      });
    }
    _unitPrice = json['UnitPrice'];
    _mobileVideo = json['mobileVideo'];
    _webImage = json['webImage'];
    _webThumbnail = json['webThumbnail'];
    _subProductId = json['SubProductId'];
    _discountType = json['DiscountType'];
    _mobileThumbnail = json['mobileThumbnail'];
    _isDiscounted = json['IsDiscounted'];
    _discountValue = json['DiscountValue'];
    _discountDescription = json['discountDescription'];
  }

  String? _mobileImage;
  dynamic _offerPrice;
  List<String>? _subProductImages;
  String? _webVideo;
  dynamic _discountAmount;
  String? _shortDescription;
  List<Features>? _features;
  dynamic _unitPrice;
  String? _mobileVideo;
  String? _webImage;
  String? _webThumbnail;
  dynamic _subProductId;
  String? _discountType;
  String? _mobileThumbnail;
  dynamic _isDiscounted;
  dynamic _discountValue;
  String? _discountDescription;

  SubProducts copyWith({
    String? mobileImage,
    dynamic offerPrice,
    List<String>? subProductImages,
    String? webVideo,
    dynamic discountAmount,
    String? shortDescription,
    List<Features>? features,
    dynamic unitPrice,
    String? mobileVideo,
    String? webImage,
    String? webThumbnail,
    dynamic subProductId,
    String? discountType,
    String? mobileThumbnail,
    dynamic isDiscounted,
    num? discountValue,
    String? discountDescription,
  }) =>
      SubProducts(
        mobileImage: mobileImage ?? _mobileImage,
        offerPrice: offerPrice ?? _offerPrice,
        subProductImages: subProductImages ?? _subProductImages,
        webVideo: webVideo ?? _webVideo,
        discountAmount: discountAmount ?? _discountAmount,
        shortDescription: shortDescription ?? _shortDescription,
        features: features ?? _features,
        unitPrice: unitPrice ?? _unitPrice,
        mobileVideo: mobileVideo ?? _mobileVideo,
        webImage: webImage ?? _webImage,
        webThumbnail: webThumbnail ?? _webThumbnail,
        subProductId: subProductId ?? _subProductId,
        discountType: discountType ?? _discountType,
        mobileThumbnail: mobileThumbnail ?? _mobileThumbnail,
        isDiscounted: isDiscounted ?? _isDiscounted,
        discountValue: discountValue ?? _discountValue,
        discountDescription: discountDescription ?? _discountDescription,
      );

  String? get mobileImage => _mobileImage;

  dynamic get offerPrice => _offerPrice;

  List<String>? get subProductImages => _subProductImages;

  String? get webVideo => _webVideo;

  dynamic get discountAmount => _discountAmount;

  String? get shortDescription => _shortDescription;

  List<Features>? get features => _features;

  dynamic get unitPrice => _unitPrice;

  String? get mobileVideo => _mobileVideo;

  String? get webImage => _webImage;

  String? get webThumbnail => _webThumbnail;

  String? get subProductId => _subProductId;

  String? get discountType => _discountType;

  String? get mobileThumbnail => _mobileThumbnail;

  dynamic get isDiscounted => _isDiscounted;

  dynamic get discountValue => _discountValue;

  String? get discountDescription => _discountDescription;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobileImage'] = _mobileImage;
    map['offerPrice'] = _offerPrice;
    map['subProductImages'] = _subProductImages;
    map['webVideo'] = _webVideo;
    map['DiscountAmount'] = _discountAmount;
    map['ShortDescription'] = _shortDescription;
    if (_features != null) {
      map['features'] = _features?.map((v) => v.toJson()).toList();
    }
    map['UnitPrice'] = _unitPrice;
    map['mobileVideo'] = _mobileVideo;
    map['webImage'] = _webImage;
    map['webThumbnail'] = _webThumbnail;
    map['SubProductId'] = _subProductId;
    map['DiscountType'] = _discountType;
    map['mobileThumbnail'] = _mobileThumbnail;
    map['IsDiscounted'] = _isDiscounted;
    map['DiscountValue'] = _discountValue;
    map['discountDescription'] = _discountDescription;
    return map;
  }
}

Features featuresFromJson(String str) => Features.fromJson(json.decode(str));

String featuresToJson(Features data) => json.encode(data.toJson());

class Features {
  Features({
    String? featureValue,
    String? variableType,
    String? unitOfMeasure,
    String? valueUnitOfMeasure,
    String? featureName,
    num? valueId,
    num? featureId,
  }) {
    _featureValue = featureValue;
    _variableType = variableType;
    _unitOfMeasure = unitOfMeasure;
    _valueUnitOfMeasure = valueUnitOfMeasure;
    _featureName = featureName;
    _valueId = valueId;
    _featureId = featureId;
  }

  Features.fromJson(dynamic json) {
    _featureValue = json['featureValue'];
    _variableType = json['variableType'];
    _unitOfMeasure = json['unitOfMeasure'];
    _valueUnitOfMeasure = json['ValueUnitOfMeasure'];
    _featureName = json['featureName'];
    _valueId = json['ValueId'];
    _featureId = json['featureId'];
  }

  String? _featureValue;
  String? _variableType;
  String? _unitOfMeasure;
  String? _valueUnitOfMeasure;
  String? _featureName;
  num? _valueId;
  num? _featureId;

  Features copyWith({
    String? featureValue,
    String? variableType,
    String? unitOfMeasure,
    String? valueUnitOfMeasure,
    String? featureName,
    num? valueId,
    num? featureId,
  }) =>
      Features(
        featureValue: featureValue ?? _featureValue,
        variableType: variableType ?? _variableType,
        unitOfMeasure: unitOfMeasure ?? _unitOfMeasure,
        valueUnitOfMeasure: valueUnitOfMeasure ?? _valueUnitOfMeasure,
        featureName: featureName ?? _featureName,
        valueId: valueId ?? _valueId,
        featureId: featureId ?? _featureId,
      );

  String? get featureValue => _featureValue;

  String? get variableType => _variableType;

  String? get unitOfMeasure => _unitOfMeasure;

  String? get valueUnitOfMeasure => _valueUnitOfMeasure;

  String? get featureName => _featureName;

  num? get valueId => _valueId;

  num? get featureId => _featureId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['featureValue'] = _featureValue;
    map['variableType'] = _variableType;
    map['unitOfMeasure'] = _unitOfMeasure;
    map['ValueUnitOfMeasure'] = _valueUnitOfMeasure;
    map['featureName'] = _featureName;
    map['ValueId'] = _valueId;
    map['featureId'] = _featureId;
    return map;
  }
}
