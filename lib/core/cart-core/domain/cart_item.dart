import 'package:floor/floor.dart';

@entity
class CartItem {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? name;
  final String? image;
  final String? description;
  final String? currency;
  String? price;
  int? quantity;
  final String? productId;
  String? subProductId;
  final int? merchantId;
  final String? createdAt;
  final String? baseMarkup;

  CartItem(
      {this.id,
      this.name,
      this.image,
      this.description,
      this.currency,
      this.price,
      this.quantity,
      this.productId,
      this.subProductId,
      this.merchantId,
      this.baseMarkup,
      String? createdAt})
      : this.createdAt = createdAt ?? DateTime.now().toIso8601String();

  CartItem copyWith(
      {@PrimaryKey(autoGenerate: true) final int? id,
      final dynamic name,
      final dynamic image,
      final dynamic description,
      final dynamic currency,
      dynamic price,
      int? quantity,
      final dynamic productId,
      dynamic subProductId,
      int? merchantId,
      final dynamic createdAt,
      final dynamic baseMarkup}) {
    return CartItem(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        description: description ?? this.description,
        currency: currency ?? this.currency,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        productId: productId ?? this.productId,
        subProductId: subProductId ?? this.subProductId,
        merchantId: merchantId ?? this.merchantId,
        createdAt: createdAt ?? this.createdAt,
        baseMarkup: baseMarkup ?? this.baseMarkup);
  }
}
