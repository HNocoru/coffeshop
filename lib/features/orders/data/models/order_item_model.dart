import '../../domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.quantity,
    required super.unitPrice,
    required super.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    // El backend puede retornar el nombre de 3 formas distintas.
    // El operador ?? encadena fallbacks, como un try-catch silencioso.
    final productName =
        json['product_name'] as String? ??
        (json['product'] as Map<String, dynamic>?)?['name'] as String? ??
        'Producto #${json['product_id']}';

    return OrderItemModel(
      id:          json['id']          as int,
      productId:   json['product_id']  as int,
      productName: productName,
      quantity:    json['quantity']    as int,
      unitPrice:   (json['unit_price'] as num).toDouble(),
      subtotal:    (json['subtotal']   as num).toDouble(),
    );
  }
}