import 'order_item.dart';

enum OrderStatus { pending, preparing, ready, delivered }

// Extension sobre el enum: la lógica de transición vive aquí,
// no en la UI ni en la Order. Igual que un método estático en una
// clase de utilidad — cualquier capa puede usarlo sin depender de Order.
extension OrderStatusX on OrderStatus {
  String get label => switch (this) {
    OrderStatus.pending   => 'Pendiente',
    OrderStatus.preparing => 'Preparando',
    OrderStatus.ready     => 'Listo',
    OrderStatus.delivered => 'Entregado',
  };

  OrderStatus? get next => switch (this) {
    OrderStatus.pending   => OrderStatus.preparing,
    OrderStatus.preparing => OrderStatus.ready,
    OrderStatus.ready     => OrderStatus.delivered,
    OrderStatus.delivered => null,
  };
}

class Order {
  final int    id;
  final int    tableNumber;
  final OrderStatus status;
  final double total;
  final String? notes;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.tableNumber,
    required this.status,
    required this.total,
    this.notes,
    required this.items,
  });

  // Delegates al enum — Order no duplica la lógica, la delega
  String        get statusLabel  => status.label;
  OrderStatus?  get nextStatus   => status.next;
  String        get statusString => status.name;
}