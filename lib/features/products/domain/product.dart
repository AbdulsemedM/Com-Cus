import 'package:commercepal/core/cart-core/domain/cart_item.dart';

T? cast<T>(x) => x is T ? x : null;

class Product {
  final String? _image;
  final String? _name;
  final String? _currency;
  final dynamic _price;
  // final num? _rating;
  final String? _id;
  // final String? description;
  final dynamic _subProdId;
  final num? subProducts;
  // final dynamic _isDiscounted;
  // final dynamic _offerPrice;
  // final num? _quantity;
  // final num? _merchantId;
  final String? _provider;

  Product(
      this._image,
      this._name,
      this._currency,
      this._price,
      // this._rating,
      this._id,
      // this.description,
      this._subProdId,
      this.subProducts,
      // this._isDiscounted,
      // this._offerPrice,
      // this._quantity,
      // this._merchantId,
      this._provider);

  String? get id => _id;

  dynamic? get subId => _subProdId;

  // num? get rating => _rating;

  dynamic get price => _price;

  String? get currency => _currency;

  String? get provider => _provider;

  String? get name => _name;

  String? get image => _image;

  // dynamic get isDiscounted => _isDiscounted;

  // dynamic get offerPrice => _offerPrice;

  // num? get quantity => _quantity;

  // num? get merchantId => _merchantId;

  CartItem toCartItem() => CartItem(
        name: name,
        image: image,
        // description: description,
        currency: currency,
        price: "${price}",
        quantity: 1,
        productId: id,
        subProductId: subId?.toString(),
        // merchantId: merchantId?.toInt()
      );
}
