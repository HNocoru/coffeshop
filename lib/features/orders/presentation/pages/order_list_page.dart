import 'package:coffeshop/features/profile/presentation/viewmodel/profile_viewmodel.dart';
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
        automaticallyImplyLeading: false,
        actions: [
          // ↓ aquí va el Consumer, reemplaza los dos IconButton anteriores
          Consumer<ProfileViewModel>(
            builder: (_, profileVm, _) => Row(
              children: [
                if (profileVm.profile?.isAdmin ?? false)
                  IconButton(
                    icon: const Icon(Icons.point_of_sale_outlined),
                    tooltip: 'Vista cajero',
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.cashier),
                  ),
                IconButton(
                  icon: const Icon(Icons.person_outline),
                  tooltip: 'Perfil',
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.profile),
                ),
              ],
            ),
          ),
        ],
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
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(vm.errorMessage ?? 'Error'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<OrderViewModel>().loadOrders(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          if (vm.orders.isEmpty) {
            return const Center(child: Text('No hay pedidos'));
          }
          return RefreshIndicator(
            onRefresh: () => context.read<OrderViewModel>().loadOrders(),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: vm.orders.length,
              itemBuilder: (_, i) {
                final order = vm.orders[i];
                return Card(
                  child: ListTile(
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.orderDetail,
                      arguments: order.id,
                    ),
                    title: Text('Mesa ${order.tableNumber}'),
                    subtitle: Text(
                        'Total: \$${order.total.toStringAsFixed(2)}'),
                    trailing: OrderStatusChip(status: order.status),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}