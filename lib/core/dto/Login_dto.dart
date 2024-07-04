class LoginDto {
  LoginDto({
    this.userToken,
    this.statusDescription,
    this.changePin,
    this.statusMessage,
    this.statusCode,
    this.refreshToken,
    this.isPhoneProvided,
    this.isEmailProvided,
  });

  LoginDto.fromJson(dynamic json) {
    userToken = json['userToken'];
    statusDescription = json['statusDescription'];
    changePin = json['changePin'];
    statusMessage = json['statusMessage'];
    statusCode = json['statusCode'];
    refreshToken = json['refreshToken'];
    isPhoneProvided = json['isPhoneProvided'];
    isEmailProvided = json['isEmailProvided'];
  }

  String? userToken;
  String? statusDescription;
  int? changePin;
  String? statusMessage;
  String? statusCode;
  String? refreshToken;
  int? isPhoneProvided;
  int? isEmailProvided;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userToken'] = userToken;
    map['statusDescription'] = statusDescription;
    map['changePin'] = changePin;
    map['statusMessage'] = statusMessage;
    map['statusCode'] = statusCode;
    map['refreshToken'] = refreshToken;
    map['isPhoneProvided'] = isPhoneProvided;
    map['isEmailProvided'] = isEmailProvided;
    return map;
  }
}
