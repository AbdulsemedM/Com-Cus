class AffiliateRegisterRequestDto {
  final String commissionType;
  final String confirmPassword;
  final String country;
  final String countryCode;
  final String deviceId;
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String phoneNumber;
  final String referralCode;
  final String registrationChannel;

  AffiliateRegisterRequestDto({
    required this.commissionType,
    required this.confirmPassword,
    required this.country,
    required this.countryCode,
    required this.deviceId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.phoneNumber,
    required this.referralCode,
    required this.registrationChannel,
  });

  Map<String, dynamic> toJson() {
    return {
      'commissionType': commissionType,
      'confirmPassword': confirmPassword,
      'country': country,
      'countryCode': countryCode,
      'deviceId': deviceId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'phoneNumber': phoneNumber,
      'referralCode': referralCode,
      'registrationChannel': registrationChannel,
    };
  }
}