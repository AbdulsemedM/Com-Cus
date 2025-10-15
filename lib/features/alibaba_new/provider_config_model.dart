import 'package:commercepal/app/utils/logger.dart';
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
    // appLog(countryCode);
    // appLog(json['Price']['prices'].firstWhere((p) => p['countryCode'] == countryCode));
    final pricesList = (json['Price']['prices'])
        .firstWhere((p) => p['countryCode'] == countryCode);
    // appLog(pricesList);

    // Determine the selected price based on country
    final selectedPrice = pricesList['prices'].firstWhere(
      (price) => price['currencyCode'] == country,
      orElse: () => {'price': json['Price']['OriginalPrice']},
    );
    appLog("the first price");
    appLog(selectedPrice['price']);
    // appLog("selectedPrice");
    // appLog(selectedPrice['baseMarkup']);
    // Extract all 'Vid' values from the 'Configurators' array
    final configurators = json['Configurators'] as List<dynamic>;
    final vidList =
        configurators.map((config) => config['Vid'] as String).toList();

    final tieredPrices = selectedPrice["priceConfig"]["tieredPrices"] as List;
    final additionalItemPrice =
        selectedPrice["priceConfig"]["additionalItemPrice"];
    appLog("here is the string");
    appLog(tieredPrices);
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
    // appLog("Parsed prices:");
    // for (var price in prices) {
    //   appLog(price);
    // }
    appLog(additionalItemPrice);

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
