class AffiliateRegisterResponseDto {
  final String? timeStamp;
  final String? error;
  final String statusCode;
  final String statusMessage;
  final String? requestPath;

  AffiliateRegisterResponseDto({
    this.timeStamp,
    this.error,
    required this.statusCode,
    required this.statusMessage,
    this.requestPath,
  });

  factory AffiliateRegisterResponseDto.fromJson(Map<String, dynamic> json) {
    return AffiliateRegisterResponseDto(
      timeStamp: json['timeStamp'],
      error: json['error'],
      statusCode: json['statusCode'] ?? '',
      statusMessage: json['statusMessage'] ?? '',
      requestPath: json['requestPath'],
    );
  }

  bool get isSuccess => statusCode == '000';
  bool get isError => statusCode != '000';
}