// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:commercepal/features/new_add_address/model/delivery_allowed_cities.dart';

class DeliveryAllowedRegions {
  final int id;
  final String regionName;
  final bool deliveryAllowed;
  final int status;
  final List<DeliveryAllowedCities>? cities;
  DeliveryAllowedRegions({
    required this.id,
    required this.regionName,
    required this.deliveryAllowed,
    required this.status,
    this.cities,
  });

  DeliveryAllowedRegions copyWith({
    int? id,
    String? regionName,
    bool? deliveryAllowed,
    int? status,
    List<DeliveryAllowedCities>? cities,
  }) {
    return DeliveryAllowedRegions(
      id: id ?? this.id,
      regionName: regionName ?? this.regionName,
      deliveryAllowed: deliveryAllowed ?? this.deliveryAllowed,
      status: status ?? this.status,
      cities: cities ?? this.cities,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'regionName': regionName,
      'deliveryAllowed': deliveryAllowed,
      'status': status,
      'cities': cities?.map((x) => x.toMap()).toList(),
    };
  }

  factory DeliveryAllowedRegions.fromMap(Map<String, dynamic> map) {
    return DeliveryAllowedRegions(
      id: map['id'] as int,
      regionName: map['regionName'] as String,
      deliveryAllowed: map['deliveryAllowed'] as bool,
      status: map['status'] as int,
      cities: map['cities'] != null ? List<DeliveryAllowedCities>.from((map['cities'] as List<int>).map<DeliveryAllowedCities?>((x) => DeliveryAllowedCities.fromMap(x as Map<String,dynamic>),),) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryAllowedRegions.fromJson(String source) => DeliveryAllowedRegions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeliveryAllowedRegions(id: $id, regionName: $regionName, deliveryAllowed: $deliveryAllowed, status: $status, cities: $cities)';
  }

  @override
  bool operator ==(covariant DeliveryAllowedRegions other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.regionName == regionName &&
      other.deliveryAllowed == deliveryAllowed &&
      other.status == status &&
      listEquals(other.cities, cities);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      regionName.hashCode ^
      deliveryAllowed.hashCode ^
      status.hashCode ^
      cities.hashCode;
  }
}
