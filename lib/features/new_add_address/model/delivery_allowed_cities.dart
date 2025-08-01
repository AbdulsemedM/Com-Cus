// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DeliveryAllowedCities {
  final int cityId;
  final int countryId;
  final int status;
  final bool deliveryAllowed;
  DeliveryAllowedCities({
    required this.cityId,
    required this.countryId,
    required this.status,
    required this.deliveryAllowed,
  });

  DeliveryAllowedCities copyWith({
    int? cityId,
    int? countryId,
    int? status,
    bool? deliveryAllowed,
  }) {
    return DeliveryAllowedCities(
      cityId: cityId ?? this.cityId,
      countryId: countryId ?? this.countryId,
      status: status ?? this.status,
      deliveryAllowed: deliveryAllowed ?? this.deliveryAllowed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cityId': cityId,
      'countryId': countryId,
      'status': status,
      'deliveryAllowed': deliveryAllowed,
    };
  }

  factory DeliveryAllowedCities.fromMap(Map<String, dynamic> map) {
    return DeliveryAllowedCities(
      cityId: map['cityId'] as int,
      countryId: map['countryId'] as int,
      status: map['status'] as int,
      deliveryAllowed: map['deliveryAllowed'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryAllowedCities.fromJson(String source) => DeliveryAllowedCities.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeliveryAllowedCities(cityId: $cityId, countryId: $countryId, status: $status, deliveryAllowed: $deliveryAllowed)';
  }

  @override
  bool operator ==(covariant DeliveryAllowedCities other) {
    if (identical(this, other)) return true;
  
    return 
      other.cityId == cityId &&
      other.countryId == countryId &&
      other.status == status &&
      other.deliveryAllowed == deliveryAllowed;
  }

  @override
  int get hashCode {
    return cityId.hashCode ^
      countryId.hashCode ^
      status.hashCode ^
      deliveryAllowed.hashCode;
  }
}
