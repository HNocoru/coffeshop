import 'package:coffeshop/features/products/domain/entities/product.dart' show Product;
import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/utils/view_state.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepository _repository;

  OrderViewModel(this._repository);

  ViewState _state = ViewState.idle;
  String? _errorMessage;

  List<Order> _orders = [];
  Order? _selectedOrder;

  final Map<int, int> _cart = {};
  final Map<int, Product> _cartProducts = {};

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  List<Order> get orders => _orders;
  Order? get selectedOrder => _selectedOrder;

  bool get cartIsEmpty => _cart.isEmpty;

  int cartQuantity(int productId) {
    return _cart[productId] ?? 0;
  }

  double get cartTotal {
    double total = 0;

    for (final entry in _cartProducts.entries) {
      final product = entry.value;
      final qty = _cart[entry.key] ?? 0;
      final price =
          num.tryParse(product.price.toString())?.toDouble() ?? 0.0;

      total += price * qty;
    }

    return total;
  }

  void addToCart(Product product) {
    _cart[product.id] = (_cart[product.id] ?? 0) + 1;
    _cartProducts[product.id] = product;
    notifyListeners();
  }

  void removeFromCart(Product product) {
    final currentQty = _cart[product.id] ?? 0;

    if (currentQty <= 1) {
      _cart.remove(product.id);
      _cartProducts.remove(product.id);
    } else {
      _cart[product.id] = currentQty - 1;
    }

    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _cartProducts.clear();
    notifyListeners();
  }

  Future<bool> createOrder(int table, String? notes) async {
    if (_cart.isEmpty) return false;
  
    _setState(ViewState.loading);
  
    try {
      await _repository.create(
        table,
        notes,
        _cart.entries
            .map(
              (e) => {
                'product_id': e.key,   // ← esto es todo lo que cambia
                'quantity': e.value,
              },
            )
            .toList(),
      );
  
      clearCart();
      _setState(ViewState.success);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _setState(ViewState.error);
      return false;
    } catch (_) {
      _errorMessage = 'Error de conexión';
      _setState(ViewState.error);
      return false;
    }
  }

  Future<bool> updateStatus(
    int id,
    OrderStatus newStatus,
  ) async {
    _setState(ViewState.loading);

    try {
      final updated =
          await _repository.updateStatus(
        id,
        newStatus,
      );

      final idx = _orders.indexWhere(
        (o) => o.id == id,
      );

      if (idx >= 0) {
        _orders[idx] = updated;
      }

      if (_selectedOrder?.id == id) {
        _selectedOrder = updated;
      }

      _setState(ViewState.success);

      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;

      _setState(ViewState.error);

      return false;
    } catch (_) {
      _errorMessage = 'Error de conexión';

      _setState(ViewState.error);

      return false;
    }
  }

  Future<bool> deleteOrder(int id) async {
    _setState(ViewState.loading);
  
    try {
      await _repository.delete(id);
  
      _orders.removeWhere(
        (o) => o.id == id,
      );
  
      _setState(ViewState.success);
  
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
  
      _setState(ViewState.error);
  
      return false;
    } catch (_) {
      _errorMessage = 'Error de conexión';
  
      _setState(ViewState.error);
  
      return false;
    }
  }

  Future<void> loadOrders() async {
    _setState(ViewState.loading);

    try {
      _orders = await _repository.getAll();
      _setState(ViewState.success);
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _setState(ViewState.error);
    } catch (_) {
      _errorMessage = 'Error de conexión';
      _setState(ViewState.error);
    }
  }

  Future<void> loadOrder(int id) async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      _selectedOrder = await _repository.getById(id);
      _state = ViewState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ViewState.error;
    }
    notifyListeners();
  }

  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }
}