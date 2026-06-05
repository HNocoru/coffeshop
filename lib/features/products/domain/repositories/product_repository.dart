import '../entities/category.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getAllProducts();

  Future<List<Category>> getCategories();
}