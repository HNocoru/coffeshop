import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/view_state.dart';
import '../viewmodels/order_viewmodel.dart';
import '../widgets/order_status_chip.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});
  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<OrderViewModel>().loadOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        automaticallyImplyLeading: false,   // ← es la pantalla raíz, sin back
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.createOrder),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo pedido'),
      ),
      body: Consumer<OrderViewModel>(
        builder: (_, vm, _) {
          if (vm.state == ViewState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.state == ViewState.error) {
            return Center(child: Text(vm.errorMessage ?? 'Error'));
          }
          if (vm.orders.isEmpty) {
            return const Center(child: Text('No hay pedidos'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: vm.orders.length,
            itemBuilder: (_, index) {
              final order = vm.orders[index];
              return Card(
                child: ListTile(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.orderDetail,
                    arguments: order.id,
                  ),
                  title: Text('Mesa ${order.tableNumber}'),
                  subtitle: Text('Total: \$${order.total.toStringAsFixed(2)}'),
                  trailing: OrderStatusChip(status: order.status),
                ),
              );
            },
          );
        },
      ),
    );
  }
}