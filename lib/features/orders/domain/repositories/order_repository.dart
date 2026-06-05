// lib/features/orders/domain/repositories/order_repository.dart
import '../entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getAll();
  Future<Order>       getById(int id);
  Future<Order>       create(int tableNumber, String? notes, List<Map<String, int>> items);
  Future<Order>       updateStatus(int id, OrderStatus status);
  Future<void>        delete(int id);
}