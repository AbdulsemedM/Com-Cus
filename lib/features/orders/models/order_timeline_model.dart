// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OrderTimelineModel {
  final String? stage;
  final String? status;
  final String? timestamp;
  OrderTimelineModel({
    this.stage,
    this.status,
    this.timestamp,
  });

  OrderTimelineModel copyWith({
    String? stage,
    String? status,
    String? timestamp,
  }) {
    return OrderTimelineModel(
      stage: stage ?? this.stage,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stage': stage,
      'status': status,
      'timestamp': timestamp,
    };
  }

  factory OrderTimelineModel.fromMap(Map<String, dynamic> map) {
    return OrderTimelineModel(
      stage: map['stage'] != null ? map['stage'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      timestamp: map['timestamp'] != null ? map['timestamp'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderTimelineModel.fromJson(String source) =>
      OrderTimelineModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'OrderTimelineModel(stage: $stage, status: $status, timestamp: $timestamp)';

  @override
  bool operator ==(covariant OrderTimelineModel other) {
    if (identical(this, other)) return true;

    return other.stage == stage &&
        other.status == status &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode => stage.hashCode ^ status.hashCode ^ timestamp.hashCode;
}
