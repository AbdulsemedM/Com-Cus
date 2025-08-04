class ProviderConfigModel {
  final String id;
  final List<String> vid;
  final String? name;
  final double originalPrice;
  final double? baseMarkup;
  final List<dynamic>? tieredPrices;
  final double? additionalItemPrice;

  ProviderConfigModel({
    required this.id,
    required this.vid,
    this.name,
    required this.originalPrice,
    this.baseMarkup,
    this.tieredPrices,
    this.additionalItemPrice,
  });

  // Factory constructor to create an instance from JSON
  factory ProviderConfigModel.fromJson(
      Map<String, dynamic> json, String country, String countryCode) {
    // print(countryCode);
    // print(json['Price']['prices'].firstWhere((p) => p['countryCode'] == countryCode));
    final pricesList = (json['Price']['prices'])
        .firstWhere((p) => p['countryCode'] == countryCode);
    // print(pricesList);

    // Determine the selected price based on country
    final selectedPrice = pricesList['prices'].firstWhere(
      (price) => price['currencyCode'] == country,
      orElse: () => {'price': json['Price']['OriginalPrice']},
    );
    print("the first price");
    print(selectedPrice['price']);
    // print("selectedPrice");
    // print(selectedPrice['baseMarkup']);
    // Extract all 'Vid' values from the 'Configurators' array
    final configurators = json['Configurators'] as List<dynamic>;
    final vidList =
        configurators.map((config) => config['Vid'] as String).toList();

    final tieredPrices = selectedPrice["priceConfig"]["tieredPrices"] as List;
    final additionalItemPrice =
        selectedPrice["priceConfig"]["additionalItemPrice"];
    print("here is the string");
    print(tieredPrices);
    // var c = tieredPrices.toString();

    // List<double> parseTieredPrices(String priceString) {
    //   // Remove the square brackets and split by comma
    //   String cleanString = priceString.replaceAll('[', '').replaceAll(']', '');
    //   List<String> priceStrings =
    //       cleanString.split(',').map((e) => e.trim()).toList();

    //   // Convert each string to double
    //   return priceStrings.map((e) => double.parse(e)).toList();
    // }

    // // Use the function
    // List<double> prices = parseTieredPrices(c);
    // print("Parsed prices:");
    // for (var price in prices) {
    //   print(price);
    // }
    print(additionalItemPrice);

    return ProviderConfigModel(
        id: json['Id'] as String,
        vid: vidList,
        originalPrice: (selectedPrice['price'] as num).toDouble(),
        baseMarkup: 0,
        tieredPrices: tieredPrices,
        additionalItemPrice: double.parse(additionalItemPrice.toString()));
  }
}

List<ProviderConfigModel> parseProviderConfigModelList(
    List<dynamic> jsonList, String countryForm, String countryCode) {
  return jsonList
      .map((json) =>
          ProviderConfigModel.fromJson(json, countryForm, countryCode))
      .toList();
}
