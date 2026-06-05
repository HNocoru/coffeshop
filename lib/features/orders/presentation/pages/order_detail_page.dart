import 'package:coffeshop/features/profile/presentation/viewmodel/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/view_state.dart';
import '../../domain/entities/order.dart';
import '../viewmodels/order_viewmodel.dart';
import '../widgets/order_status_chip.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderId;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<OrderViewModel>().loadOrder(widget.orderId),
    );
  }

  // Métodos extraídos del build para claridad — mismo principio que
  // separar casos de uso en el dominio: cada acción tiene su función.
  Future<void> _advanceStatus(Order order) async {
    final next = order.nextStatus;
    if (next == null) return;

    await context.read<OrderViewModel>().updateStatus(order.id, next);

    if (!mounted) return;
    final vm = context.read<OrderViewModel>();
    if (vm.state == ViewState.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage ?? 'Error al actualizar')),
      );
    }
  }

  Future<void> _confirmDelete(Order order) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar pedido'),
        content: const Text('¿Seguro que deseas eliminar este pedido?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await context.read<OrderViewModel>().deleteOrder(order.id);

    if (!mounted) return;
    final vm = context.read<OrderViewModel>();
    if (vm.state == ViewState.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage ?? 'Error al eliminar')),
      );
      return;
    }
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    final profileVM = context.watch<ProfileViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del pedido')),
      body: Consumer<OrderViewModel>(
        builder: (_, vm, _) {
          if (vm.state == ViewState.loading && vm.selectedOrder == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.state == ViewState.error && vm.selectedOrder == null) {
            return Center(child: Text(vm.errorMessage ?? 'Error'));
          }

          final order = vm.selectedOrder;
          if (order == null) {
            return const Center(child: Text('Pedido no encontrado'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [

              // ── Header ───────────────────────────────────────
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pedido #${order.id}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.table_restaurant),
                          const SizedBox(width: 8),
                          Text('Mesa ${order.tableNumber}'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      OrderStatusChip(status: order.status),
                    ],
                  ),
                ),
              ),

              // ── Notas ────────────────────────────────────────
              if (order.notes != null && order.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.note_alt_outlined),
                        const SizedBox(width: 12),
                        Expanded(child: Text(order.notes!)),
                      ],
                    ),
                  ),
                ),
              ],

              // ── Items ────────────────────────────────────────
              const SizedBox(height: 24),
              Text(
                'Productos',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),

              ...order.items.map(
                (item) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(child: Text('${item.quantity}')),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName, // ← nombre real del backend
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Unitario: \$${item.unitPrice.toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${item.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Total ────────────────────────────────────────
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${order.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Avanzar estado ───────────────────────────────
              if (
                order.nextStatus != null &&
                (
                  // Si NO es mesero → puede avanzar siempre
                  !profileVM.isWaiter ||
              
                  // Si es mesero → solo cuando esté READY
                  order.status == OrderStatus.ready
                )
              ) ...[
                FilledButton.icon(
                  icon: const Icon(Icons.arrow_forward),
                  label: Text('Pasar a: ${order.nextStatus!.label}'),
                  onPressed: () => _advanceStatus(order),
                ),
              
                const SizedBox(height: 8),
              ],
              
              // ── Eliminar ─────────────────────────────────────
              if (order.status == OrderStatus.delivered) ...[
                OutlinedButton(
                  onPressed: () => _confirmDelete(order),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('Eliminar pedido'),
                ),
              ]
            ],
          );
        },
      ),
    );
  }
}