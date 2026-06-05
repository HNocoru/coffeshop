import 'package:flutter/foundation.dart' hide Category;
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/view_state.dart';
import '../../domain/entities/category.dart' as Category;
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository _repository;

  ProductViewModel(this._repository);

  ViewState _state = ViewState.idle;
  String? _errorMessage;

  List<Product> _products = [];
  List<Category.Category> _categories = [];
  int? _selectedCategoryId;

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;

  List<Product> get products => _products;

  List<Category.Category> get categories => _categories;
  int? get selectedCategoryId => _selectedCategoryId;

  List<Product> get filteredProducts {
    if (_selectedCategoryId == null) {
      return _products;
    }

    return _products.where((product) {
      return product.categoryId == _selectedCategoryId;
    }).toList();
  }

  Future<void> loadData() async {
    _setState(ViewState.loading);

    try {
      final results = await Future.wait([
        _repository.getAllProducts(),
        _repository.getCategories(),
      ]);

      _products =
          results[0] as List<Product>;

      _categories =
          results[1] as List<Category.Category>;

      _setState(ViewState.success);
    } on ApiException catch (e) {
      _errorMessage = e.message;

      _setState(ViewState.error);
    } catch (_) {
      _errorMessage =
          'Error de conexión';

      _setState(ViewState.error);
    }
  }

  void filterByCategory(int? id) {
    _selectedCategoryId = id;

    notifyListeners();
  }

  void _setState(ViewState state) {
    _state = state;

    notifyListeners();
  }
}