// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OrdersModel {
  int id;
  String orderRef;
  String actionDescription;
  String actionTimestamp;
  String details;
  OrdersModel({
    required this.id,
    required this.orderRef,
    required this.actionDescription,
    required this.actionTimestamp,
    required this.details,
  });

  OrdersModel copyWith({
    int? id,
    String? orderRef,
    String? actionDescription,
    String? actionTimestamp,
    String? details,
  }) {
    return OrdersModel(
      id: id ?? this.id,
      orderRef: orderRef ?? this.orderRef,
      actionDescription: actionDescription ?? this.actionDescription,
      actionTimestamp: actionTimestamp ?? this.actionTimestamp,
      details: details ?? this.details,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'orderRef': orderRef,
      'actionDescription': actionDescription,
      'actionTimestamp': actionTimestamp,
      'details': details,
    };
  }

  factory OrdersModel.fromMap(Map<String, dynamic> map) {
    return OrdersModel(
      id: map['id'] as int,
      orderRef: map['orderRef'] as String,
      actionDescription: map['actionDescription'] as String,
      actionTimestamp: map['actionTimestamp'] as String,
      details: map['details'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrdersModel.fromJson(String source) =>
      OrdersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrdersModel(id: $id, orderRef: $orderRef, actionDescription: $actionDescription, actionTimestamp: $actionTimestamp, details: $details)';
  }

  @override
  bool operator ==(covariant OrdersModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.orderRef == orderRef &&
        other.actionDescription == actionDescription &&
        other.actionTimestamp == actionTimestamp &&
        other.details == details;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        orderRef.hashCode ^
        actionDescription.hashCode ^
        actionTimestamp.hashCode ^
        details.hashCode;
  }
}
