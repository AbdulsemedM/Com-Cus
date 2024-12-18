import 'package:commercepal/app/utils/country_manager/country_manager.dart';
import 'package:commercepal/features/home/data/mobile_catalogue_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/data/network/api_provider.dart';
import '../../../app/data/network/end_points.dart';
import '../domain/home_repostory.dart';
import '../domain/schema_settings_model.dart';
import 'schema_settings_dto.dart';
// import 'package:http/http.dart' as http;

@Injectable(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  ApiProvider apiProvider;

  HomeRepositoryImpl(this.apiProvider);
  final countryManager = CountryManager();
  @override
  Future<List<SchemaSettingsModel>?> fetchHomeSchemas() async {
    try {
      final apiResponse = await apiProvider.get(EndPoints.schemaSettings.url);
      if (apiResponse["statusCode"] == "000") {
        final schemaObject = SchemaSettingsDto.fromJson(apiResponse);
        final schemas = schemaObject.toSchemaModel();
//////////////////////////////////////////////////////////////////////////////////////////////////////
        // fetch home mobile catalogue
        // final response = await http.get(
        //   Uri.https(
        //     "h03k5fls-2096.euw.devtunnels.ms",
        //     "/prime/api/v1/app/dashboard/get-setting-mobile-catalogue",
        //     {
        //       "target": "4", // Query parameter
        //     },
        //   ),
        //   headers: <String, String>{
        //     "Content-type": "application/json; charset=utf-8",
        //   },
        // );
        // print("here isntne");
        // print(response.body);
        //////////////////////////////////////////////////////////////////////////////////////////////
        final homeCatalogue =
            await apiProvider.get("${EndPoints.mobileCatalogue.url}?target=4");
        print("i'm back again hh");
        print(homeCatalogue);

        // await countryManager.loadCountryFromPreferences();
        // final String currentCountry = countryManager.country;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String currentCountry = prefs.getString("currency") ?? "ETB";
        final homeCatalogueObject =
            MobileCatalogueDto.fromJson(homeCatalogue, currentCountry);
        // print("Newobject");
        // print(homeCatalogueObject.catalogue);

        schemas?.where((element) {
          // Debug the `targetId` property
          // print("Filtering schema: targetId = ${element.targetId}");
          return element.targetId == 4;
        }).forEach((sectionElement) {
          // print("Processing sectionElement: $sectionElement");

          sectionElement.schemaSections?.forEach((schemeSectionElement) {
            // print(
            //     "Processing schemeSectionElement: key = ${schemeSectionElement.key}, runtimeType = ${schemeSectionElement.key.runtimeType}");

            // Debug matching logic
            final matchingCatalogueElement =
                homeCatalogueObject.catalogue?.where((catalogueElement) {
              // print(
              //     "Checking catalogueElement: key = ${catalogueElement.key}, runtimeType = ${catalogueElement.key.runtimeType}");
              return catalogueElement.key.toString() ==
                  schemeSectionElement.key.toString();
            }).first;

            if (matchingCatalogueElement == null) {
              // print(
              //     "No matching catalogueElement found for key: ${schemeSectionElement.key}");
            } else {
              // print(
              //     "Matching catalogueElement found: $matchingCatalogueElement");
            }

            // Map items and debug
            schemeSectionElement.items =
                matchingCatalogueElement?.items?.map((e) {
              // print("Mapping item: $e");
              final schemaItem = e.toSchemaItem();
              // print("Mapped to schemaItem: $schemaItem");
              return schemaItem;
            }).toList();

            // print(
            //     "Final schemeSectionElement.items: ${schemeSectionElement.items}");
          });
        });

        return schemas;
      } else {
        throw apiResponse['statusMessage'];
      }
    } catch (e) {
      print("I'm the error admit");
      print(e);
      rethrow;
    }
  }
}
