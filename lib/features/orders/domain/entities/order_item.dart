// lib/features/orders/domain/entities/order_item.dart
class OrderItem {
  final int    id;
  final int    productId;
  final int    quantity;
  final double unitPrice;
  final double subtotal;

  const OrderItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });
}