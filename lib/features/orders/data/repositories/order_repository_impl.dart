import '../../../../core/network/api_client.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl
    implements OrderRepository {
  final ApiClient _client;

  OrderRepositoryImpl(this._client);

  @override
  Future<List<Order>> getAll() async {
    final data = await _client.get('/api/orders/'); // ✅ trailing slash
    return (data as List)
        .map((json) => OrderModel.fromJson(json))
        .toList();
  }
  
  @override
  Future<Order> getById(int id) async {
    final data = await _client.get('/api/orders/$id'); // ✅ sin slash (es un item, no colección)
    return OrderModel.fromJson(data);
  }

  @override
  Future<Order> create(
    int tableNumber,
    String? notes,
    List<Map<String, int>> items,
  ) async {
  final data = await _client.post(
    '/api/orders/',
    {
      'table_number': tableNumber,
      'notes': notes,
      'items': items,
    },
  );
  
    return OrderModel.fromJson(data);
  }

  // F-09
  @override
  Future<Order> updateStatus(
    int id,
    OrderStatus status,
  ) async {
    final data = await _client.put(
      '/api/orders/$id',
      {
        'status': status.name,
      },
    );
  
    return OrderModel.fromJson(data);
  }
  
  // F-09
  @override
  Future<void> delete(int id) async {
    await _client.delete(
      '/api/orders/$id',
    );
  }
}