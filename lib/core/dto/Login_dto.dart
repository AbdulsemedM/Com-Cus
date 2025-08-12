class LoginDto {
  LoginDto({
    this.userToken,
    this.statusDescription,
    this.statusMessage,
    this.statusCode,
    this.refreshToken,
    this.meta,
  });

  LoginDto.fromJson(dynamic json) {
    statusDescription = json['statusDescription'];
    statusMessage = json['statusMessage'];
    statusCode = json['statusCode'];
    
    if (json['responseData'] != null) {
      userToken = json['responseData']['token'];
      refreshToken = json['responseData']['refreshToken'];
      meta = json['responseData']['meta'] != null 
          ? MetaData.fromJson(json['responseData']['meta']) 
          : null;
    }
  }

  String? userToken;
  String? statusDescription;
  String? statusMessage;
  String? statusCode;
  String? refreshToken;
  MetaData? meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusDescription'] = statusDescription;
    map['statusMessage'] = statusMessage;
    map['statusCode'] = statusCode;
    
    if (userToken != null || refreshToken != null || meta != null) {
      map['responseData'] = <String, dynamic>{};
      if (userToken != null) map['responseData']['token'] = userToken;
      if (refreshToken != null) map['responseData']['refreshToken'] = refreshToken;
      if (meta != null) map['responseData']['meta'] = meta!.toJson();
    }
    
    return map;
  }
}

class MetaData {
  MetaData({
    this.fullName,
    this.loginAs,
    this.roles,
    this.isPhoneVerified,
    this.isEmailVerified,
  });

  MetaData.fromJson(dynamic json) {
    fullName = json['fullName'];
    loginAs = json['loginAs'];
    roles = json['roles'] != null ? json['roles'].cast<String>() : [];
    isPhoneVerified = json['isPhoneVerified'];
    isEmailVerified = json['isEmailVerified'];
  }

  String? fullName;
  String? loginAs;
  List<String>? roles;
  bool? isPhoneVerified;
  bool? isEmailVerified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fullName'] = fullName;
    map['loginAs'] = loginAs;
    map['roles'] = roles;
    map['isPhoneVerified'] = isPhoneVerified;
    map['isEmailVerified'] = isEmailVerified;
    return map;
  }
}
