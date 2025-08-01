// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DeliveryAllowedCountries {
  final int id;
  final String name;
  final String countryCode;
  final String? phoneCode;
  final String? status;
  final bool deliveryAllowed;
  DeliveryAllowedCountries({
    required this.id,
    required this.name,
    required this.countryCode,
    this.phoneCode,
    this.status,
    required this.deliveryAllowed,
  });

  DeliveryAllowedCountries copyWith({
    int? id,
    String? name,
    String? countryCode,
    String? phoneCode,
    String? status,
    bool? deliveryAllowed,
  }) {
    return DeliveryAllowedCountries(
      id: id ?? this.id,
      name: name ?? this.name,
      countryCode: countryCode ?? this.countryCode,
      phoneCode: phoneCode ?? this.phoneCode,
      status: status ?? this.status,
      deliveryAllowed: deliveryAllowed ?? this.deliveryAllowed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'countryCode': countryCode,
      'phoneCode': phoneCode,
      'status': status,
      'deliveryAllowed': deliveryAllowed,
    };
  }

  factory DeliveryAllowedCountries.fromMap(Map<String, dynamic> map) {
    return DeliveryAllowedCountries(
      id: map['id'] as int,
      name: map['name'] as String,
      countryCode: map['countryCode'] as String,
      phoneCode: map['phoneCode'] != null ? map['phoneCode'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      deliveryAllowed: map['deliveryAllowed'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryAllowedCountries.fromJson(String source) => DeliveryAllowedCountries.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeliveryAllowedCountries(id: $id, name: $name, countryCode: $countryCode, phoneCode: $phoneCode, status: $status, deliveryAllowed: $deliveryAllowed)';
  }

  @override
  bool operator ==(covariant DeliveryAllowedCountries other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.countryCode == countryCode &&
      other.phoneCode == phoneCode &&
      other.status == status &&
      other.deliveryAllowed == deliveryAllowed;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      countryCode.hashCode ^
      phoneCode.hashCode ^
      status.hashCode ^
      deliveryAllowed.hashCode;
  }
}
