// lib/features/orders/data/models/order_model.dart
import '../../domain/entities/order.dart';
import 'order_item_model.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.tableNumber,
    required super.status,
    required super.total,
    super.notes,
    required super.items,
  });

  /// Mapea el campo "status" (string del backend) al enum de Flutter.
  /// Valores posibles: "pending" | "preparing" | "ready" | "delivered"
  static OrderStatus _parseStatus(String s) =>
      OrderStatus.values.firstWhere((e) => e.name == s);

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id:          json['id']           as int,
    tableNumber: json['table_number'] as int,
    status:      _parseStatus(json['status'] as String),
    total:       (json['total']        as num).toDouble(),
    notes:       json['notes']         as String?,
    items: (json['items'] as List)
        .map((i) => OrderItemModel.fromJson(i as Map<String, dynamic>))
        .toList(),
  );
}