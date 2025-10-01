class UserOrderModel {
  final String orderRef;
  final String orderDate;
  final double deliveryPrice;
  final String formatedDeliveryPrice;
  final double totalPrice;
  final String formatedTotalPrice;
  final String paymentStatus;
  final String currentStage;
  final String paymentMethod;
  final List<String> images;

  UserOrderModel({
    required this.orderRef,
    required this.orderDate,
    required this.deliveryPrice,
    required this.formatedDeliveryPrice,
    required this.totalPrice,
    required this.formatedTotalPrice,
    required this.paymentStatus,
    required this.currentStage,
    required this.paymentMethod,
    required this.images,
  });

  factory UserOrderModel.fromJson(Map<String, dynamic> json) {
    return UserOrderModel(
      orderRef: json['orderRef'] ?? '',
      orderDate: json['orderDate'] ?? '',
      deliveryPrice: (json['deliveryPrice'] ?? 0.0).toDouble(),
      formatedDeliveryPrice: json['formatedDeliveryPrice'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      formatedTotalPrice: json['formatedTotalPrice'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      currentStage: json['currentStage'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      images: List<String>.from(json['images'] ?? []).map((img) => img.trim()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderRef': orderRef,
      'orderDate': orderDate,
      'deliveryPrice': deliveryPrice,
      'formatedDeliveryPrice': formatedDeliveryPrice,
      'totalPrice': totalPrice,
      'formatedTotalPrice': formatedTotalPrice,
      'paymentStatus': paymentStatus,
      'currentStage': currentStage,
      'paymentMethod': paymentMethod,
      'images': images,
    };
  }
}

class UserOrdersPagination {
  final int currentPage;
  final int pageSize;
  final int totalPages;
  final int totalElements;

  UserOrdersPagination({
    required this.currentPage,
    required this.pageSize,
    required this.totalPages,
    required this.totalElements,
  });

  factory UserOrdersPagination.fromJson(Map<String, dynamic> json) {
    return UserOrdersPagination(
      currentPage: json['currentPage'] ?? 0,
      pageSize: json['pageSize'] ?? 5,
      totalPages: json['totalPages'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
    );
  }
}

class UserOrdersResponse {
  final String statusCode;
  final String statusMessage;
  final UserOrdersPagination pagination;
  final List<UserOrderModel> orders;

  UserOrdersResponse({
    required this.statusCode,
    required this.statusMessage,
    required this.pagination,
    required this.orders,
  });

  factory UserOrdersResponse.fromJson(Map<String, dynamic> json) {
    final responseData = json['responseData'] ?? {};
    return UserOrdersResponse(
      statusCode: json['statusCode'] ?? '',
      statusMessage: json['statusMessage'] ?? '',
      pagination: UserOrdersPagination.fromJson(responseData['pagination'] ?? {}),
      orders: (responseData['content'] as List<dynamic>? ?? [])
          .map((orderJson) => UserOrderModel.fromJson(orderJson))
          .toList(),
    );
  }
}