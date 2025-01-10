class ProviderConfigModel {
  final String id;
  final List<String> vid;
  final String? name;
  final double originalPrice;
  final double? baseMarkup;

  ProviderConfigModel({
    required this.id,
    required this.vid,
    this.name,
    required this.originalPrice,
    this.baseMarkup,
  });

  // Factory constructor to create an instance from JSON
  factory ProviderConfigModel.fromJson(
      Map<String, dynamic> json, String country) {
    final pricesList = (json['Price']['prices'] as List<dynamic>);

    // Determine the selected price based on country
    final selectedPrice = pricesList.firstWhere(
      (price) => price['currencyCode'] == country,
      orElse: () => {'price': json['Price']['OriginalPrice']},
    );

    // Extract all 'Vid' values from the 'Configurators' array
    final configurators = json['Configurators'] as List<dynamic>;
    final vidList =
        configurators.map((config) => config['Vid'] as String).toList();

    return ProviderConfigModel(
      id: json['Id'] as String,
      vid: vidList,
      originalPrice: (selectedPrice['price'] as num).toDouble(),
      baseMarkup: (selectedPrice['baseMarkup'] as num).toDouble(),
    );
  }
}

List<ProviderConfigModel> parseProviderConfigModelList(
    List<dynamic> jsonList, String countryForm) {
  return jsonList
      .map((json) => ProviderConfigModel.fromJson(json, countryForm))
      .toList();
}
