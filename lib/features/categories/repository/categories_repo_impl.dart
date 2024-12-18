import 'package:commercepal/app/data/network/api_provider.dart';
import 'package:commercepal/app/data/network/end_points.dart';
import 'package:commercepal/core/session/data/session_repo_impl.dart';
import 'package:injectable/injectable.dart';

import '../../../core/data/prefs_data.dart';
import '../../../core/session/domain/session_repo.dart';
import '../dto/categories_dto.dart';
import '../dto/parent_categories_dto.dart';
import '../../../core/models/category_model.dart';
import '../models/parent_categories_model.dart';
import 'categories_repo.dart';

@Injectable(as: CategoriesRepo)
class CategoriesRepoImpl implements CategoriesRepo {
  final ApiProvider apiProvider;
  final SessionRepo sessionRepo;

  CategoriesRepoImpl(this.sessionRepo, this.apiProvider);

  @override
  Future<List<ParentCategoryModel>> getParentCategories() async {
    try {
      final response = await apiProvider.get(EndPoints.parentCategories.url);
      if (response['statusCode'] == "000") {
        final pCategoriesObject = ParentCategoriesDto.fromJson(response);
        if (pCategoriesObject.details?.isEmpty == true) {
          throw 'Parent categories not found';
        }

//         print("Starting ParentCategoryModel mapping process...");

//         final details = pCategoriesObject.details!;
//         print("Details length: ${details.length}");

//         for (var i = 0; i < details.length; i++) {
//           final detail = details[i];
//           print("Processing detail at index $i: $detail");

//           try {
//             final parentCategoryModel = detail.toParentCategoryModel();
//             print("Converted to ParentCategoryModel: $parentCategoryModel");
//           } catch (e, stackTrace) {
//             print("Error converting detail at index $i: $e\n$stackTrace");
//           }
//         }

// // Mapping process
//         final parentCategoryModels = details.map((e) {
//           print("Mapping detail: $e");
//           try {
//             final parentCategoryModel = e.toParentCategoryModel();
//             print("Successfully mapped: $parentCategoryModel");
//             return parentCategoryModel;
//           } catch (e, stackTrace) {
//             print("Error during mapping: $e\n$stackTrace");
//             rethrow; // Rethrow to identify breaking issues
//           }
//         }).toList();

//         print("Final mapped list: ${parentCategoryModels.last.name}");

        return pCategoriesObject.details!
            .map((e) => e.toParentCategoryModel())
            .toList();
      } else {
        throw response['statusMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> fetchCategories(num parentId) async {
    try {
      final response = await apiProvider
          .get("${EndPoints.categories.url}?parentCat=$parentId");
      if (response['statusCode'] == "000") {
        final categories = CategoriesDto.fromJson(response);
        print(response);
        if (categories.details?.isEmpty == true) {
          throw 'Categories not found';
        }
        // Iterate through details step by step
//         print("Starting mapping process...");

//         final details = categories.details!;
//         print("Details length: ${details.length}");
//         for (var i = 0; i < details.length; i++) {
//           final detail = details[i];
//           print("Processing detail at index $i: $detail");

//           try {
//             final categoryModel = detail.toCategoryModel();
//             print("Converted to CategoryModel: $categoryModel");
//           } catch (e, stackTrace) {
//             print("Error converting detail at index $i: $e\n$stackTrace");
//           }
//         }

// // Collect all converted items into a list
//         final categoryModels = details.map((e) {
//           print("Mapping detail: $e");
//           try {
//             final categoryModel = e.toCategoryModel();
//             print("Successfully mapped: $categoryModel");
//             return categoryModel;
//           } catch (e, stackTrace) {
//             print("Error during mapping: $e\n$stackTrace");
//             rethrow; // Rethrow to identify breaking issues
//           }
//         }).toList();

//         print("Final mapped list: $categoryModels.");

        return categories.details!.map((e) => e.toCategoryModel()).toList();
      } else {
        throw response['statusMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }
}
