// lib/features/orders/domain/entities/order.dart
import 'order_item.dart';

enum OrderStatus { pending, preparing, ready, delivered }

class Order {
  final int         id;
  final int         tableNumber;
  final OrderStatus status;
  final double      total;
  final String?     notes;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.tableNumber,
    required this.status,
    required this.total,
    this.notes,
    required this.items,
  });

  /// Etiqueta en español para mostrar en la UI
  String get statusLabel => switch (status) {
    OrderStatus.pending   => 'Pendiente',
    OrderStatus.preparing => 'Preparando',
    OrderStatus.ready     => 'Listo',
    OrderStatus.delivered => 'Entregado',
  };

  /// Siguiente estado válido según State Machine del backend.
  /// null = estado final (delivered).
  /// DEBE coincidir con VALID_TRANSITIONS en BACKEND_MODULES.md B-08
  OrderStatus? get nextStatus => switch (status) {
    OrderStatus.pending   => OrderStatus.preparing,
    OrderStatus.preparing => OrderStatus.ready,
    OrderStatus.ready     => OrderStatus.delivered,
    OrderStatus.delivered => null,
  };

  /// String para enviar al backend en PUT /api/orders/{id}
  String get statusString => status.name; // 'pending', 'preparing', etc.
}