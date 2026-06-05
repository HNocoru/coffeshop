import 'package:flutter/material.dart';

import '../../domain/entities/order.dart';

class OrderStatusChip extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusChip({
    super.key,
    required this.status,
  });

  Color _color() {
    return switch (status) {
      OrderStatus.pending => Colors.orange,

      OrderStatus.preparing => Colors.blue,

      OrderStatus.ready => Colors.green,

      OrderStatus.delivered => Colors.grey,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        switch (status) {
          OrderStatus.pending => 'Pendiente',

          OrderStatus.preparing => 'Preparando',

          OrderStatus.ready => 'Listo',

          OrderStatus.delivered => 'Entregado',
        },
      ),

      backgroundColor: _color().withValues(alpha: 0.15),

      side: BorderSide.none,
    );
  }
}