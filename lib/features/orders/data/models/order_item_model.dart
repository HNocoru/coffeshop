// lib/features/orders/data/models/order_item_model.dart
import '../../domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.id,
    required super.productId,
    required super.quantity,
    required super.unitPrice,
    required super.subtotal,
  });

  /// Mapea cada objeto de la lista "items" en la respuesta de /api/orders
  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
    id:        json['id']         as int,
    productId: json['product_id'] as int,
    quantity:  json['quantity']   as int,
    unitPrice: (json['unit_price'] as num).toDouble(),
    subtotal:  (json['subtotal']   as num).toDouble(),
  );
}