import 'package:coffeshop/features/orders/domain/entities/order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/view_state.dart';

import '../viewmodels/order_viewmodel.dart';

import '../widgets/order_status_chip.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderId;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  
    if (_loaded) return;
  
    final args = ModalRoute.of(context)?.settings.arguments;
  
    debugPrint('DETAIL ARGS: $args');
    debugPrint('DETAIL TYPE: ${args.runtimeType}');
  
    int? id;
    if (args is int) id = args;
    if (args is String) id = int.tryParse(args);
  
    if (id == null) {
      debugPrint('❌ ID inválido, no se puede cargar detalle');
      return;
    }
  
    _loaded = true;
    Future.microtask(() {
      context.read<OrderViewModel>().loadOrder(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del pedido'),
        // ✅ Flutter lo pone automático con push, pero por si acaso:
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),

      body: Consumer<OrderViewModel>(
        builder: (_, vm, _) {
          if (vm.state == ViewState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.state == ViewState.error) {
            return Center(child: Text(vm.errorMessage ?? 'Error'));
          }

          final order = vm.selectedOrder;

          if (order == null) {
            return const Center(child: Text('Pedido no encontrado'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),

            children: [
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

              const SizedBox(height: 12),

              OrderStatusChip(status: order.status),

              const SizedBox(height: 16),

              Text('Total: \$${order.total.toStringAsFixed(2)}'),

              if (order.notes != null && order.notes!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),

                  child: order.notes != null && order.notes!.isNotEmpty
                      ? Card(
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
                        )
                      : const SizedBox.shrink(),
                ),

              const SizedBox(height: 24),

              Text('Productos', style: Theme.of(context).textTheme.titleMedium),
              
              const SizedBox(height: 12),

              ...order.items.map((item) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),

                  child: Padding(
                    padding: const EdgeInsets.all(12),

                    child: Row(
                      children: [
                        CircleAvatar(
                          child: Text('${item.quantity}'),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                'Producto #${item.productId}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text('Cantidad: ${item.quantity}'),

                              Text('Unitario: \$${item.unitPrice}'),
                            ],
                          ),
                        ),

                        Text(
                          '\$${item.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
          
              // 4️⃣ TOTAL — tu Card
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
          
              if (order.status != OrderStatus.delivered)
                SizedBox(
                  width: double.infinity,

                  child: OutlinedButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,

                        builder: (_) {
                          return AlertDialog(
                            title: const Text('Eliminar pedido'),

                            content: const Text(
                              '¿Seguro que deseas eliminar este pedido?',
                            ),

                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },

                                child: const Text('Cancelar'),
                              ),

                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },

                                child: const Text('Eliminar'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm != true) return;

                      final success = await context
                          .read<OrderViewModel>()
                          .deleteOrder(order.id);

                      if (!context.mounted) return;

                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(vm.errorMessage ?? 'Error')),
                        );

                        return;
                      }

                      Navigator.pop(context);
                    },

                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),

                    child: const Text('Eliminar pedido'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
