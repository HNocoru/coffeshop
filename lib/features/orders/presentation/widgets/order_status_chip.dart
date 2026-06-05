import 'package:flutter/material.dart';
import '../../domain/entities/order.dart';

class OrderStatusChip extends StatelessWidget {
  final OrderStatus status;
  const OrderStatusChip({super.key, required this.status});

  Color get _color => switch (status) {
    OrderStatus.pending   => Colors.orange,
    OrderStatus.preparing => Colors.blue,
    OrderStatus.ready     => Colors.green,
    OrderStatus.delivered => Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        status.label, // ← usa la extension, no duplica strings aquí
        style: TextStyle(
          color: _color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: _color.withValues(alpha: 0.15),
      side: BorderSide(color: _color.withValues(alpha: 0.4)),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}