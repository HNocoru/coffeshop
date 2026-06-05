import '../../../../core/network/api_client.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';

import '../../domain/repositories/product_repository.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl
    implements ProductRepository {
  final ApiClient _client;

  ProductRepositoryImpl(this._client);

  @override
  Future<List<Product>> getAllProducts() async {
    final data = await _client.get('/api/products/'); // ✅
    return (data as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }
  
  @override
  Future<List<Category>> getCategories() async {
    final data = await _client.get('/api/categories/'); // ✅
    return (data as List)
        .map((json) => CategoryModel.fromJson(json))
        .toList();
  }
}