class EpgResponse {
  String? statusDescription;
  String? orderRef;
  String? transRef;
  String? paymentUrl;
  String? statusMessage;
  String? statusCode;

  EpgResponse(
      {this.statusDescription,
      this.orderRef,
      this.transRef,
      this.paymentUrl,
      this.statusMessage,
      this.statusCode});

  EpgResponse.fromJson(Map<String, dynamic> json) {
    statusDescription = json['statusDescription'];
    orderRef = json['OrderRef'];
    transRef = json['TransRef'];
    paymentUrl = json['PaymentUrl'];
    statusMessage = json['statusMessage'];
    statusCode = json['statusCode'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusDescription'] = this.statusDescription;
    data['OrderRef'] = this.orderRef;
    data['TransRef'] = this.transRef;
    data['PaymentUrl'] = this.paymentUrl;
    data['statusMessage'] = this.statusMessage;
    data['statusCode'] = this.statusCode;
    return data;
  }
}
