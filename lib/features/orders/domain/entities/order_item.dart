class OrderItem {
  final int    id;
  final int    productId;
  final String productName; // ← nuevo: necesario para CashierPage y DetailPage
  final int    quantity;
  final double unitPrice;
  final double subtotal;

  const OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });
}