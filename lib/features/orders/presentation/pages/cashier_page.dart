import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/view_state.dart';
import '../../domain/entities/order.dart';
import '../viewmodels/order_viewmodel.dart';
import '../widgets/order_status_chip.dart';

class CashierPage extends StatefulWidget {
  const CashierPage({super.key});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<OrderViewModel>().loadOrders());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrderViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista Cajero'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: () => context.read<OrderViewModel>().loadOrders(),
          ),
        ],
      ),
      body: switch (vm.state) {
        ViewState.loading => const Center(child: CircularProgressIndicator()),
        ViewState.error => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(vm.errorMessage ?? 'Error'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.read<OrderViewModel>().loadOrders(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        _ => RefreshIndicator(
            onRefresh: () => context.read<OrderViewModel>().loadOrders(),
            child: _CashierBody(orders: vm.orders),
          ),
      },
    );
  }
}

class _CashierBody extends StatelessWidget {
  final List<Order> orders;
  const _CashierBody({required this.orders});

  @override
  Widget build(BuildContext context) {
    final active = orders
        .where((o) => o.status != OrderStatus.delivered)
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));

    if (active.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
            SizedBox(height: 12),
            Text('Sin pedidos activos'),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: active.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _CashierOrderCard(order: active[i]),
    );
  }
}

class _CashierOrderCard extends StatelessWidget {
  final Order order;
  const _CashierOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final nextStatus = order.nextStatus; // getter de Order, delega al enum

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Encabezado ───────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.table_restaurant, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Mesa ${order.tableNumber}  •  #${order.id}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                OrderStatusChip(status: order.status),
              ],
            ),

            // ── Notas ────────────────────────────────────────
            if (order.notes != null && order.notes!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.sticky_note_2_outlined, size: 14),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      order.notes!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],

            // ── Items con nombre real ─────────────────────────
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),

            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 11,
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item.productName)),
                  ],
                ),
              ),
            ),

            // ── Total ────────────────────────────────────────
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total: \$${order.total.toStringAsFixed(2)}',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 12),

            // ── Acción ───────────────────────────────────────
            if (nextStatus != null)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: Text('Pasar a: ${nextStatus.label}'),
                  onPressed: () async {
                    await context
                        .read<OrderViewModel>()
                        .updateStatus(order.id, nextStatus);

                    if (!context.mounted) return;
                    final vm = context.read<OrderViewModel>();
                    if (vm.state == ViewState.error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            vm.errorMessage ?? 'Error al actualizar',
                          ),
                        ),
                      );
                    }
                  },
                ),
              )
            else
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Pedido entregado',
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}