import 'package:commercepal/features/products/domain/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts(
      num? subCatId, Map? queryParams, bool? filter);

  Future<List<Product>> searchProduct(String? search, num? size);
  Future<List<Product>> searchByImage(String? image);
}
